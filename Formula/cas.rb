class Cas < Formula
  desc "Zig CLI helpers for Codex app-server orchestration"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.82"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/cas-v#{version}/cas-v#{version}-darwin-arm64.tar.gz"
    sha256 "9f276533ec93aa9d87fd759334a634cd3ae81e2d86ead2f0b5d32df93d4f212f"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/cas-v#{version}/cas-v#{version}-linux-x86_64.tar.gz"
    sha256 "07bea8eb02457351a6b0f8ed5dcda14de146d1486b1d65e5d560cc3b14a7767c"
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
    bin.install "cas_trial" if OS.mac?
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

    if OS.mac?
      assert_path_exists bin/"cas_trial"
      assert_match version.to_s, shell_output("#{bin}/cas_trial --version")
      assert_match "trial", cas_help
      assert_match "\"hylo_trial_runner_v1\": true", capabilities
      assert_match "\"hylo_fd_lane_lease_v1\": true", capabilities
      assert_match "\"hylo_signed_run_receipt_v1\": true", capabilities

      trial_help = shell_output("#{bin}/cas trial --help 2>&1")
      assert_match "One-claim HCTP lane runner", trial_help
      assert_match "preflight", trial_help
      assert_match "compile-replay", trial_help
      assert_match "run", trial_help
      assert_match "status", trial_help
      assert_match "cleanup", trial_help
      assert_match "key-info", trial_help

      direct_trial_help = shell_output("#{bin}/cas_trial --help 2>&1")
      assert_match "One-claim HCTP-v1 lane runner", direct_trial_help

      invalid_trial = testpath/"invalid-trial.json"
      invalid_trial.write "{}\n"
      preflight = shell_output(
        "#{bin}/cas trial preflight --trial #{invalid_trial} --lane-id tap-lane --json 2>&1",
        1,
      )
      assert_match "MissingField", preflight
    end

    inquiry_help = shell_output("#{bin}/cas_session_inquiry --help 2>&1")
    assert_match "cas_session_inquiry", inquiry_help
    assert_match "session_inquiry", shell_output("#{bin}/cas --help 2>&1")

    perf_help = shell_output("#{bin}/cas-perf-budget-governor --help 2>&1")
    assert_match "Performance harness for budget_governor", perf_help
  end
end
