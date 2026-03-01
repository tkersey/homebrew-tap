class Cas < Formula
  desc "Zig CLI helpers for Codex app-server orchestration"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.10"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/cas-v#{version}/cas-v#{version}-darwin-arm64.tar.gz"
    sha256 "43a449f723c4be86bd0b26cebee990f4bf0161c01321569bee242dcd2fbf5002"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/cas-v#{version}/cas-v#{version}-linux-x86_64.tar.gz"
    sha256 "1c43998462e5d0c9bfc3764810e345f7472b5ce03d773184f1bd278ca762e314"
  end

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on arch: :x86_64
  end

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
