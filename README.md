# Tkersey Tap

## How do I install these formulae?

`brew install tkersey/tap/<formula>`

Or `brew tap tkersey/tap` and then `brew install <formula>`.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

## Bz Release Checklist

- Signed-tag gate: only bump `Formula/bz.rb` to a signed upstream git tag from `tkersey/bz`.
- For each bump, update the formula source reference to that exact signed tag archive and set `sha256`.
- Keep `bz` source-build only (no bottles) and validate with `brew style`, `brew audit --strict tkersey/tap/bz`, `brew install --build-from-source tkersey/tap/bz`, and `brew test tkersey/tap/bz`.

## Seq Release Checklist

- Source: `https://github.com/tkersey/seq` tag `v0.1.2` tarball with pinned `sha256` in `Formula/seq.rb`.
- Install (public): `brew tap tkersey/tap` then `brew install seq` (or `brew install tkersey/tap/seq`).
- Validate with `brew style Formula/seq.rb`, `brew audit --strict tkersey/tap/seq`, `brew install --build-from-source tkersey/tap/seq`, and `brew test tkersey/tap/seq`.

## St Release Checklist

- Source: `https://github.com/tkersey/skills-zig` tag `st-v<version>` release assets; update both platform `sha256` values in `Formula/st.rb` after release publish.
- Install (public): `brew tap tkersey/tap` then `brew install st` (or `brew install tkersey/tap/st`).
- Validate with `brew style Formula/st.rb`, `brew audit --strict tkersey/tap/st`, and `brew test tkersey/tap/st`.
