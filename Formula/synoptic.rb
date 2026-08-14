class Synoptic < Formula
  desc "Interactive per-file pull-request review workbench"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.0"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/tkersey/skills-zig/releases/download/synoptic-v#{version}/synoptic-v#{version}-darwin-arm64.tar.gz"
    sha256 "837201d1a0a70c6b34bc7cebd289dd344c17f43152e11f8c68fa09db69b5ce65"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/synoptic-v#{version}/synoptic-v#{version}-darwin-x86_64.tar.gz"
    sha256 "0098e972095d6b26b1c4e1a6a4f170736f09396f20234ac646881804e57bd7dd"
  end

  depends_on :macos

  def install
    bin.install "synoptic"
  end

  test do
    assert_equal "synoptic #{version}", shell_output("#{bin}/synoptic --version").strip

    capabilities = JSON.parse(shell_output("#{bin}/synoptic capabilities --format json"))
    synoptic = capabilities.fetch("synopticCapabilities")
    assert_equal version.to_s, synoptic.fetch("version")
    assert_equal "macos", synoptic.fetch("platform")
    assert_equal "synoptic-skill-abi/v1", synoptic.fetch("skillAbi")
    assert_equal "synoptic-ui/v1", synoptic.fetch("uiAbi")
    assert synoptic.fetch("features").values.all?
  end
end
