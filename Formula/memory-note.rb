class MemoryNote < Formula
  desc "Safe append-only custom Codex memory-source note writer"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.17"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/memory-note-v#{version}/memory-note-v#{version}-darwin-arm64.tar.gz"
    sha256 "dcc7dbc3b8d065a1386b6847f0ee1ca7a79cb8e73a16faeae08ff4ea825c637c"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/memory-note-v#{version}/memory-note-v#{version}-linux-x86_64.tar.gz"
    sha256 "5e0e105e9539b3ab4b4b15c1176aeaa71f342e86011459434e0a6b52c4582a9e"
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
