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

    // std.debug.print("< {s} \n", .{line});

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

fn prepare_statement(input: *InputBuffer) struct {
    prepare: PrepareResult,
    state: ?StatementType,
} {
    if (std.mem.eql(u8, input.buffer, "insert")) {
        return .{
            .prepare = .PREPARE_SUCCESS,
            .state = .STATEMENT_INSERT,
        };
    } else if (std.mem.eql(u8, input.buffer, "select")) {
        return .{
            .prepare = .PREPARE_SUCCESS,
            .state = .STATEMENT_SELECT,
        };
    } else {
        return .{
            .prepare = .PREPARE_UNRECOGNIZED_STATEMENT,
            .state = null,
        };
    }
}

fn execute_statement(state: StatementType) void {
    switch (state) {
        .STATEMENT_INSERT => std.debug.print("This is where we would do an insert.\n", .{}),
        .STATEMENT_SELECT => std.debug.print("This is where we would do an select.\n", .{}),
    }
}

fn parse(input: *InputBuffer) void {
    if (input.buffer[0] == '.') {
        switch (do_meta_command(input)) {
            .META_COMMAND_SUCCESS => {},
            .META_COMMAND_UNRECOGNIZED_COMMAND => std.debug.print("Unrecognized command '{s}'.\n", .{input.buffer}),
        }
    }

    const prepare = prepare_statement(input);
    const statement = switch (prepare.prepare) {
        .PREPARE_SUCCESS => prepare.state,
        .PREPARE_UNRECOGNIZED_STATEMENT => {
            std.debug.print("Unrecognized statement '{s}'.\n", .{input.buffer});
            return;
        },
    };

    execute_statement(statement.?);

    return;
}

pub fn main() !void {
    //Allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();
    defer {
        _ = gpa.deinit();
    }

    while (true) {
        try printPrompt();
        var input = try readInput(allocator);

        parse(&input);

        // try inputs.read_input(allocator);
    }
}
