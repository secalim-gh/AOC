const std = @import("std");
const info = std.log.info;
const print = std.debug.print;

fn readFile(file_path: []const u8, allocator: *std.mem.Allocator) ![]u8 {
    const file = try std.fs.cwd().openFile(file_path, .{ .mode = .read_only });
    defer file.close();

    const file_size = try file.getEndPos();

    const buffer = try allocator.alloc(u8, file_size);

    _ = try file.readAll(buffer);

    return buffer;
}

fn isRepeated(number: u64) bool {
    const buffer_size = 20;
    var buffer: [buffer_size]u8 = undefined;

    const str = std.fmt.bufPrint(&buffer, "{d}", .{ number }) catch return false; 
    if (str.len <= 1) return false;
    const halflen = str.len / 2;
    return std.ascii.eqlIgnoreCase(str[0..halflen], str[halflen..]);
}

pub fn main() !void {
    var allocator = std.heap.page_allocator;
    const file_path = "../input.txt";
    const input = try readFile(file_path, &allocator);
    defer allocator.free(input);
    const slice = input[0..input.len]; 
    var ranges = std.mem.tokenizeAny(u8, slice, ",");

    var sum: u64 = 0;
    while (ranges.peek() != null) {
        var range = ranges.next().?;
        range = std.mem.trimRight(u8, range, "\n\r\t ");
        var inside_token = std.mem.tokenizeAny(u8, range, "-");
        const b_slice = inside_token.next().?;
        const e_slice = inside_token.next().?;
        var begin = try std.fmt.parseInt(u64, b_slice, 10);
        const end = try std.fmt.parseInt(u64, e_slice, 10);
        while (begin <= end) : (begin += 1) {
            if (isRepeated(begin)) {
                sum += begin;
            }
        }
    }
    print("sum is: {d}\n", .{ sum });
}
