#!/usr/bin/env python3
from dataclasses import dataclass
from typing import List
from z3 import Optimize, Int, Sum, sat

TEST_DATA = """[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
"""

@dataclass
class Row:
    """Represents a puzzle row with pattern, buttons, and joltage."""
    pattern: str
    buttons: List[List[int]]
    joltage: List[int]


def press(state: str, button: List[int]) -> str:
    """
    Apply a button press to toggle characters at specified indices.

    Args:
        state: Current state string of '.' and '#' characters
        button: List of indices to toggle

    Returns:
        New state after toggling
    """
    chars = list(state)
    for idx in button:
        if idx < len(chars):
            chars[idx] = '.' if chars[idx] == '#' else '#'
    return ''.join(chars)


def parse(data: str) -> List[Row]:
    """
    Parse input data into Row objects.

    Format: [pattern] (button1) (button2) ... {joltages}
    """
    rows = []
    for line in data.strip().split('\n'):
        if not line.strip():
            continue

        parts = line.split()

        # Extract pattern (remove brackets)
        pattern = parts[0].strip('[]')

        # Extract buttons (all parts with parens except the last which has braces)
        buttons = []
        for part in parts[1:-1]:
            if part.startswith('(') and part.endswith(')'):
                indices = [int(x) for x in part.strip('()').split(',')]
                buttons.append(indices)

        # Extract joltage (remove braces)
        joltage = [int(x) for x in parts[-1].strip('{}').split(',')]

        rows.append(Row(pattern=pattern, buttons=buttons, joltage=joltage))

    return rows


def min_presses(row: Row) -> int:
    """
    Find minimum number of button presses to reach the target pattern.

    Uses BFS to explore all possible states from starting state (all dots).
    """
    # Start with all dots
    initial_state = '.' * len(row.pattern)
    states = [initial_state]
    cnt = 0

    while True:
        cnt += 1
        new_states = []

        for state in states:
            for button in row.buttons:
                new_state = press(state, button)

                # Check if we reached the target pattern
                if new_state == row.pattern:
                    return cnt

                # Add to new states if not already seen
                if new_state not in new_states:
                    new_states.append(new_state)

        states = new_states

def min_presses_2(row: Row) -> int:
    opt = Optimize()
    press_counts = [Int(f'c_{i}') for i in range(len(row.buttons))]
    for count in press_counts:
        opt.add(count >= 0)
    
    for i, joltage in enumerate(row.joltage):
        affects = [press_counts[idx] for idx, button in enumerate(row.buttons) if i in button]
        opt.add(Sum(affects) == joltage)
    opt.minimize(Sum(press_counts))
    if opt.check() == sat:
        model = opt.model()
        return sum(model[count].as_long() for count in press_counts)
    else:
        raise ValueError("No solution found")


def part1(data: str) -> int:
    """Calculate sum of minimum presses for all rows."""
    rows = parse(data)
    return sum(min_presses(row) for row in rows)


def part2(data: str) -> int:
    rows = parse(data)
    return sum(min_presses_2(row) for row in rows)

if __name__ == "__main__":
    # Read real data
    with open('day10.txt', 'r') as f:
        REAL_DATA = f.read()

    print("Part 1")
    print(part1(TEST_DATA))
    print(part1(REAL_DATA))

    print("\nPart 2")
    print(part2(TEST_DATA))
    print(part2(REAL_DATA))
