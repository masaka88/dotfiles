# CLAUDE.md

## Communication Language

Respond in Japanese.

## Development Environment

All Python commands run inside the project's nix shell. Prefix with `nix develop -c` from the host:

```
nix develop -c pytest
nix develop -c ruff check .
```

The reason: this repo pins Python 3.11.7 and a specific OpenSSL version via nix to match production. Using the host's Python causes silent SSL handshake differences.

## Testing

- Integration tests require a live Postgres (not mocks). We got burned last quarter when a mocked test passed but the prod migration failed — the mock accepted a column-type change that Postgres rejected.
- Run a single test with `nix develop -c pytest tests/test_foo.py::test_bar -x`

## Git Workflow

- Conventional Commits required — enforced by commitlint in CI
- Squash-merge PRs, rebase local branches (no merge commits on feature branches)
