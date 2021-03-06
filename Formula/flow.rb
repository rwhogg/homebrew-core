class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.131.0.tar.gz"
  sha256 "3e4e089383426bbd988c78299593019a784ba985a97cfed6efe181e330a894f5"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea5d96e62f4769aa8920e4d8cf78df7a508b7f3183e5143ebd5cd218b37fd18b" => :catalina
    sha256 "17bdca972e0537ec37db29945ce56620468f6062a9184aa1a30d6994d7f89032" => :mojave
    sha256 "5906b9bf8579e1a81eaec7bc5fbf619096e9b36d894aa6356a4c02351e90b6ca" => :high_sierra
    sha256 "9dd67983503f3720783ac5146076e0a1ad2c7e8765c32518251f65285ae1c1a3" => :x86_64_linux
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
