import heapq

with open("input") as f:
    lines = f.read().split("\n")

elves = []
v = 0
for line in lines:
    if line == "":
        heapq.heappush(elves, v)
        v = 0
    else:
        v += int(line)

print(heapq.nlargest(1, elves))
print(heapq.nsmallest(1, elves))
print(sum(heapq.nlargest(3, elves)))
