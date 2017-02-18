FROM alpine

ENV PATH $PATH:/usr/local/avr/bin

RUN apk update && apk upgrade
RUN apk add bash gcc g++ libc-dev gmp-dev mpfr-dev mpc1-dev make \
# Create build folder
&& NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && mkdir /tmp/distr && cd /tmp/distr \
# Download binutils
&& wget http://ftp.gnu.org/gnu/binutils/binutils-2.27.tar.bz2 \
&& bunzip2 -c binutils-2.27.tar.bz2 | tar xf - && cd binutils-2.27 \
&& mkdir build && cd build \
&& ../configure --prefix=/usr/local/avr --target=avr --disable-nls \
&& make -j${NPROC} && make install && cd ../.. \
# Build gcc
&& wget http://ftp.acc.umu.se/mirror/gnu.org/gnu/gcc/gcc-6.3.0/gcc-6.3.0.tar.bz2 \
&& bunzip2 -c gcc-6.3.0.tar.bz2 | tar xf - && cd gcc-6.3.0 \
&& mkdir build && cd build \
&& ../configure --prefix=/usr/local/avr --target=avr --enable-languages=c,c++ --disable-nls --disable-libssp --with-dwarf2 \
&& make -j${NPROC} && make install && cd ../.. \
&& rm -rf /tmp/distr \
&& apk del gcc g++ libc-dev gmp-dev mpfr-dev mpc1-dev