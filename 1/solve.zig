const std = @import("std");
const print = std.debug.print;
const parseUnsigned = std.fmt.parseUnsigned;

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
			continue;
		}
		var v = try parseUnsigned(u64, line, 10);
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
