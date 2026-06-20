class ResolveC3 < Formula
  desc "Zig controller for the resolve C3 workflow"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.3"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/resolve-c3-v#{version}/resolve-c3-v#{version}-darwin-arm64.tar.gz"
    sha256 "aaec317070c774bf0e14800d2faa6daefcaed12653515389cd0c8601d18c9879"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/resolve-c3-v#{version}/resolve-c3-v#{version}-linux-x86_64.tar.gz"
    sha256 "c6f83a0f6512480ae4d6417c41572ab3692568405bf684e7fb326102bd4fc2a7"
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
