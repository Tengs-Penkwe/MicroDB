const std = @import("std");

//Standard In/Out put
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

const rdl = @cImport({
    @cInclude("stdio.h");
    @cInclude("stdlib.h");
    @cInclude("readline/readline.h");
    @cInclude("readline/history.h");
});


pub fn main() !void {
    //Allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    _ = allocator;
    defer {
        //TODO: deal with it
        _ = gpa.deinit();
    }

    // Configure readline to auto-complete paths when the tab key is hit.
    _ = rdl.rl_bind_key('\t', rdl.rl_complete);
    // Enable history
    _ = rdl.using_history();

    // Completion
    rdl.rl_attempted_completion_function = 

    while (true) {
      const line = rdl.readline("db > ");
      defer rdl.free(line);

      if (line == null) {
        break;
      }

      rdl.add_history(line);

      std.debug.print("\t here:{s}\n", .{line});

      // try inputs.read_input(allocator);
    }
}
