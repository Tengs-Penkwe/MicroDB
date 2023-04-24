const std = @import("std");

//Standard In/Out put
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

const rdl = @cImport({
    @cInclude("stdio.h");
    @cInclude("stdlib.h");
    @cInclude("readline/readline.h");
    // @cInclude("/opt/homebrew/opt/readline/include/readline/history.h");
});

const Inputs = struct {
    commands: std.ArrayList([]const u8),

    pub fn read_input(self: *@This(), allocator: std.mem.Allocator) !void {
        var buffer: [1024]u8 = undefined;
        const command = try stdin.readUntilDelimiterOrEof(&buffer, '\n');

        if ((command == null) or !valid(command.?)) {
            return;
        }

        const copied_command = try allocator.dupe(u8, command.?);
        try self.commands.append(copied_command);

        // std.debug.print("{s}\n", .{copied_command});
        // self.execute(copied_command);
    }

    // fn execute(self: *@This(), command: []u8) !void {
    //     //TODO: support up, down keys to lookthrough history
    //     _ = self;
    //     if (command == ".exit") {
    //         std.os.exit(0);
    //     } else {
    //         stdout.print("Unrecognized command '{s}'.\n", .{command}) catch {};
    //     }
    // }

    fn valid(command: []u8) bool {
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
        //TODO: deal with it
        _ = gpa.deinit();
    }

    // const result = rdl.readline(">>> ");
    // _ = result;

    _ = rdl.printf("test");

    var inputs = Inputs{
        .commands = std.ArrayList([]const u8).init(allocator),
    };

    while (true) {
        try print_prompt();
        try inputs.read_input(allocator);
    }
}
