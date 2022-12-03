const std = @import("std");
const print = std.debug.print;

const rule = struct {
	points: u8,
	kills: u8,
};
const turn = struct {
	op: u8,
	me: u8,
};
const e = error {
	Error
};

pub fn main() !void {
	var allocator = std.heap.GeneralPurposeAllocator(.{}){};
	var a = allocator.allocator();
	var file = try std.fs.cwd().openFile("input", .{});
	defer file.close();

	var buf_reader = std.io.bufferedReader(file.reader());
	var in_stream = buf_reader.reader();

	var rmap = std.AutoHashMap(u8, rule).init(a);
	try rmap.put('A', rule{.points = 1, .kills = 'Z'});
	try rmap.put('B', rule{.points = 2, .kills = 'X'});
	try rmap.put('C', rule{.points = 3, .kills = 'Y'});
	try rmap.put('X', rule{.points = 1, .kills = 'C'});
	try rmap.put('Y', rule{.points = 2, .kills = 'A'});
	try rmap.put('Z', rule{.points = 3, .kills = 'B'});

	var buf: [64]u8 = undefined;
	var score: u32 = 0;
	var score2: u32 = 0;
	while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
		var t = turn{.op = line[0], .me = line[2]};

		// Part 1: Calculate the score, assuming XYZ tells us to play RPS
		var mine = rmap.get(t.me) orelse return e.Error;
		var theirs = rmap.get(t.op) orelse return e.Error;
		score += mine.points;
		if (theirs.kills == t.me) {
			score += 0;
		} else if (mine.kills == t.op) {
			score += 6;
		} else { // tie
			score += 3;
		}

		// Part 2: Calculate the score, where XYZ means lose, draw, win
		if (t.me == 'X') { // Lose. Choose what they kill
			var choice = rmap.get(theirs.kills) orelse return e.Error;
			score2 += 0 + choice.points;
		} else if (t.me == 'Y') { // Draw. Choose what they choose.
			score2 += 3 + theirs.points;
		} else { // Win. Choose what they kill kills.
			var loser = rmap.get(theirs.kills) orelse return e.Error;
			var choice = rmap.get(loser.kills) orelse return e.Error;
			score2 += 6 + choice.points;
		}

	}
	print("{d}\n", .{score});
	print("{d}\n", .{score2});
}
