class Onyx < Formula
  desc "Stable remote shell for unreliable networks (QUIC + SSH fallback)"
  homepage "https://useonyx.dev"
  version "0.2.13"
  license "MIT"

  # The tap currently ships only macOS Apple Silicon. Linux users should
  # use the shell installer at https://useonyx.dev/install.sh until Linux
  # bottles land.
  on_macos do
    on_arm do
      url "https://github.com/shervin9/onyx/releases/download/v#{version}/onyx-macos-arm64"
      # Replace with the real sha256 from onyx-sha256sums.txt at release time.
      sha256 "d9d955e7971fcca2615ba56f1f62e0a99be85dcd87fac1751e17727737259653"
    end
  end

  resource "onyx-server-linux-x86_64" do
    url "https://github.com/shervin9/onyx/releases/download/v#{version}/onyx-server-linux-x86_64"
    # Replace with the real sha256 from onyx-sha256sums.txt at release time.
    sha256 "a11c0ff8676b2c03d160ffe2965dfa982328ff9e9df035012403453f434ae10e"
  end

  resource "onyx-server-linux-arm64" do
    url "https://github.com/shervin9/onyx/releases/download/v#{version}/onyx-server-linux-arm64"
    # Replace with the real sha256 from onyx-sha256sums.txt at release time.
    sha256 "70b9b1d0b51d512868fdf1876389d71865afeee2c530749b74d4e3ea97d3e000"
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
