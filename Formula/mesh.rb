class Mesh < Formula
  desc "Zig CLI for plan-driven orchestration helpers"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.7"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/mesh-v#{version}/mesh-v#{version}-darwin-arm64.tar.gz"
    sha256 "350a0baa5c52dd7c092fab7b0e720227a9bb74db4de41e241f115268a33680af"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/mesh-v#{version}/mesh-v#{version}-linux-x86_64.tar.gz"
    sha256 "957d9bf5643a7e9c12e4a454287c5f2c9b080906e4ea5b59c5b4368062cacac9"
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
    help = shell_output("#{bin}/mesh --help")
    assert_match "Plan-driven orchestration helpers", help
    assert_match "migration_gate", help
  end
end
