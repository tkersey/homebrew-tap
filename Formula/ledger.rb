class Ledger < Formula
  desc "CLI for repo-local ledgers, plan addresses, and artifact validation"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.7.2"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-darwin-arm64.tar.gz"
    sha256 "64b8bb8081c048de5c6f3d77734a6d5074f5babf1a5c26ba9a1bb6b9e5c2bb7a"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-linux-x86_64.tar.gz"
    sha256 "364e3974cbbaa1323ecea545056bfce16cc33de2886b0e98470a1fdb0b5e8457"
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
    assert_match "Durable source-memory, actuation, replay, and plan ledger.", help
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
    assert_match "never reads or writes .ledger", validate_help

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

    hylo_help = shell_output("#{bin}/ledger --source hylo --help")
    assert_match "portable replay-campaign validation", hylo_help
    assert_match "validate-campaign", hylo_help
    assert_match "snapshot-target", hylo_help
    assert_match "progress", hylo_help

    universalist_help = shell_output("#{bin}/ledger --source universalist --help")
    assert_match "collision-safe Universalist plan artifacts", universalist_help
    assert_match "create", universalist_help
    assert_match "latest", universalist_help
    assert_match "path", universalist_help

    system "git", "init", "-q"
    (testpath/".gitignore").write ".ledger/\n"
    (testpath/"universalist-plan.md").write "# Universalist Plan\n\n## Status: planned\n"
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
