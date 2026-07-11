class Ledger < Formula
  desc "Zig CLI for repo-local ledgers and governance validation"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.4.0"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-darwin-arm64.tar.gz"
    sha256 "f552695f036ce6c5928243017339d4883e185e57fe15c489612643af4665391d"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-linux-x86_64.tar.gz"
    sha256 "67dff815b80b3bdafee2064b73c4229791eedb9357b7317adfc65d1f7773f98c"
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
    assert_match "Durable source-memory and actuation ledger.", help
    assert_match "capture", help
    assert_match "map", help
    assert_match "migrate", help
    assert_match "--source SOURCE", help
    assert_match "recall", help
    assert_match "status", help
    assert_match "export", help

    validate_help = shell_output("#{bin}/ledger validate --help")
    assert_match "plan-source-contract", validate_help
    assert_match "policy-synthesis-receipt", validate_help
    assert_match "review-fold", validate_help
    assert_match "never reads or writes .ledger", validate_help

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

    system bin/"ledger", "init"
    assert_path_exists testpath/".ledger/negative-ledger/events.jsonl"
    assert_match "\"ok\":true", shell_output("#{bin}/ledger doctor")

    capture_help = shell_output("#{bin}/ledger capture --source learnings --help 2>&1")
    assert_match "Append a structured learning event to repo-local .ledger/learnings/events.jsonl.", capture_help
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
