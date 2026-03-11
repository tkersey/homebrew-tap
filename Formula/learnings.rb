class Learnings < Formula
  desc "Zig CLIs for Codex learnings capture workflows"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.10"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/learnings-v#{version}/learnings-v#{version}-darwin-arm64.tar.gz"
    sha256 "729d9318c0641d7475a1b39e3c664837a1f9a9acf2e558a32bbac46d81938031"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/learnings-v#{version}/learnings-v#{version}-linux-x86_64.tar.gz"
    sha256 "b8d9516e58af81163e7b54d713fa09d0432d8541db5ec5a00fe791e364c1ab6d"
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
