class St < Formula
  desc "Zig CLI for dependency-aware durable task plans"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.2"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-darwin-arm64.tar.gz"
    sha256 "9d685f783d8ba3c3ae30a005d21267b2369aac0cba31716572fe1f7e5ff0ff4e"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-linux-x86_64.tar.gz"
    sha256 "ced27fe38dc9f95d5ff768570e4e24434a90aa7837a2fc6398bce762cf0c73f4"
  end

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    bin.install "st"
  end

  test do
    assert_match "st.zig", shell_output("#{bin}/st --help")
  end
end
