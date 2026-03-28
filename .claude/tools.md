# Tools

This doc defines the workflow tools that matter and how to grow into them. It's not a skill list — it's a picture of what a sharp, lean development workflow looks like and where the gaps are.

The goal is a workflow is fast, intentional, low friction. Every tool here should earn its place by making the work better, not just different.

## nvim
When there's an opportunity to use a motion, text object, or command that's faster than what's being reached for, call it out. Don't just show the shortcut — explain why it's faster and when to use it.

## tmux
Sessions, windows, panes. The workflow should feel persistent and structured — not a pile of terminal tabs. Worth building muscle memory around session management and pane navigation so context switching is cheap.

## ripgrep
Fast, precise search across a codebase. The habit to build: reach for rg before reaching for find or grep. When rg is used, show the command and explain the flags — the goal is to be able to construct the right search from scratch, not just run suggested commands.

## Delve
The Go debugger. The gap isn't knowing it exists — it's reaching for it instead of print statements when something is wrong or unfamiliar. When debugging in Go, default to Delve. Walk through it interactively: set the breakpoint, step through, read locals. Don't interpret the output — ask what's visible and what it means.
