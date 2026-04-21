class Learnings < Formula
  desc "Zig CLIs for Codex learnings capture workflows"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.15"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/learnings-v#{version}/learnings-v#{version}-darwin-arm64.tar.gz"
    sha256 "fc1dde8c0ccab33e4e6e6af855e57e54335b7a7732f0f7ba45094b74a0417cb8"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/learnings-v#{version}/learnings-v#{version}-linux-x86_64.tar.gz"
    sha256 "bd12bac75aea879bf582af58b13f847230fdfc945ce4dcc9f061a689ced1606a"
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

    append_subcommand_help = shell_output("#{bin}/learnings append --help 2>&1")
    assert_match "Append a structured learning record", append_subcommand_help

    append_help = shell_output("#{bin}/append_learning --help 2>&1")
    assert_match "Append a structured learning record", append_help
  end
end
