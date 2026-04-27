class Onyx < Formula
  desc "Stable remote shell for unreliable networks (QUIC + SSH fallback)"
  homepage "https://useonyx.dev"
  version "0.2.17"
  license "MIT"

  # The tap currently ships only macOS Apple Silicon. Linux users should
  # use the shell installer at https://useonyx.dev/install.sh until Linux
  # bottles land.
  on_macos do
    on_arm do
      url "https://github.com/shervin9/onyx/releases/download/v0.2.17/onyx-macos-arm64"
      # Replace with the real sha256 from onyx-sha256sums.txt at release time.
      sha256 "e127a56fda923ff0884785eb0adca650ab4ec08a9e9ec3b404f6dd470ca1477b"
    end
  end

  resource "onyx-server-linux-x86_64" do
    url "https://github.com/shervin9/onyx/releases/download/v0.2.17/onyx-server-linux-x86_64"
    # Replace with the real sha256 from onyx-sha256sums.txt at release time.
    sha256 "7661e6e371539ae6b78d9669336835ba252afcbd548d69a3fb961b5076049043"
  end

  resource "onyx-server-linux-arm64" do
    url "https://github.com/shervin9/onyx/releases/download/v0.2.17/onyx-server-linux-arm64"
    # Replace with the real sha256 from onyx-sha256sums.txt at release time.
    sha256 "810405c1778c266dced47db1bd20dd54280d7fc1fcc729efcb6340df8e3bd53d"
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
