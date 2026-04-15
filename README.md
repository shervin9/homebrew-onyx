# homebrew-onyx

Homebrew tap for [Onyx](https://github.com/shervin9/onyx) — stable remote
shell for unreliable networks (QUIC + SSH fallback).

## Install

```bash
brew install shervin9/onyx/onyx
```

Currently ships **macOS Apple Silicon only**. Linux users should install
via the shell installer:

```bash
curl -fsSL https://useonyx.dev/install.sh | sh
```

## Updating the formula

On each Onyx release:

1. Bump `version` in `Formula/onyx.rb` to the new tag.
2. Replace the `sha256` value with the hash for `onyx-macos-arm64` from
   that release's `onyx-sha256sums.txt`.
3. Commit and push; Homebrew picks up the change on the next `brew update`.
