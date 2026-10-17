# Tkersey Tap

Install a formula with `brew install tkersey/tap/<formula>`.

| Formula | Installed executable names | Count |
|---|---|---:|
| `seq` | `seq` | 1 |
| `lift` | `bench_stats` | 1 |
| `cas` | `cas`, `cas_account`, `cas_app_server_preflight`, `cas_automation`, `cas_conformance_suite`, `cas_goal`, `cas_smoke_check`, `cas_instance_runner`, `cas_review_session`, `cas_session_inquiry` | 10 |
| `ledger` | `ledger` | 1 |
| `memory-note` | `memory-note` | 1 |

These five packages expose 14 executable names. Release archives come from
[Skills-Zig](https://github.com/tkersey/skills-zig/releases), with pinned hashes
for macOS ARM64 (macOS 15 or later) and Linux x86-64.

## Migration

TypeSafe is retired. Lift now installs only `bench_stats`; `perf_report` is removed.
The Lift parser and CAS governor benchmarks remain development targets in
[Skills-Zig](https://github.com/tkersey/skills-zig/blob/main/docs/release/README.md#cli-retirement-migration).
Historical releases and existing data/evidence remain unchanged.

Check `brew list --versions` and `brew list --pinned` first. Do not automatically
unpin a package. For an installation containing all five surviving formulas:

```sh
brew update
brew upgrade --formula tkersey/tap/seq tkersey/tap/lift tkersey/tap/cas tkersey/tap/ledger tkersey/tap/memory-note
# Only when the owned TypeSafe package is installed:
brew uninstall --formula tkersey/tap/typesafe
```

Upgrade only packages already installed. If the deleted TypeSafe formula cannot
be resolved, inspect the installed keg's identity and use Homebrew's supported
uninstall path. Do not remove unrelated same-name files. Verify actual formula
prefixes, versions, and executable inventories after migration; old unlinked kegs
and independently installed copies are separate observations.

## Validation

Run `brew style Formula/<formula>.rb`, `brew audit --strict tkersey/tap/<formula>`,
and `brew test tkersey/tap/<formula>` for each surviving formula. Tap CI retains
native macOS/Linux test-bot checks and rejects skipped or failed formula tests.
See `brew help`, `man brew`, or [Homebrew's documentation](https://docs.brew.sh).
