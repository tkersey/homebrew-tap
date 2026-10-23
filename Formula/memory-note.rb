class MemoryNote < Formula
  desc "Safe append-only custom Codex memory-source note writer"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.3.4"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/memory-note-v#{version}/memory-note-v#{version}-darwin-arm64.tar.gz"
    sha256 "7e0dcb5fbf706b68da9204e0280aec537ad95e24fa5e423a903450b72be9072d"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/memory-note-v#{version}/memory-note-v#{version}-linux-x86_64.tar.gz"
    sha256 "53d8ddd0a05a0a795d118445995bf50f8c7d28b0d45e1361db65654726d15055"
  end

  on_macos do
    depends_on arch: :arm64
    depends_on macos: :sequoia
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
