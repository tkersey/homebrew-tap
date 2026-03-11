class Learnings < Formula
  desc "Zig CLIs for Codex learnings capture workflows"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.9"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/learnings-v#{version}/learnings-v#{version}-darwin-arm64.tar.gz"
    sha256 "97b0f58d6a340ca3a62c9335b91ccae1ab8c2e47f91a1b11f10dcc14ef4d76e0"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/learnings-v#{version}/learnings-v#{version}-linux-x86_64.tar.gz"
    sha256 "f4aebd94a5554414893e298381ce495269fcc0ffe6580d0be0b94d4294599aa6"
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
    assert_match "learnings.zig", learnings_help
    assert_match "append", learnings_help

    append_subcommand_help = shell_output("#{bin}/learnings append --help 2>&1")
    assert_match "append_learning.zig", append_subcommand_help

    append_help = shell_output("#{bin}/append_learning --help 2>&1")
    assert_match "append_learning.zig", append_help
  end
end
