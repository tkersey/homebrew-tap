class Cas < Formula
  desc "Zig CLI helpers for Codex app-server orchestration"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.7"

  on_macos do
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/cas-v#{version}/cas-v#{version}-darwin-arm64.tar.gz"
    sha256 "2df3aef076b3f86b4d772f1e8bb08bf2bc9f465a8ef832e48d05351a9bc7617a"
  end

  on_linux do
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/cas-v#{version}/cas-v#{version}-linux-x86_64.tar.gz"
    sha256 "a129cd4615197f7b8941a644c1b40c4be85cd78159dd15505c9db2613ee5ff0f"
  end

  depends_on "node"

  def install
    bin.install "cas"
    bin.install "cas-smoke-check" => "cas_smoke_check"
    bin.install "cas-instance-runner" => "cas_instance_runner"
  end

  test do
    cas_help = shell_output("#{bin}/cas --help 2>&1")
    assert_match "cas.zig", cas_help
    assert_match "Subcommands:", cas_help

    smoke_help = shell_output("#{bin}/cas_smoke_check --help 2>&1")
    assert_match "cas_smoke_check.zig", smoke_help
    assert_match "Usage:", smoke_help

    runner_help = shell_output("#{bin}/cas_instance_runner --help 2>&1")
    assert_match "cas_instance_runner.zig", runner_help
    assert_match "Usage:", runner_help

    dispatch_help = shell_output("#{bin}/cas smoke_check --help 2>&1")
    assert_match "cas_smoke_check.zig", dispatch_help
  end
end
