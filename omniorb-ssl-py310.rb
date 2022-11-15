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
class OmniorbSslPy310 < Formula
  desc "IOR and naming service utilities for omniORB with SSL"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.3.0/omniORB-4.3.0.tar.bz2"
  sha256 "976045a2341f4e9a85068b21f4bd928993292933eeecefea372db09e0219eadd"

  license all_of: ["GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    root_url "https://github.com/OpenRTM/homebrew-omniorb/releases/download/4.3.0/"
    sha256 cellar: :any, arm64_ventura: "381979e013f2a920f5816b9fe6bcf573a496306606b49aa485e5e188191d58ad"
    sha256 cellar: :any, monterey: "c676a7b0a23172aed722e5977dc53e5d6ecb56f950b314fb3deea66d9e8ac1ad"
  end


  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.10"

  def install
    args = %W[
      --prefix=#{prefix}
      PYTHON=#{Formula["python@3.10"].opt_bin}/python3.10
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "-j", "4"
    system "make", "install"
  end

  test do
    system "#{bin}/omniidl", "-bcxx", "-h"
  end
end
