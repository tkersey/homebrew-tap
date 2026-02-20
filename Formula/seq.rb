class Seq < Formula
  desc "Zig CLI for mining Codex session and memory artifacts"
  homepage "https://github.com/tkersey/seq"
  url "https://github.com/tkersey/seq/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "82ef36f7adc59184d4cc8b078c3353d9eacfe8aba6855bdc0b826e991b645cd5"
  license "MIT"

  depends_on "zig" => :build

  def install
    system "zig", "build", "-Doptimize=ReleaseFast", "--prefix", prefix
  end

  test do
    assert_match "seq bootstrap ready", shell_output("#{bin}/seq --help")
  end
end
