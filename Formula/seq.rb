class Seq < Formula
  desc "Zig CLI for mining Codex session and memory artifacts"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.10"
  license "MIT"

  if OS.mac?
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-darwin-arm64.tar.gz"
    sha256 "6e5d2197760f6e47ee639cd7336a9a821116d847df3fdb8821ecab610550763b"
  else
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-linux-x86_64.tar.gz"
    sha256 "482154e0ba77969ec772580c5767461be80312c4f81fbf7b1a56f6636e927644"
  end

  def install
    bin.install "seq"
  end

  test do
    assert_match "skills-rank", shell_output("#{bin}/seq --help")
  end
end
