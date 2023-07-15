const std = @import("std");

const stdout_file = std.io.getStdOut().writer();
var bw = std.io.bufferedWriter(stdout_file);
const stdout = bw.writer();

pub fn main() !u8 {
    defer bw.flush() catch {};
    if (std.os.argv.len < 2) {
        stdout.print("Usage: {s} <binary>\n", .{std.os.argv[0]}) catch {};
        return 255;
    }

    // load file into memory
    const fd = try std.os.openZ(std.os.argv[1], std.os.O.RDONLY, 0);
    defer std.os.close(fd);

    const stat = try std.os.fstat(fd);

    const mem = try std.os.mmap(
        null,
        @as(usize, @intCast(stat.size)),
        std.os.PROT.READ,
        std.os.MAP.PRIVATE,
        fd,
        0,
    );

    // verify elf magic
    if (!std.mem.eql(u8, mem[0..4], "\x7FELF")) {
        try stdout.print("ELF magic is wrong: \"{}\" is not \"{}\"\n", .{ std.fmt.fmtSliceEscapeUpper(mem[0..4]), std.fmt.fmtSliceEscapeUpper("\x7fELF") });
        return 255;
    }

    // read headers
    // the initial elf header always starts at offset 0
    const ehdr = @as(*std.elf.Elf64_Ehdr, @ptrCast(mem));
    // the section header and program header table offsets are in ehdr
    const phdr = @as([*]std.elf.Elf64_Phdr, @ptrCast(@alignCast(&mem[ehdr.e_phoff])));
    const shdr = @as([*]std.elf.Elf64_Shdr, @ptrCast(@alignCast(&mem[ehdr.e_shoff])));

    // this code only handles executables
    if (ehdr.e_type != std.elf.ET.EXEC) {
        try stdout.print("Not an executable file\n", .{});
        return 255;
    }

    try stdout.print("Entry point: 0x{x}\n", .{ehdr.e_entry});

    // find string table
    const string_table = @as([*:0]u8, @ptrCast(@alignCast(&mem[shdr[ehdr.e_shstrndx].sh_offset])));

    const indentfmt = std.fmt.comptimePrint("{{s: >{}}}", .{24});

    // print sections
    try stdout.print("Section header list:\n", .{});
    {
        var i: usize = 0;
        while (i < ehdr.e_shnum) : (i += 1) {
            try stdout.print(indentfmt ++ ": 0x{x}\n", .{ string_table + shdr[i].sh_name, shdr[i].sh_addr });
        }
    }

    // print segments
    try stdout.print("Program header list:\n", .{});
    {
        var i: usize = 0;
        while (i < ehdr.e_phnum) : (i += 1) {
            switch (phdr[i].p_type) {
                std.elf.PT_LOAD => {
                    // the text segment starts at offset 0, and the only other possible
                    // PT_LOAD segment is the data segment
                    if (phdr[i].p_offset == 0) {
                        try stdout.print(indentfmt ++ ": 0x{x}\n", .{ "text segment", phdr[i].p_vaddr });
                    } else {
                        try stdout.print(indentfmt ++ ": 0x{x}\n", .{ "data segment", phdr[i].p_vaddr });
                    }
                },
                std.elf.PT_INTERP => try stdout.print(indentfmt ++ ": {s}\n", .{ "interpreter", &mem[phdr[i].p_offset] }),
                std.elf.PT_NOTE => try stdout.print(indentfmt ++ ": 0x{x}\n", .{ "note", phdr[i].p_vaddr }),
                std.elf.PT_DYNAMIC => try stdout.print(indentfmt ++ ": 0x{x}\n", .{ "dynamic", phdr[i].p_vaddr }),
                std.elf.PT_PHDR => try stdout.print(indentfmt ++ ": 0x{x}\n", .{ "phdr", phdr[i].p_vaddr }),
                else => |t| try stdout.print(indentfmt ++ ": (not parsed)\n", .{stringFromPtype(t)}),
            }
        }
    }

    return 0;
}

fn stringFromPtype(typ: std.elf.Elf64_Word) []const u8 {
    // taken from /lib/std/elf.zig, which contains some os-specific duplicate values. I
    // manually deduplicated them, and the choices of which got to stay was pretty
    // arbitrary.
    return switch (typ) {
        std.elf.PT_NULL => "PT_NULL",
        std.elf.PT_LOAD => "PT_LOAD",
        std.elf.PT_DYNAMIC => "PT_DYNAMIC",
        std.elf.PT_INTERP => "PT_INTERP",
        std.elf.PT_NOTE => "PT_NOTE",
        std.elf.PT_SHLIB => "PT_SHLIB",
        std.elf.PT_PHDR => "PT_PHDR",
        std.elf.PT_TLS => "PT_TLS",
        std.elf.PT_NUM => "PT_NUM",
        std.elf.PT_LOOS => "PT_LOOS",
        std.elf.PT_GNU_EH_FRAME => "PT_GNU_EH_FRAME",
        std.elf.PT_GNU_STACK => "PT_GNU_STACK",
        std.elf.PT_GNU_RELRO => "PT_GNU_RELRO",
        std.elf.PT_LOSUNW => "PT_LOSUNW",
        std.elf.PT_SUNWSTACK => "PT_SUNWSTACK",
        std.elf.PT_HIOS => "PT_HIOS",
        std.elf.PT_LOPROC => "PT_LOPROC",
        std.elf.PT_HIPROC => "PT_HIPROC",
        else => "(unknown)",
    };
}
