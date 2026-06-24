class ResolveC3 < Formula
  desc "Zig controller for the resolve C3 workflow"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.3.0"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/resolve-c3-v#{version}/resolve-c3-v#{version}-darwin-arm64.tar.gz"
    sha256 "800223ea23b8c5d01552998f7cfc6007c5d7f0015c379a2d2afb9c9563deab04"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/resolve-c3-v#{version}/resolve-c3-v#{version}-linux-x86_64.tar.gz"
    sha256 "8e3c1142d4900720497c099585efbfb063df4f159b2f44cd65a781f09a1eb651"
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
