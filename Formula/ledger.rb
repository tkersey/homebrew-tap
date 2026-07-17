class Ledger < Formula
  desc "CLI for repo-local ledgers, plan addresses, and artifact validation"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.10.4"
  license "MIT"

  depends_on "tkersey/tap/seq"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-darwin-arm64.tar.gz"
    sha256 "5e4039a9a852783dd02718b9b5b53f98800225f665dd35fe7e53e8452d73b95d"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-linux-x86_64.tar.gz"
    sha256 "55c902630224cd5e18c16b9cdd41f39f4551bd66bf4241ecaf247da9f964d986"
  end

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    bin.install "ledger"
  end

  test do
    version_output = shell_output("#{bin}/ledger --version")
    assert_match version.to_s, version_output

    help = shell_output("#{bin}/ledger --help")
    assert_match "Durable source-memory, actuation", help
    assert_match "plan ledger.", help
    assert_match "capture", help
    assert_match "map", help
    assert_match "migrate", help
    assert_match "--source SOURCE", help
    assert_match "recall", help
    assert_match "status", help
    assert_match "export", help
    assert_match "lifecycle-transition proof JSON", help
    assert_match "--route-family ID", help
    assert_match "--proof-pattern ID", help

    validate_help = shell_output("#{bin}/ledger validate --help")
    assert_match "plan-source-contract", validate_help
    assert_match "policy-synthesis-receipt", validate_help
    assert_match "review-fold", validate_help
    assert_match "actuation-review-policy", validate_help
    assert_match "review-resolution", validate_help
    assert_match "source-memory-checkpoint", validate_help
    assert_match "hylo-replay-episode", validate_help
    assert_match "hylo-runner-input", validate_help
    assert_match "hylo-stimulus", validate_help
    assert_match "hylo-target-bundle", validate_help
    assert_match "hylo-world-snapshot", validate_help
    assert_match "hylo-world-availability-receipt", validate_help
    assert_match "hylo-runtime-contract", validate_help
    assert_match "hylo-counterfactual-cut-receipt", validate_help
    assert_match "hylo-redaction-receipt", validate_help
    assert_match "hylo-custody-manifest", validate_help
    assert_match "refinement and owner synthesis", validate_help
    assert_match "never reads or writes .ledger", validate_help

    learning_export_help = shell_output("#{bin}/ledger export --source learnings --help")
    assert_match "memory-note", learning_export_help
    assert_match "Canonical learning id", learning_export_help

    negative_doctor = shell_output("#{bin}/ledger doctor --source negative-ledger")
    assert_match '"ok":true', negative_doctor
    assert_match '"records":0', negative_doctor

    (testpath/"review-resolution.json").write <<~JSON
      {
        "review_resolution": {
          "version": "review-resolution/v1",
          "resolution_id": "tap-smoke",
          "run_id": "run-smoke",
          "review_folds": [
            {
              "version": "RF-v2",
              "findings": [],
              "compression": {"equivalence_classes": []}
            }
          ],
          "finding_ids": [],
          "decisions": [],
          "outcome": {
            "status": "clean",
            "semantic_balance": {
              "uncovered_liabilities": [],
              "required_retirements": [],
              "completed_retirements": [],
              "dominated_remaining": []
            }
          }
        }
      }
    JSON
    resolution_validation = shell_output(
      "#{bin}/ledger validate review-resolution --phase closeout --input #{testpath}/review-resolution.json",
    )
    assert_match '"schema":"actuating-review-resolution-decision/v1"', resolution_validation
    assert_match '"verdict":"pass"', resolution_validation
    assert_match '"authority_granted":false', resolution_validation
    assert_match '"storage_mutated":false', resolution_validation

    (testpath/"malformed-policy.json").write "{}\n"
    policy_validation = shell_output(
      "#{bin}/ledger validate actuation-review-policy --phase preflight --input #{testpath}/malformed-policy.json",
      2,
    )
    assert_match '"schema":"actuation-review-policy-decision/v1"', policy_validation
    assert_match '"verdict":"blocked"', policy_validation
    assert_match '"authority_granted":false', policy_validation
    assert_match '"storage_mutated":false', policy_validation

    (testpath/"malformed-hylo-episode.json").write "{}\n"
    hylo_validation = shell_output(
      "#{bin}/ledger validate hylo-replay-episode --input #{testpath}/malformed-hylo-episode.json",
      2,
    )
    assert_match '"contract":"hylo-replay-episode"', hylo_validation
    assert_match '"verdict":"blocked"', hylo_validation
    assert_match '"authority_granted":false', hylo_validation
    assert_match '"storage_mutated":false', hylo_validation

    (testpath/"plan-source-contract.json").write <<~JSON
      {
        "plan_source_contract": {
          "contract_version": "PSC-v1",
          "source_owner": "spec-pipeline",
          "spec_id": "tap-test",
          "implementation_spec": {"ref": "tap-test"},
          "decision_packet": {"ref": "tap-test"},
          "proof_bar": {"command": "ledger --version"},
          "target_branch": "main",
          "do_not_execute_before": [],
          "sgr_v2": {
            "spec_governance_receipt": {
              "receipt_version": "SGR-v2",
              "mode": "full",
              "status": "complete",
              "lane": "spec_to_plan",
              "gate": {
                "plan_allowed": "yes",
                "material_open_questions_remaining": "no"
              },
              "lint": {
                "verdict": "pass",
                "blocked_handoff": "no"
              },
              "execution_handoff": {
                "ready_for_plan": "yes",
                "next_owner": "$plan",
                "do_not_execute_before": []
              },
              "auto_plan_handoff": {
                "eligible": "yes",
                "invocation": "same_turn_tail_call"
              }
            }
          }
        }
      }
    JSON
    validation = shell_output(
      "#{bin}/ledger validate plan-source-contract --input #{testpath}/plan-source-contract.json",
    )
    assert_match '"verdict":"pass"', validation
    assert_match '"authority_granted":false', validation
    assert_match '"storage_mutated":false', validation

    actuation_help = shell_output("#{bin}/ledger --source actuation --help")
    assert_match "one causal actuation-kernel transition", actuation_help
    assert_match "prepare", actuation_help
    assert_match "decide", actuation_help

    if OS.mac?
      hylo_help = shell_output("#{bin}/ledger --source hylo --help")
      assert_match "portable replay-campaign validation", hylo_help
      assert_match "validate-campaign", hylo_help
      assert_match "snapshot-target", hylo_help
      assert_match "progress", hylo_help
      assert_match "frontier", hylo_help
      assert_match "next-experiment", hylo_help
    end

    universalist_help = shell_output("#{bin}/ledger --source universalist --help")
    assert_match "Allocate, resolve, and emit receipts for Universalist plan artifacts", universalist_help
    assert_match "create", universalist_help
    assert_match "latest", universalist_help
    assert_match "path", universalist_help
    assert_match "emit", universalist_help

    system "git", "init", "-q"
    if OS.mac?
      frontier = shell_output(
        "#{bin}/ledger --source hylo frontier --campaign-id tap-missing --format json 2>&1",
        2,
      )
      assert_match '"error":"CampaignMissing"', frontier
      next_experiment = shell_output(
        "#{bin}/ledger --source hylo next-experiment --campaign-id tap-missing --format json 2>&1",
        2,
      )
      assert_match '"error":"CampaignMissing"', next_experiment
    end
    (testpath/".gitignore").write ".ledger/\n"
    (testpath/"universalist-plan.md").write "# Universalist Plan\n\n## Status: planned\n"
    skill_root = testpath/"universalist-skill"
    (skill_root/"references").mkpath
    (skill_root/"package.json").write "{\"version\":\"16.0.4\"}\n"
    (skill_root/"references/decision-contract.json").write <<~JSON
      {"skill_decision_contract":{"contract_version":"SKDC-v1","skill":{"name":"universalist","kind":"mixed","source_fingerprint":"tap-v1"},"triggers":[{"trigger_id":"UNI-TAP","description":"tap trigger","cue_literals":["tap"],"cue_regexes":[],"exclusions":[]}],"routes":[{"route_id":"UNI-ORDINARY","description":"tap route","aliases":[],"terminal":false},{"route_id":"UNI-PRESERVE","description":"tap alternative","aliases":[],"terminal":true}],"clauses":[{"clause_id":"UNI-TAP-001","trigger_refs":["UNI-TAP"],"expected_routes":["UNI-ORDINARY","UNI-PRESERVE"],"prohibited_routes":[],"required_artifacts":["receipt"],"success_signals":[],"failure_signals":[],"rationale":"tap coverage"}],"instrumentation":{"decision_receipt":"required","rationale":"tap coverage"}}}
    JSON
    system "git", "config", "user.name", "Homebrew Test"
    system "git", "config", "user.email", "homebrew-test@example.invalid"
    system "git", "add", ".gitignore", "universalist-plan.md", "universalist-skill"
    system "git", "commit", "-q", "-m", "Add Universalist fixtures"
    first_plan = shell_output(
      "#{bin}/ledger create --source universalist --repo #{testpath} --template #{testpath}/universalist-plan.md",
    )
    second_plan = shell_output(
      "#{bin}/ledger create --source universalist --repo #{testpath} --template #{testpath}/universalist-plan.md",
    )
    first_id = first_plan[/"plan_id":"([^"]+)"/, 1]
    second_id = second_plan[/"plan_id":"([^"]+)"/, 1]
    first_path = first_plan[/"path":"([^"]+)"/, 1]
    second_path = second_plan[/"path":"([^"]+)"/, 1]
    refute_equal first_id, second_id
    refute_equal first_path, second_path
    assert_equal (testpath/".ledger/universalist/plan-#{first_id}.md").to_s, first_path
    assert_equal (testpath/".ledger/universalist/plan-#{second_id}.md").to_s, second_path
    assert_path_exists first_path
    assert_path_exists second_path
    assert_equal second_path, shell_output(
      "#{bin}/ledger latest --source universalist --repo #{testpath} --format path",
    ).strip
    assert_equal first_path, shell_output(
      "#{bin}/ledger path --source universalist --repo #{testpath} --id #{first_id}",
    ).strip

    receipt = shell_output(
      "#{bin}/ledger emit --source universalist " \
      "--plan #{first_path} --contract #{skill_root}/references/decision-contract.json " \
      "--trigger-ref UNI-TAP --clause-ref UNI-TAP-001 " \
      "--question tap-seam --selected-route UNI-ORDINARY " \
      "--rejected-route UNI-PRESERVE --expected-outcome tap-outcome " \
      "--disposition changed --construction tap-adapter --law tap-law " \
      "--falsifier tap-falsifier --advanced-mechanics none " \
      "--evidence-ref tap:formula --write-plan",
    )
    assert_match '"selected_route":"UNI-ORDINARY"', receipt
    assert_match '"skill_decision_receipt"', File.read(first_path)

    system bin/"ledger", "init"
    assert_path_exists testpath/".ledger/negative-ledger/events.jsonl"
    assert_match "\"ok\":true", shell_output("#{bin}/ledger doctor")

    capture_help = shell_output("#{bin}/ledger capture --source learnings --help 2>&1")
    assert_match "repo-local learning-source API", capture_help

    legacy_repo = testpath/"legacy-repo"
    legacy_repo.mkpath
    system "git", "-C", legacy_repo, "init", "-q"
    (legacy_repo/".gitignore").write ".ledger/\n"
    (legacy_repo/".learnings.jsonl").write <<~JSONL
      {"id":"lrn-old-1","status":"do_more","learning":"Keep valid legacy records."}
      {"id":"lrn-old-2","status":"do_more","fingerprint":"fp",
      tags":["migration"]}
      ags":["orphan"]}
    JSONL
    legacy_doctor = shell_output(
      "cd #{legacy_repo} && #{bin}/ledger doctor --source learnings",
      1,
    )
    assert_match '"status":"invalid"', legacy_doctor
    assert_match '"repaired_records":1', legacy_doctor
    assert_match '"invalid_records":1', legacy_doctor
    migration = shell_output(
      "cd #{legacy_repo} && #{bin}/ledger migrate --source learnings --mode copy --invalid-policy skip",
    )
    assert_match '"status":"migrated_with_skips"', migration
    assert_match '"records":2', migration
    assert_match '"repaired_records":1', migration
    assert_match '"skipped_records":1', migration
    assert_match '"legacy_left_in_place":true', migration
    assert_path_exists legacy_repo/".learnings.jsonl"
    assert_path_exists legacy_repo/".ledger/learnings/events.jsonl"
    assert_match '"status":"current"', shell_output(
      "cd #{legacy_repo} && #{bin}/ledger doctor --source learnings",
    )

    assert_match "synesthesia", shell_output("#{bin}/ledger --help")
    assert_match "\"status\":\"missing\"", shell_output("#{bin}/ledger doctor --source synesthesia")

    (testpath/"synesthesia.json").write <<~JSON
      {"operation":"assert","authority":"explicit-user-endorsement","summary":"Endorse long corridor.","scope":{"kind":"task-family","repo":null,"paths":[]},"source_refs":[{"kind":"user","ref":"tap-test","summary":"User endorsed long corridor mapping."}],"related_ids":[],"supersedes_id":null,"payload":{"sensory_phrase":"long corridor","engineering_translation":"serialized waits","activation_boundary":"latency work","non_activation_boundary":"syntax","verification":"name the wait"}}
    JSON
    system bin/"ledger", "capture", "--source", "synesthesia",
      "--kind", "mapping-endorsement", "--json", testpath/"synesthesia.json"
    assert_path_exists testpath/".ledger/synesthesia/events.jsonl"
    synesthesia_recent = shell_output("#{bin}/ledger recent --source synesthesia --limit 1")
    assert_match "long corridor", synesthesia_recent
    synesthesia_id = synesthesia_recent[/SYN-[^ ]+/]
    assert_match "SYN-", synesthesia_id
    synesthesia_export = shell_output(
      "#{bin}/ledger export --source synesthesia --format memory-note --id #{synesthesia_id}",
    )
    assert_match "\"operation\":\"assert\"", synesthesia_export
    refute_match "logical_kind", synesthesia_export

    system bin/"ledger", "capture", "--source", "learnings",
      "--status", "do_more",
      "--learning",
      "When tap tests install ledger, use ledger capture --source learnings because formula tests catch regressions.",
      "--evidence", "command: brew test ledger writes .ledger/learnings/events.jsonl",
      "--application", "Keep ledger --source learnings covered in the formula test.",
      "--tag", "homebrew",
      "--allow-temp-path"
    assert_path_exists testpath/".ledger/learnings/events.jsonl"
    recent = shell_output("#{bin}/ledger recent --source learnings --limit 1")
    assert_match "tap tests install ledger", recent
  end
end
