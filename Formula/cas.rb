class Cas < Formula
  desc "Zig CLI helpers for Codex app-server orchestration"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.14"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/cas-v#{version}/cas-v#{version}-darwin-arm64.tar.gz"
    sha256 "cb527f328078dfb895ef6ea6c8690ea67d7370514db5ea550c568e39a826e664"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/cas-v#{version}/cas-v#{version}-linux-x86_64.tar.gz"
    sha256 "4e43135c77ea6e2e9058da92c7a6e6bf90b09c61601cd023a64fe1b1c52d3b04"
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
    bin.install "cas-review-session" => "cas_review_session"
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

    review_help = shell_output("#{bin}/cas_review_session --help 2>&1")
    assert_match "cas_review_session.zig", review_help
    assert_match "Actions:", review_help

    dispatch_help = shell_output("#{bin}/cas conformance --help 2>&1")
    assert_match "cas_conformance_suite.zig", dispatch_help
  end
end
