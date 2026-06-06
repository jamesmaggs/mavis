#!/bin/sh
# One-time local dev setup. Idempotent.
set -e

# Use the committed git hooks (e.g. the pre-push verify gate).
git config core.hooksPath .githooks

# Provision the pinned toolchain (Java + Maven) from mise.toml.
mise trust
mise install

echo "Setup complete: git hooks enabled, toolchain installed."
