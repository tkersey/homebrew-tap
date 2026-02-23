class Cas < Formula
  desc "Zig CLI helpers for Codex app-server orchestration"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.6"

  on_macos do
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/cas-v#{version}/cas-v#{version}-darwin-arm64.tar.gz"
    sha256 "e23655f3856cf516ca027c0566e94446033f51f123fb9902dc18f0aae99fc960"
  end

  on_linux do
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/cas-v#{version}/cas-v#{version}-linux-x86_64.tar.gz"
    sha256 "6a82353d7fef5286a8be8cbaa9d8ff2aa9874834061766d8b28ff2d14b987c7b"
  end

  depends_on "node"

  def install
    bin.install "cas"
    bin.install "cas-smoke-check" => "cas_smoke_check"
    bin.install "cas-instance-runner" => "cas_instance_runner"
  end

  test do
    cas_help = shell_output("#{bin}/cas --help 2>&1")
    assert_match "cas.zig", cas_help
    assert_match "Subcommands:", cas_help

    smoke_help = shell_output("#{bin}/cas_smoke_check --help 2>&1")
    assert_match "cas_smoke_check.zig", smoke_help
    assert_match "Usage:", smoke_help

    runner_help = shell_output("#{bin}/cas_instance_runner --help 2>&1")
    assert_match "cas_instance_runner.zig", runner_help
    assert_match "Usage:", runner_help

    dispatch_help = shell_output("#{bin}/cas smoke_check --help 2>&1")
    assert_match "cas_smoke_check.zig", dispatch_help
  end
end
