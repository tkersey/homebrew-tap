class Seq < Formula
  desc "Zig CLI for mining Codex session and memory artifacts"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.7"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-darwin-arm64.tar.gz"
    sha256 "ae495e7fbeebfaee0a34b4aee55ef1b405bb9d0dda8f59ae1c20b397ed9063bf"
  end

  on_linux do
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-linux-x86_64.tar.gz"
    sha256 "98ae935949e45c90e281932ebdec31a6f856364157797c21f22b4789e6a6adc7"
  end

  def install
    bin.install "seq"
  end

  test do
    assert_match "skills-rank", shell_output("#{bin}/seq --help")
  end
end
