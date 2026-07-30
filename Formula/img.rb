class Img < Formula
  desc "Render UTF-8 text and code as dense PNG pages"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.0"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/img-v#{version}/img-v#{version}-darwin-arm64.tar.gz"
    sha256 "cc63c6388008f2ce847fb6daa41fe91f025f7eaaa9c2930b6d4ac8bc0cbd9f76"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/img-v#{version}/img-v#{version}-linux-x86_64.tar.gz"
    sha256 "03744e3c9468a9a2d1dfcb1511e8f89799821c532e448e2c7339fa87cedc76c4"
  end

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    bin.install "img"
    pkgshare.install "LICENSES"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/img --version").strip
    assert_path_exists pkgshare/"LICENSES/pxpipe-MIT.txt"

    (testpath/"input.txt").write("hello from Homebrew\n")
    system bin/"img", testpath/"input.txt", "--out", testpath/"pages"
    assert_path_exists testpath/"pages/page-001.png"
  end
end
