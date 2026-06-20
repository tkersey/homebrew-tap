class ResolveC3 < Formula
  desc "Zig controller for the resolve C3 workflow"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.2"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/resolve-c3-v#{version}/resolve-c3-v#{version}-darwin-arm64.tar.gz"
    sha256 "8d4dcd2e1918feb03807152e6d15f7af07335a5e040d52b8cf2da4dddf5a22da"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/resolve-c3-v#{version}/resolve-c3-v#{version}-linux-x86_64.tar.gz"
    sha256 "7c5fd17e732c7e002c8e27672bd7a8600b3727452ca78473f10421ad98b0453a"
  end

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    bin.install "resolve-c3"
  end

  test do
    version_output = shell_output("#{bin}/resolve-c3 --version")
    assert_match version.to_s, version_output

    help = shell_output("#{bin}/resolve-c3 --help")
    assert_match "Zig controller for the $resolve C3 workflow.", help
    assert_match "migrate-legacy", help
    assert_match "mrpc-gate", help

    system "git", "init"
    system bin/"resolve-c3", "init"
    assert_path_exists testpath/".ledger/c3/state.json"
    assert_match ".ledger/c3", shell_output("#{bin}/resolve-c3 paths")
  end
end
