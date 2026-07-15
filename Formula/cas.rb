class Cas < Formula
  desc "Zig CLI helpers for Codex app-server orchestration"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.76"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/cas-v#{version}/cas-v#{version}-darwin-arm64.tar.gz"
    sha256 "076b390d116ba4656063aae0383ce248240529333daedf346e5839b0b9210e40"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/cas-v#{version}/cas-v#{version}-linux-x86_64.tar.gz"
    sha256 "a010979fda0821c8e5f5c8932e52f6430ecc5a491d9dc0852265d40573bd4f7b"
  end

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    bin.install "cas"
    bin.install "cas_account"
    bin.install "cas-conformance-suite" => "cas_conformance_suite"
    bin.install "cas-goal" => "cas_goal"
    bin.install "cas-smoke-check" => "cas_smoke_check"
    bin.install "cas-instance-runner" => "cas_instance_runner"
    bin.install "cas-review-session" => "cas_review_session"
    bin.install "cas-session-inquiry" => "cas_session_inquiry"
    bin.install "cas-perf-budget-governor"
  end

  test do
    cas_help = shell_output("#{bin}/cas --help 2>&1")
    assert_match "CAS dispatcher for subcommand-style usage", cas_help
    assert_match "Subcommands:", cas_help
    assert_match "goal", cas_help

    account_help = shell_output("#{bin}/cas_account --help 2>&1")
    assert_match "cas_account", account_help
    assert_match "Usage:", account_help

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
    assert_match "--multi-agent-mode", runner_help

    review_help = shell_output("#{bin}/cas_review_session --help 2>&1")
    assert_match "cas_review_session", review_help
    assert_match "Actions:", review_help
    assert_match "run", review_help
    assert_match "receipt", review_help
    assert_match "--verdict-only", review_help
    assert_match "--multi-agent-mode", review_help
    assert_match "--workflow-binding-json", review_help
    assert_match "Real review waits default to 2700000", review_help
    assert_match "smoke/control waits default to 300000", review_help
    assert_match "--workflow-binding-json", shell_output("#{bin}/cas review_session --help 2>&1")
    capabilities = shell_output("#{bin}/cas capabilities --json")
    assert_match "\"cas_rer_workflow_binding_v1\": false", capabilities
    assert_match "\"cas_rer_opaque_request_binding_v1\": true", capabilities
    assert_match "\"cas_review_history_v2\": true", capabilities
    assert_match "\"cas_review_scoped_instructions_v1\": true", capabilities

    inquiry_help = shell_output("#{bin}/cas_session_inquiry --help 2>&1")
    assert_match "cas_session_inquiry", inquiry_help
    assert_match "session_inquiry", shell_output("#{bin}/cas --help 2>&1")

    perf_help = shell_output("#{bin}/cas-perf-budget-governor --help 2>&1")
    assert_match "Performance harness for budget_governor", perf_help
  end
end
