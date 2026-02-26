class Mesh < Formula
  desc "Zig CLI for plan-driven orchestration helpers"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.0"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/mesh-v#{version}/mesh-v#{version}-darwin-arm64.tar.gz"
    sha256 "31968f43d8f641dd2717fd84401cd68cbc70f4493d14e84c24a03a303c1f0390"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/mesh-v#{version}/mesh-v#{version}-linux-x86_64.tar.gz"
    sha256 "606fc5935a82da4ed06efd13a5d1a5399c0ea8366cd5ac1be80ffd908b57064d"
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
