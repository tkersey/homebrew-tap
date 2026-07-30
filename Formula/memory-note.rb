class MemoryNote < Formula
  desc "Safe append-only custom Codex memory-source note writer"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.13"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/memory-note-v#{version}/memory-note-v#{version}-darwin-arm64.tar.gz"
    sha256 "7398b6f122145f2243ba3f546140d7609a9823891b3e84cf61138fcaef557895"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/memory-note-v#{version}/memory-note-v#{version}-linux-x86_64.tar.gz"
    sha256 "eb625b9de9c17b95b2f6ec25cf27b3673534c78daba95f0dc4407afddf49289b"
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
