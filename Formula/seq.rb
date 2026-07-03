class Seq < Formula
  desc "Zig CLI for mining Codex session and memory artifacts"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.3.38"
  license "MIT"

  if OS.mac?
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-darwin-arm64.tar.gz"
    sha256 "31b0220fdbea55f21de592eb2c7f8c2e1d88a22953e7181518b070ef6c470d3c"
  else
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-linux-x86_64.tar.gz"
    sha256 "4d0c1785437c0bc78886987d527669944231badf82c8bc23db597881d7b263a2"
  end

  def install
    bin.install "seq"
  end

  test do
    help = shell_output("#{bin}/seq --help")
    assert_match "skills-rank", help
    assert_match "skill-success-rank", help
    assert_match "skill-evidence", help
    assert_match "skill-blocks", help
    assert_match "artifact-search", help
    assert_match "skill-audit", help
    assert_match "tool-audit", help
    assert_match "memory-inventory", help
    assert_match "message-search", help
    assert_match "workdir-report", help
    assert_match "memory-provenance", help
    assert_match "memory-map", help
    assert_match "memory-history", help
    assert_match "plan-search", help
    assert_match "reply-latency", help
    assert_match "workflow-audit", help
    assert_match "message-audit", help
    assert_match "skill-cohort", help
    assert_match "tool-search", help
    assert_match "memory-extension-audit", help
    assert_match "token-window", help
    assert_match "goal-audit", help
    assert_match "adjudication-audit", help
    assert_match "workflow-overlap", help
    assert_match "resolve-churn-audit", help
    assert_match "review-compiler-audit", help
    assert_match "skill-decision-audit", help
    assert_match "skill-contract", help
    assert_match "skill-decision-receipt", help
    assert_match "decision-capsule", help
    assert_match "execution-policy-audit", help
    assert_match "dataset-schema", help
    assert_match "query", help

    capabilities = shell_output("#{bin}/seq capabilities --format json")
    assert_match "\"actuation_hylo_audit_v1\": true", capabilities
    assert_match "\"decision_capsule_v1\": true", capabilities
    assert_match "\"decision_anchor_v1\": true", capabilities
    assert_match "\"historical_decisions_dataset_v1\": true", capabilities
    assert_match "\"dcp_validation_v1\": true", capabilities
    assert_match "\"review_compiler_provenance_v1\": true", capabilities
    assert_match "\"review_compiler_run_ledger_v1\": true", capabilities
    assert_match "\"resolve_acceptance_contract_v2\": true", capabilities
    assert_match "\"resolve_review_batch_v1\": true", capabilities
    assert_match "\"resolve_review_aperture_v1\": true", capabilities
    assert_match "\"resolve_counterexample_v1\": true", capabilities
    assert_match "\"resolve_counterexample_basis_v2\": true", capabilities
    assert_match "\"resolve_review_potential_v1\": true", capabilities
    assert_match "\"resolve_intent_closed_audit_v1\": true", capabilities
    assert_match "\"internal_context_not_success_v1\": true", capabilities
    assert_match "\"source_governance_projection_v1\": true", capabilities
    assert_match "\"c3_structured_closure_v1\": true", capabilities
    assert_match "\"execution_policy_audit_v1\": true", capabilities
    assert_match "\"policy_transition_dataset_v1\": true", capabilities

    token_help = shell_output("#{bin}/seq token-usage --help")
    assert_match "--tz", token_help
    assert_match "--last", token_help
    assert_match "--summary", token_help
    assert_match "--audit", token_help

    token_cost_help = shell_output("#{bin}/seq token-cost --help")
    assert_match "--pricing", token_cost_help
    assert_match "--model", token_cost_help

    skill_audit_help = shell_output("#{bin}/seq skill-audit --help")
    assert_match "summary|mentions|trend|activation", skill_audit_help
    assert_match "--exclude-current", skill_audit_help
    assert_match "--last", skill_audit_help
    assert_match "summary|sessions", shell_output("#{bin}/seq skill-success-rank --help")
    skill_blocks_help = shell_output("#{bin}/seq skill-blocks --help")
    assert_match "blocks|body|term-counts|term-summary", skill_blocks_help
    assert_match "term-counts", skill_blocks_help
    assert_match "term-summary", skill_blocks_help
    assert_match "--term-group", skill_blocks_help
    assert_match "summary|rows|args|unresolved", shell_output("#{bin}/seq tool-audit --help")
    assert_match "categories|files|blocks|stage1|extensions", shell_output("#{bin}/seq memory-inventory --help")
    assert_match "--contains-any", shell_output("#{bin}/seq message-search --help")
    assert_match "summary|sessions", shell_output("#{bin}/seq workdir-report --help")
    artifact_search_help = shell_output("#{bin}/seq artifact-search --help")
    assert_match "--contains-any", artifact_search_help
    assert_match "summary|rows|sessions", shell_output("#{bin}/seq message-audit --help")
    skill_cohort_help = shell_output("#{bin}/seq skill-cohort --help")
    assert_match "summary|cohort|mentions", skill_cohort_help
    assert_match "--last", skill_cohort_help
    tool_search_help = shell_output("#{bin}/seq tool-search --help")
    assert_match "rows|summary|args", tool_search_help
    assert_match "--path", tool_search_help
    assert_match "--session-id", tool_search_help
    assert_match "--contains-any", tool_search_help
    assert_match "summary|rows", shell_output("#{bin}/seq memory-extension-audit --help")
    assert_match "--window-hours", shell_output("#{bin}/seq token-window --help")
    assert_match "review|resolve", shell_output("#{bin}/seq goal-audit --help")
    workflow_audit_help = shell_output("#{bin}/seq workflow-audit --help")
    assert_match "cohort-report", workflow_audit_help
    assert_match "term-summary", workflow_audit_help
    assert_match "--term-group", workflow_audit_help
    assert_match "--last", workflow_audit_help
    adjudication_help = shell_output("#{bin}/seq adjudication-audit --help")
    assert_match "summary|rows|report", adjudication_help
    assert_match "--include-root-equivalent", adjudication_help
    assert_match "--bundle-dir", adjudication_help

    resolve_churn_help = shell_output("#{bin}/seq resolve-churn-audit --help")
    assert_match "--since", resolve_churn_help
    assert_match "--until", resolve_churn_help
    assert_match "--repo", resolve_churn_help
    assert_match "markdown|json", resolve_churn_help

    review_compiler_help = shell_output("#{bin}/seq review-compiler-audit --help")
    assert_match "--since", review_compiler_help
    assert_match "--until", review_compiler_help
    assert_match "--repo", review_compiler_help
    assert_match "--protocol", review_compiler_help
    assert_match "c3-mrpc", review_compiler_help
    assert_match "mbk", review_compiler_help
    assert_match "table|json|jsonl|markdown", review_compiler_help

    execution_policy_help = shell_output("#{bin}/seq execution-policy-audit --help")
    assert_match "summary|runs|policies|transitions|calibration|regret|proof|report", execution_policy_help
    assert_match "--policy-root", execution_policy_help

    actuation_audit_help = shell_output("#{bin}/seq actuation-audit --help")
    assert_match "summary|runs|slices|proof|compactions|decisions|hylo|report", actuation_audit_help

    session_dir = testpath/"sessions/2026/05/13"
    session_dir.mkpath
    (session_dir/"rollout-c3-orphan.jsonl").write <<~JSONL
      {"type":"session_meta","timestamp":"2026-05-13T12:00:00Z","payload":{"id":"c3-orphan-closed","cwd":"#{testpath}","model":"gpt-5"}}
      {"type":"event_msg","timestamp":"2026-05-13T12:00:01Z","payload":{"type":"agent_message","turn_id":"x1","message":"MRPC-v1 minimal_review_patch_certificate\\nclosed"}}
    JSONL
    review_compiler_audit = shell_output(
      "#{bin}/seq review-compiler-audit " \
      "--root #{testpath}/sessions --protocol c3 " \
      "--since 2026-05-13T00:00:00Z --until 2026-05-14T00:00:00Z " \
      "--repo #{testpath} --format json",
    )
    assert_match "\"included_sessions\"", review_compiler_audit
    assert_match "\"reason\": \"no_c3_begin_signal\"", review_compiler_audit
    assert_match "\"state\": \"declared_uncontrolled\"", review_compiler_audit
    assert_match "\"c3_closed\": false", review_compiler_audit
    assert_match "\"summary_state\": \"NONE\"", review_compiler_audit

    decision_capsule_help = shell_output("#{bin}/seq decision-capsule --help")
    assert_match "capsule|candidates|anchors|validate", decision_capsule_help
    assert_match "--thread-id", decision_capsule_help
    assert_match "--mode", decision_capsule_help
    assert_match "--format", decision_capsule_help
    assert_match "table|json|jsonl|csv|markdown", decision_capsule_help

    decision_capsules_schema = shell_output(
      "#{bin}/seq dataset-schema --dataset decision_capsules --format json",
    )
    assert_match "decision_capsules", decision_capsules_schema

    historical_decisions_schema = shell_output(
      "#{bin}/seq dataset-schema --dataset historical_decisions --format json",
    )
    assert_match "historical_decisions", historical_decisions_schema

    execution_policy_schema = shell_output(
      "#{bin}/seq dataset-schema --dataset execution_policy_transitions --format json",
    )
    assert_match "execution_policy_transitions", execution_policy_schema
    assert_match "transition_audits", execution_policy_schema
  end
end
