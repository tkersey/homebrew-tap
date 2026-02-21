class Cas < Formula
  desc "Zig CLI helpers for Codex app-server orchestration"
  homepage "https://github.com/tkersey/skills-zig"
  url "https://github.com/tkersey/skills-zig.git",
      using:    :git,
      tag:      "cas-v0.2.2",
      revision: "aea09894272b581a69e1c3dfe3d26585c2d2dc57"
  head "https://github.com/tkersey/skills-zig.git", branch: "main"

  depends_on "zig" => :build
  depends_on "node"

  def install
    system "zig", "build", "build-cas", "-Doptimize=ReleaseFast"
    bin.install "zig-out/bin/cas", "zig-out/bin/cas_smoke_check", "zig-out/bin/cas_instance_runner"
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
