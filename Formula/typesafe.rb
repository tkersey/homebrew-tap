class Typesafe < Formula
  desc "Document review triage with the TypeSafe API"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.0"

  if OS.mac?
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/typesafe-v#{version}/typesafe-v#{version}-darwin-arm64.tar.gz"
    sha256 "3a1e7bafb6ebad461d0adc2e73aae07e9bb5ab1d907d8258677dc3f2e209a8f2"
  else
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/typesafe-v#{version}/typesafe-v#{version}-linux-x86_64.tar.gz"
    sha256 "2389ff8632e1d1249ed7bb288863db97e9ff0e290fa1328b9fc362d32c4da2e2"
  end

  def install
    bin.install "typesafe"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/typesafe --version").strip
    assert_match "Evaluate UTF-8 text or Markdown documents with TypeSafe.",
                 shell_output("#{bin}/typesafe --help")
  end
end
