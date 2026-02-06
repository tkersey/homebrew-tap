class Bz < Formula
  desc "Zig implementation of the br protocol"
  homepage "https://github.com/tkersey/homebrew-tap"
  url "https://github.com/tkersey/bz.git",
      using:    :git,
      revision: "2e12026fb4c041142c173887d353e35067c4ef33"
  version "2e12026"
  license "MIT"
  head "https://github.com/tkersey/bz.git", branch: "main"

  depends_on "zig" => :build
  depends_on "sqlite"

  def install
    system "zig", "build", "-Doptimize=ReleaseSafe", "--prefix", prefix
  end

  test do
    assert_match "bz", shell_output("#{bin}/bz version")
  end
end
