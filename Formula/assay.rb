class Assay < Formula
  desc "Passive assessment kernel for contract, subject, and evidence documents"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.0"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/assay-v#{version}/assay-v#{version}-darwin-arm64.tar.gz"
    sha256 "9c08bd285d3634e5255f03991f8431a52326c2c2e59dfa540f45042e9d55a0f3"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/assay-v#{version}/assay-v#{version}-linux-x86_64.tar.gz"
    sha256 "ecf500b08cebaccf3c8921cceec80e31f9f51cdab9aaf51ad40b410771489899"
  end

  on_macos do
    depends_on arch: :arm64
    depends_on macos: :sequoia
  end

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    bin.install "assay"
  end

  test do
    require "digest"
    require "json"

    assert_equal version.to_s, shell_output("#{bin}/assay --version").strip
    capabilities = JSON.parse(shell_output("#{bin}/assay capabilities"))
    assert_equal "assay-capabilities/v1", capabilities.fetch("schema")
    assert_equal version.to_s, capabilities.fetch("version")
    refute capabilities.fetch("boundary").fetch("authority_granted")

    root = testpath/"subject"
    root.mkpath
    (root/"candidate.mjs").write "export const candidate = 1;\n"
    (root/"context.json").write "{\"task\":\"homebrew-test\"}\n"
    (root/"observe.mjs").write "export const observe = true;\n"
    artifacts = [["candidate", "target", "candidate.mjs"],
                 ["context", "context", "context.json"],
                 ["observer", "evaluator", "observe.mjs"]].map do |id, role, path|
      bytes = (root/path).binread
      { id: id, role: role, path: path, sha256: Digest::SHA256.hexdigest(bytes), size_bytes: bytes.bytesize }
    end
    (testpath/"subject.json").write JSON.generate(
      schema: "assay-subject/v1", id: "homebrew", context_artifact: "context", artifacts: artifacts,
    )
    (testpath/"contract.json").write JSON.generate(
      schema: "assay-contract/v1", id: "homebrew/v1", claim_kind: "artifact", scope: "One case.",
      context_sha256: artifacts[1][:sha256],
      evaluators: [{ id: "observer/v1", artifact_id: "observer", sha256: artifacts[2][:sha256], method: "M." }],
      obligations: [{
        id: "null-case", required: true, statement: "Null survives.", scope: "timeout=null",
        basis: "empirical", evaluator_id: "observer/v1",
        decisive_when: { supported: "complete_run", refuted: "observation" },
        check: { kind: "scalar_equal", expected: nil }
      }]
    )
    (testpath/"evidence.json").write JSON.generate(
      schema:          "assay-evidence/v1",
      contract_sha256: Digest::SHA256.hexdigest((testpath/"contract.json").binread),
      subject_sha256:  Digest::SHA256.hexdigest((testpath/"subject.json").binread),
      context_sha256:  artifacts[1][:sha256],
      runs:            [{ id: "run", evaluator_id: "observer/v1", evaluator_sha256: artifacts[2][:sha256],
               outcome: "interrupted", reason: "Interrupted after recording." }],
      records:         [{ obligation_id: "null-case", run_id: "run", status: "observed",
                  observation: { kind: "scalar", value: 7 }, artifact_ids: [] }],
      artifacts:       [],
    )
    receipt = shell_output(
      "#{bin}/assay assess --contract #{testpath}/contract.json --subject #{testpath}/subject.json " \
      "--evidence #{testpath}/evidence.json --subject-root #{root.realpath}", 1
    )
    assessment = JSON.parse(receipt)
    assert_equal "refuted", assessment.fetch("derivation").fetch("overall")
    assert_equal "matched_manifest_during_this_invocation",
                 assessment.fetch("verification").fetch("subject_bytes")
    (testpath/"receipt.json").write receipt
    explanation = JSON.parse(shell_output("#{bin}/assay explain --assessment #{testpath}/receipt.json"))
    assert_equal "verified", explanation.fetch("receipt_consistency")
    assert_equal "scalar_unequal", explanation.fetch("explanations").first.fetch("reason_code")
  end
end
