# AGENTS.md

## Cursor Cloud specific instructions

This repo is a personal **Advent of Code** solutions monorepo, organized by year (`2015`–`2025`) then by language (`go`, `ruby`, `python`, `java`). There are **no services, servers, databases, or ports** — each day's solution is a standalone script that reads a puzzle input and prints an answer. "Running the app" means running an individual day's solution or a language test suite.

### Toolchains (baked into the VM snapshot; the update script does not reinstall them)
- Ruby 3.2.x (`ruby-full`) + Bundler, with the native `algorithms` gem installed system-wide (`sudo gem install algorithms`). 24 Ruby files `require 'algorithms'`.
- Go 1.22 (repo pins `go 1.19`, fully backward compatible).
- Python 3.12 + `python3.12-venv`.
- Java (OpenJDK 21) for the single file `2021/java/Day24.java`.

### Puzzle inputs are git-ignored and absent
`.gitignore` excludes `*.txt`, so real puzzle inputs (`dayN.txt`) are **not** in the repo. Consequences:
- Solutions that call `File.read('dayN.txt')` / `open('dayN.txt')` / `readFile("day24.txt")` will fail with a missing-file error until you create the relevant `dayN.txt` locally (git-ignored, safe to create for testing).
- Many Go/Python solutions also embed inline example data (e.g. `TEST_DATA`, table-driven test cases) that runs without any external file.
- Go's `go test ./...` in `2015/go` has failures/panics **only** where tests read absent personal inputs (e.g. `../../ruby/day9.txt`) or assert the author's personal answers (e.g. day1 `TestPart1` expects `232`). This is expected, not an environment problem. Inline-data tests (e.g. `go test ./day1/ -run 'TestFloor|TestBasement'`) pass cleanly.

### Running / testing solutions
- Ruby: `cd <year>/ruby && ruby dayN.rb` (no `bundle exec` needed — no script uses `bundler/setup`; the `algorithms` gem loads from the system install).
- Go: `cd 2015/go` (or `2023/go`) then `go build ./...`, `go vet ./...`, `go run ./dayN`, `go test ./...`.
- Python: `cd 2025/python && ./venv/bin/python day10.py` (needs `z3-solver`, installed in `2025/python/venv`). `2024/python/day19.py` has no requirements file.
- Java: `cd 2021/java && javac Day24.java && java Day24`. Note `Day24.main` brute-forces from `99999999999999` downward and is effectively non-terminating; it prints a `.` per 1000 iterations. Run under a `timeout` to observe it executing the ALU program from `day24.txt`.

### Bundler note
`bundle install` is optional (direct `ruby` execution is the normal workflow). Bundler is globally configured to install to `~/.bundle-gems` (`bundle config set --global path`) so it does not need sudo/write access to the system gem dir. Running `bundle install` may rewrite `Gemfile.lock` (adding the `x86_64-linux` platform / bundler version); revert that churn with `git checkout -- <path>/Gemfile.lock` before committing unrelated work.
