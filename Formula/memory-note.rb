class MemoryNote < Formula
  desc "Safe append-only custom Codex memory-source note writer"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.3.2"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/memory-note-v#{version}/memory-note-v#{version}-darwin-arm64.tar.gz"
    sha256 "059380b1fd2a2effbee03d24b1f87e00487df94dd22f4d1aea8c3b49659db492"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/memory-note-v#{version}/memory-note-v#{version}-linux-x86_64.tar.gz"
    sha256 "9e69747666237d8ebbc5abcb31d98624c22d28abb2bea10dc712c1f92d514490"
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
