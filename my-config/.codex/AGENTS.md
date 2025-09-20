# AGENTS.md

These instructions are set at the user level.
They apply to every codebase and every task.

- Communication
  - ユーザーとは日本語で会話してください.
  - Refrain from using emojis.

- Bug Troubleshooting
  - When the user reports an error, identify the cause first and report it.
  - Do not fix the code before reporting the cause.

- Information Retrieval
  - Use English for all queries when using external information search tools whenever possible; Japanese is acceptable when necessary.
  - Use the model’s built-in web search tool when up-to-date information is required.

- Coding
  - Write commit messages that follow the Conventional Commit rules and keep them simple and clear.
  - Prioritize readability and ease of modification in code.
  - Do not directly edit files that are automatically generated or automatically updated by tools.
    - Examples: package.json (Node.js), pyproject.toml (Python)

- Task Management
  - Always include a task to review everything you create (both code and documentation).

- Command Execution
  - Check the current working directory before running any command.
