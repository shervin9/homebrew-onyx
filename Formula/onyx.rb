class Onyx < Formula
  desc "Stable remote shell for unreliable networks (QUIC + SSH fallback)"
  homepage "https://useonyx.dev"
  version "0.2.20"
  license "MIT"

  # The tap currently ships only macOS Apple Silicon. Linux users should
  # use the shell installer at https://useonyx.dev/install.sh until Linux
  # bottles land.
  on_macos do
    on_arm do
      url "https://github.com/shervin9/onyx/releases/download/v0.2.20/onyx-macos-arm64"
      # Replace with the real sha256 from onyx-sha256sums.txt at release time.
      sha256 "84f537ca92abca0546d034d8c4742bf3bee2e068f9fed41b3d000a0942b59a5e"
    end
  end

  resource "onyx-server-linux-x86_64" do
    url "https://github.com/shervin9/onyx/releases/download/v0.2.20/onyx-server-linux-x86_64"
    # Replace with the real sha256 from onyx-sha256sums.txt at release time.
    sha256 "d00d600742cf384f4b871b053b68a27f9a6f26d0cc8a91cbf280995026c0abb9"
  end

  resource "onyx-server-linux-arm64" do
    url "https://github.com/shervin9/onyx/releases/download/v0.2.20/onyx-server-linux-arm64"
    # Replace with the real sha256 from onyx-sha256sums.txt at release time.
    sha256 "409f2919d03a1f4f085126b4eff2d1f6713aad6a92c18499f66e69170fd6de2c"
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
