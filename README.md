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
