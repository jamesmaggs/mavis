// Commit-message lint rules — Conventional Commits, mirroring the `commit`
// skill's guidance so the feed-forward guide and this sensor agree. Rules are
// inlined (no @commitlint/config-conventional dependency to resolve); commitlint
// itself is pinned via mise.toml (npm:@commitlint/cli).
export default {
  rules: {
    "type-enum": [
      2,
      "always",
      ["feat", "fix", "perf", "docs", "refactor", "test", "build", "ci", "chore", "revert"],
    ],
    "type-empty": [2, "never"],
    "type-case": [2, "always", "lower-case"],
    "subject-empty": [2, "never"],
    "subject-full-stop": [2, "never", "."],
    "header-max-length": [2, "always", 72],
  },
};
