class Onyx < Formula
  desc "Stable remote shell for unreliable networks (QUIC + SSH fallback)"
  homepage "https://useonyx.dev"
  version "0.2.21"
  license "MIT"

  # The tap currently ships only macOS Apple Silicon. Linux users should
  # use the shell installer at https://useonyx.dev/install.sh until Linux
  # bottles land.
  on_macos do
    on_arm do
      url "https://github.com/shervin9/onyx/releases/download/v0.2.21/onyx-macos-arm64"
      # Replace with the real sha256 from onyx-sha256sums.txt at release time.
      sha256 "74b43ee5267b1ade2601643b4d8d73a7a3fcb40e6a62f154453f3a3dab7c9217"
    end
  end

  resource "onyx-server-linux-x86_64" do
    url "https://github.com/shervin9/onyx/releases/download/v0.2.21/onyx-server-linux-x86_64"
    # Replace with the real sha256 from onyx-sha256sums.txt at release time.
    sha256 "b5de482effaf8a697ff54388fdb77c9972178f568b2293490b5ab659f9327521"
  end

  resource "onyx-server-linux-arm64" do
    url "https://github.com/shervin9/onyx/releases/download/v0.2.21/onyx-server-linux-arm64"
    # Replace with the real sha256 from onyx-sha256sums.txt at release time.
    sha256 "21f9a060b5890d8b822bb19cb6b761f6d5d284f6eaef080c92892af2749f4f28"
  end

  def install
    bin.install "onyx-macos-arm64" => "onyx"
    resource("onyx-server-linux-x86_64").stage do
      libexec.install "onyx-server-linux-x86_64"
    end
    resource("onyx-server-linux-arm64").stage do
      libexec.install "onyx-server-linux-arm64"
    end
  end

  def caveats
    <<~EOS
      Onyx is the local client. On first connect (`onyx user@host`) it will
      provision `onyx-server` on the remote host over SSH using the packaged
      companion binaries installed in:
        #{libexec}

      Make sure UDP 7272 is reachable to your remote hosts, or pass
      `--no-fallback` to disable the SSH transport fallback.

      Security model (TOFU + fingerprint pinning) is documented at
      https://github.com/shervin9/onyx/blob/main/SECURITY.md
    EOS
  end

  test do
    assert_match "onyx", shell_output("#{bin}/onyx --version")
    assert_path_exists libexec/"onyx-server-linux-x86_64"
    assert_path_exists libexec/"onyx-server-linux-arm64"
  end
end
