class St < Formula
  desc "Zig CLI for dependency-aware durable task plans"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.16"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-darwin-arm64.tar.gz"
    sha256 "d17c7e2e5da0b417f7252c570a2d34a300bd8fd35beac13b128c44bf73dc9c95"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-linux-x86_64.tar.gz"
    sha256 "a00158b716efb513b4b5641f89b7ed68668cbffc5c6ae6e3d002fecd94802270"
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
