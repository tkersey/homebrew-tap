class MemoryNote < Formula
  desc "Safe append-only custom Codex memory-source note writer"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.10"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/memory-note-v#{version}/memory-note-v#{version}-darwin-arm64.tar.gz"
    sha256 "f10a3a970d915dfd12ee58e42cca16866780502f30083bd26a614fc97b0fc529"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/memory-note-v#{version}/memory-note-v#{version}-linux-x86_64.tar.gz"
    sha256 "2e4dccfd0c959a79919b8cdb5128d432383822289363daab2453e7504be57d59"
  end

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    bin.install "memory-note"
  end

  test do
    version_output = shell_output("#{bin}/memory-note --version")
    assert_match version.to_s, version_output

    help = shell_output("#{bin}/memory-note --help")
    assert_match "Safe append-only custom memory-source note writer.", help
    assert_match "append", help
    assert_match "doctor", help
  end
end
