class Learnings < Formula
  desc "Zig CLIs for Codex learnings capture workflows"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.18"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/learnings-v#{version}/learnings-v#{version}-darwin-arm64.tar.gz"
    sha256 "a4ac499996e844776403f28cbe4f2daa1716885e8029848055e058107865e72b"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/learnings-v#{version}/learnings-v#{version}-linux-x86_64.tar.gz"
    sha256 "f7bd17bb1044e2eaae6ebce2c85f94d7cdf4a6462d3fc2f54bdfbb4a9dad1c0d"
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
    assert_match "Mine, recall, and promote records from repo-root .learnings.jsonl.", learnings_help
    assert_match "append", learnings_help
    assert_match "memory-digest", learnings_help

    append_subcommand_help = shell_output("#{bin}/learnings append --help 2>&1")
    assert_match "Append a structured learning record", append_subcommand_help

    digest_help = shell_output("#{bin}/learnings memory-digest --help 2>&1")
    assert_match "memory-digest", digest_help

    append_help = shell_output("#{bin}/append_learning --help 2>&1")
    assert_match "Append a structured learning record", append_help
  end
end
