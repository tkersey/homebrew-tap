# Tkersey Tap

## How do I install these formulae?

`brew install tkersey/tap/<formula>`

Or `brew tap tkersey/tap` and then `brew install <formula>`.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

## Seq Release Checklist

- Source: `https://github.com/tkersey/seq` tag `v0.1.2` tarball with pinned `sha256` in `Formula/seq.rb`.
- Install (public): `brew tap tkersey/tap` then `brew install seq` (or `brew install tkersey/tap/seq`).
- Validate with `brew style Formula/seq.rb`, `brew audit --strict tkersey/tap/seq`, `brew install --build-from-source tkersey/tap/seq`, and `brew test tkersey/tap/seq`.
