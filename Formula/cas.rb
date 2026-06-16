class Cas < Formula
  desc "Zig CLI helpers for Codex app-server orchestration"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.35"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/cas-v#{version}/cas-v#{version}-darwin-arm64.tar.gz"
    sha256 "dd926a70bcf8b3449f7334cc0a23a76157d3f615100f2022ab4dd5b60036a32b"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/cas-v#{version}/cas-v#{version}-linux-x86_64.tar.gz"
    sha256 "bb886e68138b926eb7dda6a12b866b9fb499fd310b41db7cd33418360ab3b568"
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
    bin.install "cas-goal" => "cas_goal"
    bin.install "cas-smoke-check" => "cas_smoke_check"
    bin.install "cas-instance-runner" => "cas_instance_runner"
    bin.install "cas-review-session" => "cas_review_session"
    bin.install "cas-perf-budget-governor"
  end

  test do
    cas_help = shell_output("#{bin}/cas --help 2>&1")
    assert_match "CAS dispatcher for subcommand-style usage", cas_help
    assert_match "Subcommands:", cas_help
    assert_match "goal", cas_help

    conformance_help = shell_output("#{bin}/cas_conformance_suite --help 2>&1")
    assert_match "cas_conformance_suite", conformance_help
    assert_match "Usage:", conformance_help

    goal_help = shell_output("#{bin}/cas_goal --help 2>&1")
    assert_match "cas_goal", goal_help
    assert_match "resolve|get|set|clear|status|wait", goal_help

    smoke_help = shell_output("#{bin}/cas_smoke_check --help 2>&1")
    assert_match "cas_smoke_check", smoke_help
    assert_match "Usage:", smoke_help

    runner_help = shell_output("#{bin}/cas_instance_runner --help 2>&1")
    assert_match "cas_instance_runner", runner_help
    assert_match "Usage:", runner_help

    review_help = shell_output("#{bin}/cas_review_session --help 2>&1")
    assert_match "cas_review_session", review_help
    assert_match "Actions:", review_help
    assert_match "receipt", review_help
    assert_match "--verdict-only", review_help

    perf_help = shell_output("#{bin}/cas-perf-budget-governor --help 2>&1")
    assert_match "Performance harness for budget_governor", perf_help
  end
end
