class Cas < Formula
  desc "Zig CLI helpers for Codex app-server orchestration"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.13"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/cas-v#{version}/cas-v#{version}-darwin-arm64.tar.gz"
    sha256 "f987b34b428a4f6e4d2507c4eab980b41b7aeb8825b8112663f259f4db2ba0f7"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/cas-v#{version}/cas-v#{version}-linux-x86_64.tar.gz"
    sha256 "53f07ded287bd302c9020e963bff7ad3ddba3f350c4db16e2b672521dc3c2c0c"
  end

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    bin.install "cas"
    bin.install "cas-conformance-suite" => "cas_conformance_suite"
    bin.install "cas-smoke-check" => "cas_smoke_check"
    bin.install "cas-instance-runner" => "cas_instance_runner"
  end

  test do
    cas_help = shell_output("#{bin}/cas --help 2>&1")
    assert_match "cas.zig", cas_help
    assert_match "Subcommands:", cas_help

    conformance_help = shell_output("#{bin}/cas_conformance_suite --help 2>&1")
    assert_match "cas_conformance_suite.zig", conformance_help
    assert_match "Usage:", conformance_help

    smoke_help = shell_output("#{bin}/cas_smoke_check --help 2>&1")
    assert_match "cas_smoke_check.zig", smoke_help
    assert_match "Usage:", smoke_help

    runner_help = shell_output("#{bin}/cas_instance_runner --help 2>&1")
    assert_match "cas_instance_runner.zig", runner_help
    assert_match "Usage:", runner_help

    dispatch_help = shell_output("#{bin}/cas conformance --help 2>&1")
    assert_match "cas_conformance_suite.zig", dispatch_help
  end
end
