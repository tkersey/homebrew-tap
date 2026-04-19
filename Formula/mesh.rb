class Mesh < Formula
  desc "Zig CLI for plan-driven orchestration helpers"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.6"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/mesh-v#{version}/mesh-v#{version}-darwin-arm64.tar.gz"
    sha256 "3233d913b78c6c88e83920c25369b42a5c182336f73e6ad2971f92a9fb40768a"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/mesh-v#{version}/mesh-v#{version}-linux-x86_64.tar.gz"
    sha256 "94546f1c50d475e577cbcb87d1b5eb64525f568c8769ac7838733099d9e53b05"
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
