class Img < Formula
  desc "Render UTF-8 text and code as dense PNG pages"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.1"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/img-v#{version}/img-v#{version}-darwin-arm64.tar.gz"
    sha256 "ecad94bf0559672eab9e1835ec6173cf125881d0ac0f386ec99360bcdd64cb34"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/img-v#{version}/img-v#{version}-linux-x86_64.tar.gz"
    sha256 "9f73055c7307ef639ad207f6157793d4036267234b45dc8631cd7b3c7d4ff8c4"
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
