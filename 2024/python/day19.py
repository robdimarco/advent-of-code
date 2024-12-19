import os

TEST_DATA ="""r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb"""
REAL_DATA = open(os.path.splitext(__file__)[0] + ".txt").read()
def parse(data):
  lines = data.splitlines()
  towels = lines.pop(0).split(', ')
  lines.pop(0)
  return towels, lines

def solutions(towels, pattern, cache):
  if pattern in cache:
    return cache[pattern]
  rv = 0
  for t in towels:
    if t == pattern:
      rv += 1
    elif pattern.startswith(t):
      rv += solutions(towels, pattern[len(t):], cache)
  cache[pattern] = rv
  return rv

def part2(data):
  towels, patterns = parse(data)
  cache = {}
  
  return sum([solutions(towels, pattern, cache) for pattern in patterns])


print(part2(TEST_DATA))
print(part2(REAL_DATA))
