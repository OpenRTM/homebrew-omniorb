#============================================================
# omniORB formula for HomeBrew
#
# Author: Noriaki Ando <Noriaki.Ando@gmail.com>
# GitHub: https://github.com/OpenRTM/homebrew-omniorb
#
# This is the formula for omniORB with python3.10.
# To use this formula/bottle, switch python3 into python3.10.
# $ brew unlink python3 (unlink python 3.X != 3.10)
# $ brew link python@3.10
#============================================================
class OmniorbSsl < Formula
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
    rebuild 5
    sha256 cellar: :any, catalina: "792be18059ed68b0c8ef5df0855a682681bfd4a6ce384180478fe51ae6a94cd9"
    rebuild 4
    sha256 cellar: :any, big_sur: "9e7c4d72a655775796f058607ade981bc2e0d799b5e089be434142cb7fb72c7d"
    rebuild 5
    sha256 cellar: :any, arm64_big_sur: "45002184fc3f53818e34af4f5968086ff6db6aa70fa7ffe4c1eccfa5ffe45eaa"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.10"

  patch do
    url "https://raw.githubusercontent.com/OpenRTM/homebrew-omniorb/master/Patches/omniorb_2.4.2.patch"
    sha256 "243c5984e88754ae903e9e9819c26e052532134b64f47e9243f1f9d26ffffdbd"
  end

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.2.4/omniORBpy-4.2.4.tar.bz2"
    sha256 "dae8d867559cc934002b756bc01ad7fabbc63f19c2d52f755369989a7a1d27b6"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      PYTHON=#{Formula["python@3.10"].opt_bin}/python3
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
