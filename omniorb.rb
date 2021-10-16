class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.2.4/omniORB-4.2.4.tar.bz2"
  sha256 "28c01cd0df76c1e81524ca369dc9e6e75f57dc70f30688c99c67926e4bdc7a6f"
  license all_of: ["GPL-2.0-only", "LGPL-2.1-only"]
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "af99975268bf9395f8aa6b00521f5dde8e41434a2bc19ee45aa9abba372bad75"
    sha256 cellar: :any,                 big_sur:       "625e7bb2ca70ac3a1e52d3cc8ef9b1614b498eb24b00cdc78736dcea7c40c9cf"
    sha256 cellar: :any,                 catalina:      "e25345b167440b0a34a7399a267b487d0e8ffb24ccd5f9c2cbbf874b8a38e729"
    sha256 cellar: :any,                 mojave:        "5c8d7b0adeca7c70af83d5b13acc4629e8329104562deaea9f329bf7345ad272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87fd171d45ee3efaa71a07106b42a1261f1d6ec247fea2331a626137718d395c"
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
    system "#{bin}/omniidl", "-h"
  end
end
