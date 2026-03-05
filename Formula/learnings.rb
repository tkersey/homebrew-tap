class Learnings < Formula
  desc "Zig CLIs for Codex learnings capture workflows"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.8"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/learnings-v#{version}/learnings-v#{version}-darwin-arm64.tar.gz"
    sha256 "56a47324fd5b3d79b022c54a8a66cb179f4f288da138717bfa9b8c0062998ca3"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/learnings-v#{version}/learnings-v#{version}-linux-x86_64.tar.gz"
    sha256 "0c4b746b1b2e8a14538d998c29c017df1e9d9f2caf848b2b025057da8462d3ca"
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
