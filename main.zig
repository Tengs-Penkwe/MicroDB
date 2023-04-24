const std = @import("std");

//Standard In/Out put
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

const Inputs = struct {
    commands: std.ArrayList([]const u8),

    pub fn read_input(self: *@This(), allocator: std.mem.Allocator) !void {
        var buffer: [1024]u8 = undefined;
        const length: usize = try stdin.readUntilDelimiterOrEof(&buffer, '\n');
        const command = buffer[0..length];

        if (!valid(command)) {
            return;
        }

        const copied_command = try allocator.dupe(u8, command);
        try self.commands.append(copied_command);
    }

    fn valid(command: []const u8) bool {
        //TODO: test if the command is valid;
        _ = command;
        return true;
    }
};

pub fn print_prompt() !void {
    _ = try stdout.write("db > ");
}

pub fn main() !void {
    //Allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer {
        //ALARM: deal with it
        _ = gpa.deinit();
    }

    var inputs = Inputs{
        .commands = std.ArrayList([]const u8).init(allocator),
    };

    while (true) {
        try print_prompt();
        try inputs.read_input(allocator);
    }
}

// pub fn close_input_buffer(input_buffer: *InputBuffer) void {
//         allocator.free(buf);
//     }
//     allocator.destroy(input_buffer);
// }
//     if (input_buffer.buffer) |buf| {

