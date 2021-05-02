#============================================================
# omniORBpy formula for HomeBrew
#
# Author: Noriaki Ando <Noriaki.Ando@gmail.com>
# GitHub: https://github.com/OpenRTM/homebrew-omniorb
#============================================================
class Omniorbpy < Formula
  desc "IOR and naming service utilities for omniORBpy with SSL"
  homepage "https://omniorb.sourceforge.io/"
  url "https://versaweb.dl.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.2.4/omniORBpy-4.2.4.tar.bz2"
  sha256 "dae8d867559cc934002b756bc01ad7fabbc63f19c2d52f755369989a7a1d27b6"
  license "GPL-2.1"

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORBpy[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    root_url "https://github.com/OpenRTM/homebrew-omniorb/releases/download/4.2.4/"
    rebuild 2
    sha256 cellar: :any, catalina: "30e690981419c1cd38f45772d10fca72b28eff9d593f4a412abdaa208d10c197"
  end

  depends_on "pkg-config" => :build
  depends_on "omniorb-ssl"
  depends_on "python@3.9"

  def install
    args = %w[
      OPENSSL_CFLAGS=-I/usr/local/opt/openssl/include
      OEPNSSL_LIBS=-L/usr/local/opt/openssl/lib
      CFLAGS=-I/usr/local/opt/python@3.9/include
      LDFLAGS=-L/usr/local/opt/python@3.9/lib
      CC=gcc-4.9
      CXX=g++-4.9
      PYTHON=/usr/local/opt/python@3.9/bin/python3.9
    ]
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-omniorb=/usr/local",
                          "--with-openssl=/usr/local/opt/openssl",
                          *args
    system "make", "-j", "4"
    system "make", "install"
  end

  test do
    system "#{bin}/omniidl", "-bpython", "-h"
  end
end
