class Cas < Formula
  desc "Local Codex control-plane CLI"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.6.3"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/cas-v#{version}/cas-v#{version}-darwin-arm64.tar.gz"
    sha256 "2208b7b35fb81347557252d3915b628a93537d9c5f58e6e95312cf4b3f81b42d"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/cas-v#{version}/cas-v#{version}-linux-x86_64.tar.gz"
    sha256 "e6a2044fee640c1291222431e7e04818a70367331c97c070eaf322c2909f8199"
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
    bin.install "cas_app_server_preflight"
    bin.install "cas_automation"
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

    refute_path_exists bin/"ledger"
    refute_path_exists libexec/"ledger"
    refute_path_exists bin/"cron"
    refute_path_exists bin/"cas_trial"
    refute_path_exists bin/"synoptic"

    app_server_version = shell_output("#{bin}/cas_app_server_preflight --version 2>&1")
    assert_match version.to_s, app_server_version
    automation_version = shell_output("#{bin}/cas_automation --version 2>&1")
    assert_equal "#{version}\n", automation_version

    app_server_help = shell_output("#{bin}/cas app-server --help 2>&1")
    assert_match "schema|preflight", app_server_help
    automation_help = shell_output("#{bin}/cas automation --help 2>&1")
    assert_match "Manage Codex automations", automation_help

    account_help = shell_output("#{bin}/cas_account --help 2>&1")
    assert_match "cas_account", account_help
    assert_match "Usage:", account_help

    conformance_help = shell_output("#{bin}/cas_conformance_suite --help 2>&1")
    assert_match "cas_conformance_suite", conformance_help
    assert_match "Usage:", conformance_help
    conformance = shell_output(
      "#{bin}/cas conformance --cwd #{testpath} --scenario overload_backoff " \
      "--skip-smoke-check --backoff-base-ms 1 --max-retries 2 --json",
    )
    assert_match '"ok": true', conformance
    assert_match '"attempts": 3', conformance
    assert_match '"retries": 2', conformance

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
    assert_match "cas review", review_help
    assert_match "Actions:", review_help
    assert_match "run", review_help
    assert_match "start", review_help
    assert_match "wait", review_help
    assert_match "--multi-agent-mode", review_help
    assert_match "--workflow-binding-json", review_help
    assert_match "Real review waits default to 2700000", review_help
    assert_match "detached starts default to 300000", review_help
    assert_match "--workflow-binding-json", shell_output("#{bin}/cas review --help 2>&1")
    capabilities = shell_output("#{bin}/cas capabilities --json")
    assert_match "\"cas_rer_opaque_request_binding_v1\": true", capabilities
    assert_match "\"cas_review_scoped_instructions_v1\": true", capabilities
    assert_match "\"cas_app_server_contract_v2\": true", capabilities
    assert_match "\"cas_app_server_stateful_session_v1\": true", capabilities
    assert_match "\"cas_app_server_daemon_v1\": true", capabilities
    assert_match "\"cas_app_server_grpc_code_mode_host_v1\": true", capabilities
    assert_match "\"cas_automation_v1\": true", capabilities

    inquiry_help = shell_output("#{bin}/cas_session_inquiry --help 2>&1")
    assert_match "cas_session_inquiry", inquiry_help
    assert_match "session_inquiry", shell_output("#{bin}/cas --help 2>&1")

    perf_help = shell_output("#{bin}/cas-perf-budget-governor --help 2>&1")
    assert_match "Performance harness for budget_governor", perf_help
  end
end
