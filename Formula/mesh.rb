class Mesh < Formula
  desc "Zig CLI for plan-driven orchestration helpers"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.4"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/mesh-v#{version}/mesh-v#{version}-darwin-arm64.tar.gz"
    sha256 "02aeabea03cb4bda7793b0a8f95a322541a1837dd5172a8a40bf4d85605c21c8"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/mesh-v#{version}/mesh-v#{version}-linux-x86_64.tar.gz"
    sha256 "c862858c131ceed766b6db56f305bc8f5bb97bf246f199be13c84fe599e7cf91"
  end

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    bin.install "mesh"
  end

  test do
    assert_match "mesh.zig", shell_output("#{bin}/mesh --help")
  end
end
