class Seq < Formula
  desc "Zig CLI for mining Codex session and memory artifacts"
  homepage "https://github.com/tkersey/seq"
  url "https://github.com/tkersey/seq/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "8b1703d2d96110806fdb6d85bdbb995c914ae8f43397475f5ed739df300d8ceb"
  license "MIT"

  depends_on "zig" => :build

  def install
    system "zig", "build", "-Doptimize=ReleaseFast", "--prefix", prefix
  end

  test do
    assert_match "seq bootstrap ready", shell_output("#{bin}/seq --help")
  end
end
