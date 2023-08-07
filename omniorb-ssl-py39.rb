#============================================================
# omniORB formula for HomeBrew
#
# Author: Noriaki Ando <Noriaki.Ando@gmail.com>
# GitHub: https://github.com/OpenRTM/homebrew-omniorb
#
# This is the formula for omniORBpy on python3.9
# To use this formula/bottle, switch python 3.x to python 3.9.
# $ brew unlink python3.x (unlink current python)
# $ brew link python@3.9 omniorb-ssl-y310
#============================================================
class OmniorbSslPy39 < Formula
  desc "IOR and naming service utilities for omniORB with SSL"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.3.2/omniORB-4.3.2.tar.bz2"
  sha256 "1c745330d01904afd7a1ed0a5896b9a6e53ac1a4b864a48503b93c7eecbf1fa8"

  license all_of: ["GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    root_url "https://github.com/OpenRTM/homebrew-omniorb/releases/download/4.3.2/"
    rebuild 1
    sha256 cellar: :any, ventura: "32f63951460bcffa7cefa297bc9522ec9b39fc1c7419e3ad58c8bff831b8132e"
    rebuild 1
    sha256 cellar: :any, arm64_sonoma: "cc5919d4bb4a6c3e6d4066002276ead2d30f58f070bd8095e399b2e8f5674c72"
    rebuild 1
    sha256 cellar: :any, arm64_ventura: "cc5919d4bb4a6c3e6d4066002276ead2d30f58f070bd8095e399b2e8f5674c72"
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "cc5919d4bb4a6c3e6d4066002276ead2d30f58f070bd8095e399b2e8f5674c72"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "python@3.9"
  uses_from_macos "zlib"

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.3.2/omniORBpy-4.3.2.tar.bz2"
    sha256 "cb5717d412a101baf430f598cac7d69231884dae4372d8e2adf3ddeebc5f7ebb"
  end

  def install
    odie "bindings resource needs to be updated" if version != resource("bindings").version

    ENV["PYTHON"] = python3 = which("python3.9")
    xy = Language::Python.major_minor_version python3
    inreplace "configure",
              /am_cv_python_version=`.*`/,
              "am_cv_python_version='#{xy}'"
    args = ["--with-openssl"]
    args << "--enable-cfnetwork" if OS.mac?
    system "./configure", *args, *std_configure_args
    system "make", "-j", "4"
    system "make", "install"

    resource("bindings").stage do
      inreplace "configure",
                /am_cv_python_version=`.*`/,
                "am_cv_python_version='#{xy}'"
      system "./configure", *std_configure_args
      ENV.deparallelize # omnipy.cc:392:44: error: use of undeclared identifier 'OMNIORBPY_DIST_DATE'
      system "make", "install"
    end
  end

  test do
    system "#{bin}/omniidl", "-h"
    system "#{bin}/omniidl", "-bcxx", "-u"
    system "#{bin}/omniidl", "-bpython", "-u"
  end
end
