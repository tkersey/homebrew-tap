class Ledger < Formula
  desc "CLI for repo-local ledgers, plan addresses, and artifact validation"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.13.1"
  license "MIT"

  depends_on "tkersey/tap/seq"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-darwin-arm64.tar.gz"
    sha256 "e740bab4f518925e1f77d2d9123a91ee536e82ff7679096e3b6819bb79c080bc"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-linux-x86_64.tar.gz"
    sha256 "8342de2042c5e53b11ae6974fc9bb59765e0a63e2f91524c6c9a09be7db65952"
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
    assert_match "Materialize, validate, record, and project workflow artifacts", help
    assert_match "including Actuating evidence", help
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
    assert_match "source-memory-checkpoint", validate_help
    assert_match "never reads or writes .ledger", validate_help

    learning_export_help = shell_output("#{bin}/ledger export --source learnings --help")
    assert_match "memory-note", learning_export_help
    assert_match "Canonical learning id", learning_export_help

    learning_show_help = shell_output("#{bin}/ledger show --source learnings --help")
    assert_match "alias for export --format full", learning_show_help
    assert_match "Canonical learning id", learning_show_help

    (testpath/".ledger/negative-ledger").mkpath
    negative_doctor = shell_output("#{bin}/ledger doctor --source negative-ledger")
    assert_match '"ok":true', negative_doctor
    assert_match '"records":0', negative_doctor

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
    assert_match "Materialize Actuating artifacts", actuation_help
    assert_match "append", actuation_help
    assert_match "prepare", actuation_help
    assert_match "state", actuation_help
    assert_match "project", actuation_help
    assert_match "--review-contract FILE|-", actuation_help

    system "git", "init", "-q"
    universalist_help = shell_output("#{bin}/ledger --source universalist --help")
    assert_match "Allocate, resolve, and emit receipts for Universalist plan artifacts", universalist_help
    assert_match "create", universalist_help
    assert_match "latest", universalist_help
    assert_match "path", universalist_help
    assert_match "emit", universalist_help

    actuation_doctor = shell_output(
      "#{bin}/ledger --source actuation --repo #{testpath} --goal tap-goal doctor",
    )
    assert_match '"ok":true', actuation_doctor
    assert_match '"events":0', actuation_doctor
    actuation_path = shell_output(
      "#{bin}/ledger --source actuation --repo #{testpath} --goal tap-goal path",
    )
    assert_match ".ledger/actuation/tap-goal/evidence.jsonl", actuation_path

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

    learning_capture = shell_output(
      "#{bin}/ledger capture --source learnings --status do_more " \
      "--learning \"When tap tests install ledger, use ledger capture --source learnings " \
      "because formula tests catch regressions.\" " \
      "--evidence \"command: brew test ledger writes .ledger/learnings/events.jsonl\" " \
      "--application \"Keep ledger --source learnings covered in the formula test.\" " \
      "--tag homebrew --allow-temp-path",
    )
    learning_id = learning_capture[/appended: id=(lrn-[^ ]+)/, 1]
    refute_nil learning_id
    assert_path_exists testpath/".ledger/learnings/events.jsonl"
    recent = shell_output("#{bin}/ledger recent --source learnings --limit 1")
    assert_match "tap tests install ledger", recent

    learning_full = shell_output(
      "#{bin}/ledger export --source learnings --id #{learning_id} --format full",
    )
    assert_equal learning_full, shell_output(
      "#{bin}/ledger show --source learnings --id #{learning_id}",
    )
    assert_equal learning_full, shell_output(
      "#{bin}/ledger --source learnings show --id #{learning_id}",
    )
  end
end
