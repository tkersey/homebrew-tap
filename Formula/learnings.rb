class Learnings < Formula
  desc "Zig CLIs for Codex learnings capture workflows"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.14"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/learnings-v#{version}/learnings-v#{version}-darwin-arm64.tar.gz"
    sha256 "4d4c9ab4a0dbdfc2843e6bed855327b17095870be1848d77b67d0d2e734ebb1a"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/learnings-v#{version}/learnings-v#{version}-linux-x86_64.tar.gz"
    sha256 "58d10f4ca8ecbac4db3aa1dc533d79a0556c51e54a46467040216dd2bf2a9817"
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
