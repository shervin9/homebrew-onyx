class Onyx < Formula
  desc "Stable remote shell for unreliable networks (QUIC + SSH fallback)"
  homepage "https://useonyx.dev"
  version "0.2.15"
  license "MIT"

  # The tap currently ships only macOS Apple Silicon. Linux users should
  # use the shell installer at https://useonyx.dev/install.sh until Linux
  # bottles land.
  on_macos do
    on_arm do
      url "https://github.com/shervin9/onyx/releases/download/v0.2.15/onyx-macos-arm64"
      # Replace with the real sha256 from onyx-sha256sums.txt at release time.
      sha256 "18c9aa0e07a3574e90c76f8e2623467e7839d095fa7d94058c3248d6cadd6636"
    end
  end

  resource "onyx-server-linux-x86_64" do
    url "https://github.com/shervin9/onyx/releases/download/v0.2.15/onyx-server-linux-x86_64"
    # Replace with the real sha256 from onyx-sha256sums.txt at release time.
    sha256 "34d0145588e69d354a99418737ba170b97813ca9d3d88a2a0bc17e879e49d811"
  end

  resource "onyx-server-linux-arm64" do
    url "https://github.com/shervin9/onyx/releases/download/v0.2.15/onyx-server-linux-arm64"
    # Replace with the real sha256 from onyx-sha256sums.txt at release time.
    sha256 "8968b77bf1835f34166d40e192017a7d2a59fed58b3aa98bb9253627cb5ea3db"
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
