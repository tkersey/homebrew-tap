class Mesh < Formula
  desc "Zig CLI for plan-driven orchestration helpers"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.9"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/mesh-v#{version}/mesh-v#{version}-darwin-arm64.tar.gz"
    sha256 "b2aef852627ee3d528c0295cef8b6a0350e6e66cff5bd1d0ca60adca7cf08e44"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/mesh-v#{version}/mesh-v#{version}-linux-x86_64.tar.gz"
    sha256 "1d07ad90cc61518e4b322702740de51ad9e6b807d65e6855b3aa0cfe049bfeee"
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
