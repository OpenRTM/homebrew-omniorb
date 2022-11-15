#============================================================
# omniORB formula for HomeBrew
#
# Author: Noriaki Ando <Noriaki.Ando@gmail.com>
# GitHub: https://github.com/OpenRTM/homebrew-omniorb
#
# This is the formula for omniORB with python3.9.
# To use this formula/bottle, switch python3 into python3.9.
# $ brew unlink python3 (unlink python 3.X != 3.9)
# $ brew link python@3.9
#============================================================
class OmniorbSslPy39 < Formula
  desc "IOR and naming service utilities for omniORB with SSL"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.3.0/omniORB-4.3.0.tar.bz2"
  sha256 "976045a2341f4e9a85068b21f4bd928993292933eeecefea372db09e0219eadd"

  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    root_url "https://github.com/OpenRTM/homebrew-omniorb/releases/download/4.3.0/"
    sha256 cellar: :any, arm64_ventura: "99374082384dfba4797db1689580a0f0696b6ca553aad086d50a90c1de057f3f"
    sha256 cellar: :any, monterey: "49188713e8316b327e0905e0d17c5a761322305e085bf11ead330038d564749c"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  def install
    args = %W[
      --prefix=#{prefix}
      PYTHON=#{Formula["python@3.9"].opt_bin}/python3.9
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
