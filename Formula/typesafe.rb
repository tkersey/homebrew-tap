class Typesafe < Formula
  desc "Document review triage with the TypeSafe API"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.0"

  if OS.mac?
    depends_on arch: :arm64
    depends_on macos: :sequoia
    url "https://github.com/tkersey/skills-zig/releases/download/typesafe-v#{version}/typesafe-v#{version}-darwin-arm64.tar.gz"
    sha256 "84fe2c7f0999220b8faf6c135226c7c65358b90eec729998f11780e9d41189d0"
  else
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/typesafe-v#{version}/typesafe-v#{version}-linux-x86_64.tar.gz"
    sha256 "7c713c774d2a7dac1ea4b06fff28309e47bfaa43b2d39fdf48ef2c9bbebbed3e"
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
