#============================================================
# omniORB formula for HomeBrew
#
# Author: Noriaki Ando <Noriaki.Ando@gmail.com>
# GitHub: https://github.com/OpenRTM/homebrew-omniorb
#
# This is the formula for omniORBpy on python3.8 (not 3.9).
# To use this formula/bottle, switch python 3.9 to python 3.8.
# $ brew unlink python3 (unlink python 3.9)
# $ brew link python@3.8
#============================================================
class OmniorbSslPy38 < Formula
  desc "IOR and naming service utilities for omniORB with SSL"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.2.4/omniORB-4.2.4.tar.bz2"
  sha256 "28c01cd0df76c1e81524ca369dc9e6e75f57dc70f30688c99c67926e4bdc7a6f"

  license all_of: ["GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    root_url "https://github.com/OpenRTM/homebrew-omniorb/releases/download/4.2.4/"
    rebuild 1
    sha256 cellar: :any, catalina: "662c1a51316087fca68e4be987fc84b1ac6dc95504a4b95368bb5f66f0a02150"
    rebuild 2
    sha256 cellar: :any, arm64_big_sur: "c53dbfacd573750f581ae7c8aded9f38daf39f1c142be2e576d9104944765e32"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.8"

  patch do
    url "https://raw.githubusercontent.com/OpenRTM/homebrew-omniorb/master/Patches/omniorb_2.4.2.patch"
    sha256 "bae401aa5980b1bb87fec7424c5ad977f13ced6ac04bb84aca2a546b9d82667f"
  end

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.2.4/omniORBpy-4.2.4.tar.bz2"
    sha256 "dae8d867559cc934002b756bc01ad7fabbc63f19c2d52f755369989a7a1d27b6"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      PYTHON=#{Formula["python@3.8"].opt_bin}/python3
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "-j", "4"
    system "make", "install"

    resource("bindings").stage do
      system "./configure", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/omniidl", "-bcxx", "-h"
  end
end
