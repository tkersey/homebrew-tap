class Learnings < Formula
  desc "Zig CLIs for Codex learnings capture workflows"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.23"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/learnings-v#{version}/learnings-v#{version}-darwin-arm64.tar.gz"
    sha256 "93f75e74e96dfb8d46293d1ba572a784e7c500ed36d8c56f11560c1c153c3eec"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/learnings-v#{version}/learnings-v#{version}-linux-x86_64.tar.gz"
    sha256 "54dafe40b4ebe4d6d13edc245a3a0067f06ef21fe2a482385952b55d19acae0c"
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
