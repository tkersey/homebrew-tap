class St < Formula
  desc "Zig CLI for dependency-aware durable task plans"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.4"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-darwin-arm64.tar.gz"
    sha256 "ed506b81c938c2c71face5e7b12f55017693771eac376ec60433f598e9396d16"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-linux-x86_64.tar.gz"
    sha256 "2b551f479c5c722ed7a4bf51a98ceb31f8894827d1523c675f71974268f7d120"
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
    assert_match "st.zig", shell_output("#{bin}/st --help")
  end
end
