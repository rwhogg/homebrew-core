class Virgil < Formula
  desc "CLI tool to manage your Virgil account and applications"
  homepage "https://github.com/VirgilSecurity/virgil-cli"
  url "https://github.com/VirgilSecurity/virgil-cli.git",
     tag:      "v5.2.9",
     revision: "604e4339d100c9cd133f4730ba0efbd599321ecb"
  license "BSD-3-Clause"
  head "https://github.com/VirgilSecurity/virgil-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "841082fa11c796ba0045d4ced3cead342fba308b049f07db4a0bd3309acc08c7" => :catalina
    sha256 "d115016c280fbfe9381b56d0e08b9a69b4dc62042bb73424c243ea3f73280cd9" => :mojave
    sha256 "f7b6c179875ab30f849e3cbba53c8aeed7af4c569b69d4b112c2d749e5c38ea4" => :high_sierra
    sha256 "818fae592fbf7584c0d9db6bb16daba6355ba6a966205147c1e8672dd31476d8" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "virgil"
  end

  test do
    result = shell_output "#{bin}/virgil purekit keygen"
    assert_match /SK.1./, result
  end
end
