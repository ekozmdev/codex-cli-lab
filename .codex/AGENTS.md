# AGENTS.md

- These user-level instructions apply to every codebase and task.

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
  - When the user reports an error, identify and report the cause before fixing any code.
  - For complex issues, add temporary debug logging to observe behavior, mark it with `TODO: Remove debug code before commit`, and remove it after resolution.

## Task Management
  - Always include a review task for everything you create or edit, including code and documentation.

## Sub-agents
  - Spawn sub-agents when needed:
    - Large-scale file reading or exploration across many files
    - A second-perspective review is needed (design, risk, testing)
