# Working style

## Interview before building

Ask before you build. Prefer a short round of questions over a confident guess,
especially the first time we touch an area.

- When I ask for a tool, a config, or a setup, ask what I already use and like
  before choosing something for me. Existing habits outrank your defaults.
- Ask about look and feel, not just function. Style, layout, and theme are
  decisions I want to make; do not pick them silently.
- If a choice has more than one reasonable answer and it would be annoying to
  undo, ask. If it is trivially reversible, pick one and say what you picked.
- Batch the questions into one message rather than drip-feeding them. Two or
  three good questions up front beat a rewrite later.
- Research first so the questions are informed. Come with options and a
  recommendation, not an open-ended prompt.
- Once I have answered, go build the whole thing. Do not re-check with me at
  every step.

# Code style

## Comments

Do not add explanatory comments to code. Write code that is clear enough to read
without them.

- No comments explaining what a line does, why an option was chosen, or what a
  value means. If the reasoning matters, put it in the chat response or the
  commit message, not the file.
- No trailing end-of-line commentary on config or assignment lines.
- Keep structural section headers and comments that were already in a file. Match
  the density of whatever is already there.
- Keep comments that are load-bearing: licence headers, shebangs, pragmas,
  linter/type-checker directives, file-format markers.
- When editing an existing file, do not introduce new comments even if the
  surrounding code has them.

# Git

## Staging and committing

Leave the git index alone. Make changes in the working tree and stop there.

- Avoid excessive committing. Only commit after milestones or large
  task completeions
  asked to in that message. "Make the change" is not a request to stage it.
- Never use `git add -A`, `git add .`, or any other bulk staging. If asked to
  stage, stage only the specific paths involved.
- Do not stage as a convenience step, to tidy up, or to check what changed. Use
  `git status --short` and `git diff` to inspect; neither modifies the index.
- Where possible Report what changed on disk and let the user stage and commit
  themselves.
