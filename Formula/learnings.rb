class Learnings < Formula
  desc "Zig CLIs for Codex learnings capture workflows"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.7"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/learnings-v#{version}/learnings-v#{version}-darwin-arm64.tar.gz"
    sha256 "d9d8e8db1b7e76fedc912983fe80b31c160ac0c365d7e7cbbf7c7ec6a7670b8f"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/learnings-v#{version}/learnings-v#{version}-linux-x86_64.tar.gz"
    sha256 "5d9ff444e78731d779375f7c2b000dc066c32fd17bb6ff11df025c467882d4d2"
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

    append_help = shell_output("#{bin}/append_learning --help 2>&1")
    assert_match "append_learning.zig", append_help
  end
end
