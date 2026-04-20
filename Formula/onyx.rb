class Onyx < Formula
  desc "Stable remote shell for unreliable networks (QUIC + SSH fallback)"
  homepage "https://useonyx.dev"
  version "0.2.7"
  license "MIT"

  # The tap currently ships only macOS Apple Silicon. Linux users should
  # use the shell installer at https://useonyx.dev/install.sh until Linux
  # bottles land.
  on_macos do
    on_arm do
      url "https://github.com/shervin9/onyx/releases/download/v#{version}/onyx-macos-arm64"
      sha256 "f27fab332a63c78d1d9bc2e18edafe824f1fc3ee297c6d6a40bb6118dcf4921f"
    end
  end

  def install
    bin.install "onyx-macos-arm64" => "onyx"
  end

  def caveats
    <<~EOS
      Onyx is the local client. On first connect (`onyx user@host`) it will
      provision `onyx-server` on the remote host over SSH.

      Make sure UDP 7272 is reachable to your remote hosts, or pass
      `--no-fallback` to disable the SSH transport fallback.

      Security model (TOFU + fingerprint pinning) is documented at
      https://github.com/shervin9/onyx/blob/main/SECURITY.md
    EOS
  end

  test do
    assert_match "onyx", shell_output("#{bin}/onyx --version")
  end
end
