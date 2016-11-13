class X8664PcElfGcc < Formula
  desc "The GNU Compiler Collection for cross-compiling to x86_64-pc-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftpmirror.gnu.org/gcc/gcc-5.4.0/gcc-5.4.0.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/gcc/gcc-5.4.0/gcc-5.4.0.tar.bz2"
  sha256 "608df76dec2d34de6558249d8af4cbee21eceddbcb580d666f7a5a583ca3303a"

  option "without-cxx", "Don't build the g++ compiler"

  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"

  depends_on "x86_64-pc-elf-binutils"

  # Build-only dependencies
  depends_on "autoconf" => :build
  depends_on "automake" => :build


  def install
    # The C compiler is always built, C++ can be disabled
    languages = %w[c]
    languages << "c++" if build.with? "cxx"
    binutils = Formula[x86_64-pc-elf-binutils]

    ENV['PATH'] += ":#{binutils.prefix/"bin"}"

    mkdir "build" do
      system "../configure", "--target=x86_64-pc-elf",
                             "--prefix=#{prefix}",
                             "--enable-languages=#{languages.join(",")}",
                             "--disable-nls",
                             "--without-headers",
                             "--with-gmp=#{Formula["gmp"].opt_prefix}",
                             "--with-mpfr=#{Formula["mpfr"].opt_prefix}",
                             "--with-mpc=#{Formula["libmpc"].opt_prefix}"

      ENV.deparallelize
      system "make", "all-gcc"
      system "make", "all-target-libgcc"
      system "make", "install-gcc"
      system "make", "install-target-libgcc"
    end
    # info and man7 files conflict with native gcc
    info.rmtree
    man7.rmtree
  end
end
