class Seq < Formula
  desc "Native observation compiler for agent session evidence"
  homepage "https://github.com/tkersey/skills-zig"
  version "1.1.1"
  license "MIT"

  if OS.mac?
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-darwin-arm64.tar.gz"
    sha256 "9f166293bea62e0a9a775480a87c53f5fcad6b6573dad3893b2a73b9d1f63ceb"
  else
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-linux-x86_64.tar.gz"
    sha256 "d8739f66b2790aff961a510695728cae4c028fd9e545bb4903a8f37e6f552789"
  end

  def install
    bin.install "seq"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/seq --version").strip

    capabilities = JSON.parse(shell_output("#{bin}/seq capabilities --format json"))
    assert_equal "seq-capabilities/v1", capabilities.fetch("schema")
    assert_includes capabilities.fetch("observation_abis"), "seq-observation-abi/v1"
    assert_includes capabilities.fetch("source_adapters"), "immutable-relation-json/v1"

    (testpath/"observation.json").write <<~JSON
      {
        "schema":"seq-observation-definition/v1",
        "id":"tap/active-facts",
        "requires":{"abi":"seq-observation-abi/v1","operators":["filter","project"]},
        "parameters":{},"selectors":[],"relations":[],
        "inputs":[{"name":"facts","schema":"tap-facts/v1","fields":[
          {"name":"id","type":"string","nullable":false},
          {"name":"active","type":"boolean","nullable":false}
        ],"max_rows":2,"max_bytes":1024}],
        "pipeline":[
          {"op":"filter","input":"facts","as":"matched","where":[{"field":"active","op":"exact","value":true}]},
          {"op":"project","input":"matched","as":"rows","fields":["id"]}
        ],
        "projections":{"rows":{"relation":"rows","schema":"tap-active/v1","fields":["id"],"renderers":["json"]}},
        "bounds":{"max_rows":2,"max_output_bytes":1024,"max_fold_states":1,"max_input_bytes":1024}
      }
    JSON
    (testpath/"facts.json").write <<~JSON
      {"schema":"tap-facts/v1","rows":[{"id":"first","active":false},{"id":"second","active":true}]}
    JSON

    check_output = shell_output(
      "#{bin}/seq definition check --definition #{testpath}/observation.json --format json",
    )
    check = JSON.parse(check_output)
    assert check.fetch("valid")
    assert check.fetch("passive")
    refute check.fetch("authority_granted")

    result_output = shell_output(
      "#{bin}/seq observe --definition #{testpath}/observation.json " \
      "--input facts=#{testpath}/facts.json --projection rows --format json",
    )
    result = JSON.parse(result_output)
    assert_equal "seq-observation-result/v1", result.fetch("schema")
    assert_equal [{ "id" => "second" }], result.dig("data", "rows")
    refute result.fetch("authority_granted")
  end
end
