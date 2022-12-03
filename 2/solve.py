with open("input") as f:
    turns = [[x for x in line.split(" ")] for line in f.read().rstrip().split("\n")]

from collections import namedtuple
Rule = namedtuple("Rule", "name, pchoose, pstrat, steps, kills")
rmap = {
    "A": Rule("Rock", 1, 0, 0, "Z"),
    "B": Rule("Paper", 2, 0, 0, "X"),
    "C": Rule("Scissors", 3, 0, 0, "Y"),
    "X": Rule("Lose", 1, 0, 1, "C"),
    "Y": Rule("Tie", 2, 3, 0, "A"),
    "Z": Rule("Win", 3, 6, 2, "B"),
}

score = 0
score2 = 0
for turn in turns:
    op, me = turn
    # Part 1: Choose what they say
    score += rmap[me].pchoose
    if rmap[op].kills == me:
        score += 0
    elif rmap[me].kills == op:
        score += 6
    else: # tie
        score += 3

    # Part 2: Win, lose, or tie, as they say
    score2 += rmap[me].pstrat
    choice = rmap[op]
    for i in range(rmap[me].steps):
        choice = rmap[choice.kills]
    score2 += choice.pchoose

print(score)
print(score2)
