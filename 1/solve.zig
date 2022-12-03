const std = @import("std");
const print = std.debug.print;

fn charToDigit(c: u8) u8 {
    return switch (c) {
        '0' ... '9' => c - '0',
        'A' ... 'Z' => c - 'A' + 10,
        'a' ... 'z' => c - 'a' + 10,
        else => std.math.maxInt(u8),
    };
}

pub fn parseU64(buf: []const u8, radix: u8) !u64 {
    var x: u64 = 0;

    for (buf) |c| {
        const digit = charToDigit(c);

        if (digit >= radix) {
            return error.InvalidChar;
        }

        // x *= radix
        if (@mulWithOverflow(u64, x, radix, &x)) {
            return error.Overflow;
        }

        // x += digit
        if (@addWithOverflow(u64, x, digit, &x)) {
            return error.Overflow;
        }
    }

    return x;
}

fn greaterThan(context: void, a: u64, b: u64) std.math.Order {
    _ = context;
    return std.math.order(b, a);
}

pub fn main() !void {
	var allocator = std.heap.GeneralPurposeAllocator(.{}){};
	var a = allocator.allocator();
	var file = try std.fs.cwd().openFile("input", .{});
	defer file.close();

	var buf_reader = std.io.bufferedReader(file.reader());
	var in_stream = buf_reader.reader();

	var buf: [64]u8 = undefined;
	var elves = std.PriorityQueue(u64, void, greaterThan).init(a, {});
	var vi : u64 = 0;
	while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		if (line.len == 0) {
			try elves.add(vi);
			vi = 0;
		}
		var v = try parseU64(line, 10);
		vi += v;
	}

	// Part 1: Get calories on elf with most
	print("{any}\n", .{elves.peek()});

	// Part 2: Get calories on top 3 elves
	var v : u64 = 0;
	v += elves.remove();
	v += elves.remove();
	v += elves.remove();
	print("{any}\n", .{v});
}
