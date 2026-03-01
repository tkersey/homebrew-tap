class Seq < Formula
  desc "Zig CLI for mining Codex session and memory artifacts"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.9"
  license "MIT"

  if OS.mac?
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-darwin-arm64.tar.gz"
    sha256 "89181f4bf466c02f3dba5782097e04cae25e46e123db8c0b026f24a835ae34f0"
  else
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-linux-x86_64.tar.gz"
    sha256 "7157bd45c8a3a32d35239af9d3ec3f3735c508a5e3cde864f6b42625af94ba7d"
  end

  def install
    bin.install "seq"
  end

  test do
    assert_match "skills-rank", shell_output("#{bin}/seq --help")
  end
end
