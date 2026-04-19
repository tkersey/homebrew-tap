class Learnings < Formula
  desc "Zig CLIs for Codex learnings capture workflows"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.14"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/learnings-v#{version}/learnings-v#{version}-darwin-arm64.tar.gz"
    sha256 "8a7b37d8fb0ab4bbd5d6b5561387f50a188437f4a35b46c104b92c3aeddd0500"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/learnings-v#{version}/learnings-v#{version}-linux-x86_64.tar.gz"
    sha256 "6c82f8ca67142d439dd2c9bee9a0b5f78d452cac7976a0054b0b5efecaab0289"
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
