const std = @import("std");

//Standard In/Out put
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

const InputBuffer = struct {
    buffer: []u8,
    buffer_length: usize,
};

fn readInput() !*InputBuffer {
    var inputBuffer = InputBuffer{
        .buffer = null,
        .buffer_length = 0,
    };

    const result = try stdin.readUntilDelimiterOrEof(inputBuffer.buffer, '\n');
    inputBuffer.buffer_length = result;

    return inputBuffer;
}

pub fn main() !void {
    //Allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    _ = allocator;
    defer {
        //TODO: deal with it
        _ = gpa.deinit();
    }

    // var inputBuffer = InputBuffer{
    //     .buffer = null,
    //     .buffer_length = 0,
    // };

    while (true) {
        // try readInput(&inputBuffer);
        // std.debug.print("\t here:{s}\n", .{line});

        // try inputs.read_input(allocator);
    }
}
