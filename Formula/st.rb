class St < Formula
  desc "Zig CLI for dependency-aware durable task plans"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.5"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-darwin-arm64.tar.gz"
    sha256 "86df8bf5d6590f770f1cf7d2a016fcd963248b22eff60ae0e14d1be184d470bb"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-linux-x86_64.tar.gz"
    sha256 "8f3460cbaf4a7325fe4ce10f3004fcfbb98ee0b0e5ad83c5b1c2b787a70b10a2"
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
    assert_match "st.zig", help
    assert_match "import-orchplan", help
    assert_match "import-mesh-results", help
  end
end
