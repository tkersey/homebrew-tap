class Ledger < Formula
  desc "Native artifact validation and durable protocol runtime"
  homepage "https://github.com/tkersey/skills-zig"
  version "1.0.1"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-darwin-arm64.tar.gz"
    sha256 "4d109e8e51b442dcf207d9d4f936d0e62a46a10b92731250a3c2992dfd3e0e3e"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-linux-x86_64.tar.gz"
    sha256 "7e6cdd8471f476f23a3de68290f9bc54f6efb96b09dc609798eded71f25f5444"
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
    assert_equal version.to_s, shell_output("#{bin}/ledger --version").strip

    capabilities = JSON.parse(shell_output("#{bin}/ledger capabilities --format json"))
    assert_equal "ledger-capabilities/v1", capabilities.fetch("schema")
    assert_includes capabilities.fetch("artifact_abis"), "ledger-artifact-abi/v1"
    assert_includes capabilities.fetch("storage_adapters"), "event-log"

    (testpath/"definition.json").write <<~JSON
      {
        "schema":"ledger-artifact-definition/v1",
        "id":"tap/record","owner":"tap",
        "requires":{"abi":"ledger-artifact-abi/v1","operators":["enum","exact-object","scalar-type"]},
        "parameters":{},
        "inputs":{"record":{"codec":"json","max_bytes":1024}},
        "canonicalization":{},
        "shape":{"documents":{"record":{"object":"exact","fields":{
          "id":{"scalar":"string"},"status":{"enum":["open","closed"]}
        }}}},
        "constraints":{"laws":[]},"identity":{},
        "storage":{"kind":"pure"},"operations":{},"projections":{},
        "bounds":{"max_input_bytes":1024,"max_store_bytes":1024,"max_records":1,
          "max_output_bytes":1024,"max_diagnostics":8,"max_reducer_states":1}
      }
    JSON
    (testpath/"record.json").write %Q({"id":"record-1","status":"open"}\n)

    check_output = shell_output(
      "#{bin}/ledger definition check --definition #{testpath}/definition.json --format json",
    )
    check = JSON.parse(check_output)
    assert check.fetch("valid")
    assert check.fetch("passive")
    refute check.fetch("authority_granted")

    result_output = shell_output(
      "#{bin}/ledger validate --definition #{testpath}/definition.json " \
      "--input record=#{testpath}/record.json --format json",
    )
    result = JSON.parse(result_output)
    assert_equal "ledger-validation-result/v1", result.fetch("schema")
    assert result.fetch("valid")
    refute result.fetch("authority_granted")
    refute result.fetch("storage_mutated")
  end
end
