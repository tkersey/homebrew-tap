class Seq < Formula
  desc "Zig CLI for mining Codex session and memory artifacts"
  homepage "https://github.com/tkersey/seq"
  url "https://github.com/tkersey/seq/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "9148d7dbcc28457db3f4fd65aecac86668f3ea90453cbf63cdcb7343d70acdc3"
  license "MIT"

  depends_on "zig" => :build

  def install
    system "zig", "build", "-Doptimize=ReleaseFast", "--prefix", prefix
  end

  test do
    assert_match "seq bootstrap ready", shell_output("#{bin}/seq --help")
  end
end
