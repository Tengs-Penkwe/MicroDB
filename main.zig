const std = @import("std");

//Standard In/Out put
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

const InputBuffer = struct {
    buffer: []u8,
    buffer_length: usize,
};

pub const MetaCommandResult = enum {
    META_COMMAND_SUCCESS,
    META_COMMAND_UNRECOGNIZED_COMMAND,
};

pub const PrepareResult = enum {
    PREPARE_SUCCESS,
    PREPARE_UNRECOGNIZED_STATEMENT,
};

pub const StatementType = enum {
    STATEMENT_INSERT,
    STATEMENT_SELECT,
};

fn readInput(allocator: std.mem.Allocator) !InputBuffer {
    const line = try stdin.readUntilDelimiterAlloc(allocator, '\n', 1024);

    std.debug.print("< {s} \n", .{line});

    return InputBuffer{
        .buffer = line,
        .buffer_length = line.len,
    };
}

fn printPrompt() !void {
    try stdout.print("db > ", .{});
}

fn do_meta_command(input: *InputBuffer) MetaCommandResult {
    if (std.mem.eql(u8, input.buffer, ".exit")) {
        std.debug.print("Exiting.\n", .{});
        std.os.exit(1);
    } else {
        return .META_COMMAND_UNRECOGNIZED_COMMAND;
    }
}

fn prepare_statement(input: *InputBuffer) PrepareResult {
    if (std.mem.eql(u8, input.buffer, "insert")) {} else {
        return .META_COMMAND_UNRECOGNIZED_COMMAND;
    }
}

fn execute_statement(state: StatementType) void {
    _ = state;
}

fn parse(input: *InputBuffer) void {
    switch (do_meta_command(input)) {
        .META_COMMAND_UNRECOGNIZED_COMMAND => std.debug.print("Unrecognized command '{s}'.\n", .{input.buffer}),

        else => unreachable,
    }

    const statement = switch (prepare_statement(input)) {
        else => 3,
    };

    execute_statement(statement);

    return;
}

pub fn main() !void {
    //Allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();
    // _ = allocator;
    defer {
        //TODO: deal with it
        _ = gpa.deinit();
    }

    // var inputBuffer = InputBuffer{
    //     .buffer = null,
    //     .buffer_length = 0,
    // };

    while (true) {
        try printPrompt();
        var input = try readInput(allocator);

        parse(&input);

        // try inputs.read_input(allocator);
    }
}
