class Cas < Formula
  desc "Zig CLI helpers for Codex app-server orchestration"
  homepage "https://github.com/tkersey/cas"
  url "https://github.com/tkersey/cas.git",
      using:    :git,
      revision: "e96693d260abbe7fbceb90b5e88271e63c07a3c5"
  version "e96693d"
  head "https://github.com/tkersey/cas.git", branch: "main"

  depends_on "zig" => :build
  depends_on "node"

  def install
    bin.mkpath
    system "zig", "build-exe", "scripts/cas_smoke_check.zig",
                  "-O", "ReleaseFast",
                  "--name", "cas_smoke_check",
                  "-femit-bin=#{bin}/cas_smoke_check"
    system "zig", "build-exe", "scripts/cas_instance_runner.zig",
                  "-O", "ReleaseFast",
                  "--name", "cas_instance_runner",
                  "-femit-bin=#{bin}/cas_instance_runner"
  end

  test do
    assert_match "cas_smoke_check.zig", shell_output("#{bin}/cas_smoke_check --help 2>&1")
    assert_match "cas_instance_runner.zig", shell_output("#{bin}/cas_instance_runner --help 2>&1")
  end
end
