class ResolveC3 < Formula
  desc "Zig controller for the resolve C3 workflow"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.0"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/resolve-c3-v#{version}/resolve-c3-v#{version}-darwin-arm64.tar.gz"
    sha256 "4c6f7641de919900ed6fcdda76048b7927fb2e4a2bfe9a1ea3771bf61243e149"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/resolve-c3-v#{version}/resolve-c3-v#{version}-linux-x86_64.tar.gz"
    sha256 "37e4acea0a7a5941732da6e96f326f2957beb4a6407cec05623eda20ca1c08ba"
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
