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
  license "GPL-2.1"

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "python@3.9"

  bottle do
    root_url "https://github.com/OpenRTM/homebrew-omniorb/releases/download/4.2.4/"
    cellar :any
    rebuild 1
    sha256 "90bf3cbd54b14f5cc71e6f269d27a1c40a21bfd7cab39f7895f73aa212666b71" => :catalina
  end

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.2.4/omniORBpy-4.2.4.tar.bz2"
    sha256 "dae8d867559cc934002b756bc01ad7fabbc63f19c2d52f755369989a7a1d27b6"
  end

  def install
    args = %W[
        OPENSSL_CFLAGS=-I/usr/local/opt/openssl/include
        OEPNSSL_LIBS=-L/usr/local/opt/openssl/lib
        CC=gcc-4.9
        CXX=g++-4.9
        PYTHON=/usr/local/bin/python3
    ]
    system "./configure", "--prefix=#{prefix}", "--with-openssl=/usr/local/opt/openssl", *args
    system "make"
    system "make", "install"

    resource("bindings").stage do
      system "./configure", "--prefix=#{prefix}", "--with-openssl=/usr/local/opt/openssl", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/omniidl", "-bcxx", "-h"
  end
end

