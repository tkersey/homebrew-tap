class Cas < Formula
  desc "Zig CLI helpers for Codex app-server orchestration"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.32"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/cas-v#{version}/cas-v#{version}-darwin-arm64.tar.gz"
    sha256 "ba7a9b306be98ee88648b298a3eb870d95d0459a3a4e5da85a0587d7dedf85e6"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/cas-v#{version}/cas-v#{version}-linux-x86_64.tar.gz"
    sha256 "4b56fe5d30ef30675e3ddd1295502c7957f52bbef770a76ae4227dadfe6f8bff"
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
    bin.install "cas-perf-budget-governor"
  end

  test do
    cas_help = shell_output("#{bin}/cas --help 2>&1")
    assert_match "CAS dispatcher for subcommand-style usage", cas_help
    assert_match "Subcommands:", cas_help

    conformance_help = shell_output("#{bin}/cas_conformance_suite --help 2>&1")
    assert_match "cas_conformance_suite", conformance_help
    assert_match "Usage:", conformance_help

    smoke_help = shell_output("#{bin}/cas_smoke_check --help 2>&1")
    assert_match "cas_smoke_check", smoke_help
    assert_match "Usage:", smoke_help

    runner_help = shell_output("#{bin}/cas_instance_runner --help 2>&1")
    assert_match "cas_instance_runner", runner_help
    assert_match "Usage:", runner_help

    review_help = shell_output("#{bin}/cas_review_session --help 2>&1")
    assert_match "cas_review_session", review_help
    assert_match "Actions:", review_help
    assert_match "--verdict-only", review_help

    perf_help = shell_output("#{bin}/cas-perf-budget-governor --help 2>&1")
    assert_match "Performance harness for budget_governor", perf_help
  end
end
