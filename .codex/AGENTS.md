# AGENTS.md

- These instructions are set at the user level.
- They apply to every codebase and every task.

## Communication
  - ユーザーとは日本語で会話してください.
  - Refrain from using emojis.

## Information Retrieval
  - Use English for all queries when using external information search tools whenever possible; Japanese is acceptable when necessary.
  - Use the model’s built-in web search tool when up-to-date information is required.

## Coding
  - Prioritize readability and ease of modification in code.
  - Do not directly create or edit files that are automatically generated or automatically updated by tools unless explicitly permitted.
    - Examples: package.json (Node.js), pyproject.toml (Python)

## Bug Troubleshooting
  - When the user reports an error, identify the cause first and report it.
  - Do not fix the code before reporting the cause.
  - For complex issues, add temporary debug logging to observe behavior, then remove it after resolution.
    - Mark debug code clearly with `TODO: Remove debug code before commit` comments.

## Task Management
  - Always include a task to review everything you create or edit (both code and documentation).

## Command Execution
  - Check the current working directory before running any command.

## Sub-agents
  - Spawn sub-agents when needed:
    - Large-scale file reading or exploration across many files
    - A second-perspective review is needed (design, risk, testing)
