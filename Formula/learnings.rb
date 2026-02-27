class Learnings < Formula
  desc "Zig CLIs for Codex learnings capture workflows"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.6"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/learnings-v#{version}/learnings-v#{version}-darwin-arm64.tar.gz"
    sha256 "e715005be3d72234fd6a5afa002098f1609a98b8c43aea7984a1038a7f072815"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/learnings-v#{version}/learnings-v#{version}-linux-x86_64.tar.gz"
    sha256 "1a2ed74b6939744a4ebdc864b227ab53feb5aaf391c24e8016e748826edfbff6"
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
