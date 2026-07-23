class Seq < Formula
  desc "Zig CLI for mining Codex session and memory artifacts"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.3.59"
  license "MIT"

  if OS.mac?
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-darwin-arm64.tar.gz"
    sha256 "2956d665443f7450cb295b44af44f274ac1cdff3121c9de8db311eee60dc2287"
  else
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-linux-x86_64.tar.gz"
    sha256 "741262ae2337b37bf1d5daf15390d575e3bb2363b951bc36a00095b0f774c48c"
  end

  def install
    bin.install "seq"
  end

  test do
    version_output = shell_output("#{bin}/seq --version")
    assert_match version.to_s, version_output

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
    assert_match "policy-calibration", help
    assert_match "find-session", help
    assert_match "dataset-schema", help
    assert_match "query", help
    if OS.mac?
      assert_match "hctp-source", help
      assert_match "hylo-extract", help
    end

    capabilities = shell_output("#{bin}/seq capabilities --format json")
    assert_match "\"streaming_session_scanner_v1\": true", capabilities
    assert_match "\"actuation_hylo_audit_v1\": true", capabilities
    assert_match "\"actuation_artifact_kernel_audit_v1\": true", capabilities
    assert_match "\"skill_contract_v1\": true", capabilities
    assert_match "\"skill_decision_receipt_contract_binding_v1\": true", capabilities
    assert_match "\"skill_contract_receipt_binding_projection_v1\": true", capabilities
    assert_match "\"skill_decision_receipt_v1\": true", capabilities
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

    (testpath/"receipt-contract.json").write <<~JSON
      {"skill_decision_contract":{"contract_version":"SKDC-v1","skill":{"name":"tap-skill","kind":"decision","source_fingerprint":"tap-v1"},"triggers":[{"trigger_id":"T1","description":"tap trigger","cue_literals":["tap"],"cue_regexes":[],"exclusions":[]}],"routes":[{"route_id":"R1","description":"tap route","aliases":[],"terminal":true}],"clauses":[{"clause_id":"C1","trigger_refs":["T1"],"expected_routes":["R1"],"prohibited_routes":[],"required_artifacts":["receipt"],"success_signals":[],"failure_signals":[],"rationale":"tap coverage"}],"instrumentation":{"decision_receipt":"required","rationale":"tap coverage"}}}
    JSON
    receipt_projection = shell_output(
      "#{bin}/seq skill-contract validate --file #{testpath}/receipt-contract.json --format json",
    )
    assert_match '"valid": true', receipt_projection
    assert_match '"skill_kind": "decision"', receipt_projection
    assert_match '"clause_routes": [{"clause_id": "C1"', receipt_projection
    if OS.mac?
      assert_match "\"hctp_source_selection_v1\": true", capabilities
      assert_match "\"hctp_independence_clusters_v1\": true", capabilities
      assert_match "\"hctp_sealed_case_v1\": true", capabilities
      assert_match "\"hctp_materializer_v1\": true", capabilities
      assert_match "\"hylo_extract_v1\": true", capabilities

      hctp_source_help = shell_output("#{bin}/seq hctp-source --help")
      assert_match "compile", hctp_source_help
      assert_match "validate", hctp_source_help
      assert_match "govern", hctp_source_help
      assert_match "materialize", hctp_source_help

      hylo_extract_help = shell_output("#{bin}/seq hylo-extract --help")
      assert_match "--root", hylo_extract_help
      assert_match "--session-id", hylo_extract_help
      assert_match "--turn-index", hylo_extract_help
      assert_match "--target-skill", hylo_extract_help
      assert_match "--target-root", hylo_extract_help
      assert_match "--output-root", hylo_extract_help
      assert_match "--sealed-root", hylo_extract_help
      assert_match "--seal-key-output-fd", hylo_extract_help
    end

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
    assert_match "summary|runs|slices|proof|compactions|decisions|hylo|kernel|report", actuation_audit_help

    hylo_fixture = testpath/"hylo-resolve.jsonl"
    hylo_fixture.write <<~JSONL
      {"type":"session_meta","timestamp":"2026-07-02T13:10:00Z","payload":{"id":"resolve_without_review_fold","cwd":"#{testpath}","model":"gpt-5","git":{"branch":"feature/hylo","commit_hash":"head-resolve-no-fold"}}}
      {"type":"event_msg","timestamp":"2026-07-02T13:10:01Z","payload":{"type":"task_started","turn_id":"t1"}}
      {"type":"event_msg","timestamp":"2026-07-02T13:10:02Z","payload":{"type":"user_message","turn_id":"t1","message":"$actuating resolve without review-fold fixture."}}
      {"type":"event_msg","timestamp":"2026-07-02T13:10:03Z","payload":{"type":"agent_message","turn_id":"t1","message":"$cas review\\nreview finding: accepted liability\\nagent_loop_scheme_receipt:\\n  receipt_version: ALSR-v1\\nactuation_hylomorphism:\\n  machine_version: HYL-v1\\nhylo_step_receipt:\\n  receipt_version: HSR-v1\\n  unfold:\\n    produced: work_node\\n  action:\\n    effect: edit\\n  fold:\\n    verdict: complete\\n    current_artifact_bound: yes\\n  stop_rule:\\n    success: done\\nATCG-v1:\\n  can_mark_goal_complete: yes"}}
      {"type":"response_item","timestamp":"2026-07-02T13:10:04Z","payload":{"type":"function_call","name":"apply_patch","call_id":"patch-1","arguments":"*** Begin Patch\\n*** Update File: resolve_no_fold.txt\\n+bad\\n*** End Patch"}}
      {"type":"response_item","timestamp":"2026-07-02T13:10:05Z","payload":{"type":"function_call_output","call_id":"patch-1","output":"Success. Updated the following files:\\nM resolve_no_fold.txt\\n"}}
      {"type":"event_msg","timestamp":"2026-07-02T13:10:06Z","payload":{"type":"task_complete","turn_id":"t1","duration_ms":5000}}
    JSONL
    hylo_audit = shell_output("#{bin}/seq actuation-audit --path #{hylo_fixture} --mode hylo --format json")
    assert_match "\"resolve_without_review_fold\":1", hylo_audit
    refute_match "review_fix_without_review_fold", hylo_audit
    refute_match "ship_without_terminal_publication_boundary", hylo_audit

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
