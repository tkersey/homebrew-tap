class St < Formula
  desc "Zig CLI for dependency-aware durable task plans"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.1"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-darwin-arm64.tar.gz"
    sha256 "5fad535dd051fb5e8ebc7dda4982d28c172a21c3a2710b41599c06f858bfac59"
  end

  on_linux do
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-linux-x86_64.tar.gz"
    sha256 "98ee97ea2af3f76901f4e27a1a3376014a63daa37ed8b804dcac4d1a4761476e"
  end

  def install
    bin.install "st"
  end

  test do
    assert_match "st.zig", shell_output("#{bin}/st --help")
  end
end
