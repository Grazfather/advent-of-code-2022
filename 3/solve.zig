const std = @import("std");
const print = std.debug.print;

const e = error {
	Error
};

fn itemPriority(c: u8) u8 {
	return switch (c) {
		'a' ... 'z' => c - 'a' + 1,
		'A' ... 'Z' => c - 'A' + 27,
		else => 0,
	};
}
const seenSet = std.bit_set.IntegerBitSet(53);

pub fn main() !void {
	var file = try std.fs.cwd().openFile("input", .{});
	defer file.close();

	var buf_reader = std.io.bufferedReader(file.reader());
	var in_stream = buf_reader.reader();

	// Part 1: Find the priority of the item found in both halves
	var total_priority: u32 = 0;
	var buf: [64]u8 = undefined;
	while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		var seen1 = seenSet.initEmpty();
		for (line) |c, i| {
			var priority = itemPriority(c);
			if (i < (line.len / 2)) {
				seen1.set(priority);
			} else {
				if (seen1.isSet(priority)) {
					total_priority += priority;
					break;
				}
			}
		}
	}
	print("{d}\n", .{total_priority});

	// Reset the file cursor so we can reread it.
	try file.seekTo(0);

	// Part 2: Find the priority of the item found line for each group of three lines
	total_priority = 0;
	var j: usize = 0;
	var seen2 = [2]seenSet{
		seenSet.initEmpty(),
		seenSet.initEmpty(),
	};
	while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		if (j != 2) {
			seen2[j] = seenSet.initEmpty();
		}

		for (line) |c| {
			var priority = itemPriority(c);
			if (j != 2) {
				seen2[j].set(priority);
			} else {
				if (seen2[0].isSet(priority) and seen2[1].isSet(priority)) {
					total_priority += priority;
					break;
				}
			}
		}
		j = (j + 1) % 3;
	}
	print("{d}\n", .{total_priority});
}
