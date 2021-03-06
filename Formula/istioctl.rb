class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      tag:      "1.6.8",
      revision: "5bf4ade4e4ba40977a1bcacc07740631fb56a099"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "36bf8c191c6131bc77e514ce17ad0bffd21c115461bf55d402cd36edcbfd6dfe" => :catalina
    sha256 "36bf8c191c6131bc77e514ce17ad0bffd21c115461bf55d402cd36edcbfd6dfe" => :mojave
    sha256 "36bf8c191c6131bc77e514ce17ad0bffd21c115461bf55d402cd36edcbfd6dfe" => :high_sierra
    sha256 "dcfe51290a4f23c60b711fa0eeed44d36e243dabf5e8a143e52d8ced1a04a67f" => :x86_64_linux
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    srcpath = buildpath/"src/istio.io/istio"
    outpath = OS.mac? ? srcpath/"out/darwin_amd64" : srcpath/"out/linux_amd64"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "gen-charts", "istioctl", "istioctl.completion"
      bin.install outpath/"istioctl"
      bash_completion.install outpath/"release/istioctl.bash"
      zsh_completion.install outpath/"release/_istioctl"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/istioctl version --remote=false")
  end
end
