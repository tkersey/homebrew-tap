class Learnings < Formula
  desc "Zig CLIs for Codex learnings capture workflows"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.25"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/learnings-v#{version}/learnings-v#{version}-darwin-arm64.tar.gz"
    sha256 "120b0f4d6931847abeec29d2dc1e7dd542988b52123ad21030b49afd4e9e0b3f"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/learnings-v#{version}/learnings-v#{version}-linux-x86_64.tar.gz"
    sha256 "e71cbc9dc4aa271ee735e57ff196c2464b50307de851fbdde7cd5701f5e7cc28"
  end

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    bin.install "learnings", "append_learning"
  end

  test do
    learnings_help = shell_output("#{bin}/learnings --help 2>&1")
    assert_match "Mine, recall, and promote records from repo-local", learnings_help
    assert_match ".ledger/learnings/learnings.jsonl", learnings_help
    assert_match "append", learnings_help
    assert_match "migrate", learnings_help
    assert_match "memory-digest", learnings_help

    append_subcommand_help = shell_output("#{bin}/learnings append --help 2>&1")
    assert_match "Append a structured learning record to repo-local", append_subcommand_help
    assert_match ".ledger/learnings/learnings.jsonl", append_subcommand_help

    digest_help = shell_output("#{bin}/learnings memory-digest --help 2>&1")
    assert_match "memory-digest", digest_help

    append_help = shell_output("#{bin}/append_learning --help 2>&1")
    assert_match "Append a structured learning record to repo-local .ledger/learnings/learnings.jsonl.", append_help
  end
end
