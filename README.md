# Tkersey Tap

Install a formula with `brew install tkersey/tap/<formula>`.

| Formula | Installed executable names | Count |
|---|---|---:|
| `seq` | `seq` | 1 |
| `lift` | `bench_stats` | 1 |
| `ledger` | `ledger` | 1 |
| `memory-note` | `memory-note` | 1 |
| `siwc` | `siwc` | 1 |

These five packages expose five executable names. Release archives come from
[Skills-Zig](https://github.com/tkersey/skills-zig/releases), with pinned hashes
for macOS ARM64 (macOS 15 or later) and Linux x86-64.

Install SIWC with `brew install tkersey/tap/siwc`. Its formula tests run offline;
a real ChatGPT account is not required for installation or package validation.

## CAS retirement

CAS is retired. The [native-Codex workflow migration](https://github.com/tkersey/dotfiles/pull/387)
removes the custom CLI dependency; use the installed native Codex runtime instead.
The formula is removed without deleting historical releases, installed kegs,
automation databases, schedules, memories, logs, or review evidence.

Before uninstalling an existing CAS installation, inspect local scheduler program
arguments and other callers for `cas automation run-due` or CAS sibling commands.
Migrate or deliberately retire each active job first. Do not treat native Codex
execution as a drop-in replacement for the old scheduler/store adapter, silently
stop jobs, or delete their state. An unknown scheduler inventory is not proof
that the executable is unused.

Once remaining callers are resolved, inspect `brew list --versions` and
`brew list --pinned`, confirm the owned formula/keg and active prefix, and use
Homebrew's supported uninstall path for that installation. Do not automatically
unpin packages, remove same-name files manually, or affect independent copies.
Formula removal itself neither uninstalls CAS nor stops a running scheduler.

## Earlier migrations

TypeSafe is retired. Lift now installs only `bench_stats`; `perf_report` is removed.
The Lift parser benchmark remains a development target in
[Skills-Zig](https://github.com/tkersey/skills-zig/blob/main/docs/release/README.md#cli-retirement-migration).
Historical releases and existing data/evidence remain unchanged.

Check `brew list --versions` and `brew list --pinned` first. Do not automatically
unpin a package. For an installation containing all five surviving formulas:

```sh
brew update
brew upgrade --formula tkersey/tap/seq tkersey/tap/lift tkersey/tap/ledger tkersey/tap/memory-note tkersey/tap/siwc
# Only when the owned TypeSafe package is installed:
brew uninstall --formula tkersey/tap/typesafe
```

Upgrade only packages already installed. If a deleted formula cannot be resolved,
inspect the installed keg's identity and use Homebrew's supported uninstall path.
Do not remove unrelated same-name files. Verify actual formula prefixes, versions,
and executable inventories after migration; old unlinked kegs and independently
installed copies are separate observations.

## Validation

Run `brew style Formula/<formula>.rb`, `brew audit --strict tkersey/tap/<formula>`,
and `brew test tkersey/tap/<formula>` for each surviving formula. Tap CI retains
native macOS/Linux test-bot checks and rejects skipped or failed formula tests.
See `brew help`, `man brew`, or [Homebrew's documentation](https://docs.brew.sh).
