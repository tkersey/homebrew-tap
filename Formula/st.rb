class St < Formula
  desc "Zig CLI for dependency-aware durable task plans"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.16"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-darwin-arm64.tar.gz"
    sha256 "e07be33fb85ee51d82da45753f3f410627494633b23e7fd191e41967ef0d5185"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-linux-x86_64.tar.gz"
    sha256 "b6c7c4e77fc86466bb7122376914ebb2563748b4db5412692ee4a5d1da8028c0"
  end

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    bin.install "st"
  end

  test do
    help = shell_output("#{bin}/st --help")
    assert_match "Manage dependency-aware JSONL v3 plan state.", help
    assert_match "import-orchplan", help
    assert_match "import-update-plan", help
    assert_match "import-mesh-results", help
  end
end
