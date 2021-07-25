#============================================================
# omniORB formula for HomeBrew
#
# Author: Noriaki Ando <Noriaki.Ando@gmail.com>
# GitHub: https://github.com/OpenRTM/homebrew-omniorb
#============================================================
class OmniorbSsl < Formula
  desc "IOR and naming service utilities for omniORB with SSL"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.2.4/omniORB-4.2.4.tar.bz2"
  sha256 "28c01cd0df76c1e81524ca369dc9e6e75f57dc70f30688c99c67926e4bdc7a6f"

  license any_of: ["GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    root_url "https://github.com/OpenRTM/homebrew-omniorb/releases/download/4.2.4/"
    rebuild 2
    sha256 cellar: :any, catalina: "c378d22e9ada03c3cb1739ed9693d81ae4fbc1ea1d217e0514f59648ff0ecced"
    rebuild 3
    sha256 cellar: :any, arm64_big_sur: "2b7ae8ae2bfcb75a855b4b07fc4b7fe97eca173f7e0252ab28beab9addab36f6"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "python@3.9"

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.2.4/omniORBpy-4.2.4.tar.bz2"
    sha256 "dae8d867559cc934002b756bc01ad7fabbc63f19c2d52f755369989a7a1d27b6"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      PYTHON=#{Formula["python@3.9"].opt_bin}/python3
      CFLAGS=-I#{Formula["python@3.9"].opt_include}
      LDFLAGS=-L#{Formula["python@3.9"].opt_lib}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      OPENSSL_CFLAGS=-I#{Formula["openssl@1.1"].opt_include}
      OEPNSSL_LIBS=-L#{Formula["openssl@1.1"].opt_lib}
      CC=gcc
      CXX=g++
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
