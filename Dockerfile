FROM alpine:3.5

ENV PATH $PATH:/usr/local/avr/bin

RUN apk add --no-cache openssl bash git gcc g++ libc-dev gmp-dev mpfr-dev mpc1-dev make \
# Create build folder
&& NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && mkdir /tmp/distr && cd /tmp/distr \
#
# Download sources
#
&& wget https://cmake.org/files/v3.8/cmake-3.8.0.tar.gz \
&& wget http://ftp.gnu.org/gnu/binutils/binutils-2.28.tar.bz2 \
&& wget http://ftp.acc.umu.se/mirror/gnu.org/gnu/gcc/gcc-7.1.0/gcc-7.1.0.tar.bz2 \
&& wget http://download.savannah.gnu.org/releases/avr-libc/avr-libc-2.0.0.tar.bz2 \
#
# Building cmake
#
&& tar -xvf cmake-3.8.0.tar.gz && cd cmake-3.8.0 \
&& ./bootstrap && make -j${NPROC} && make install && cd .. \
#
# Building binutils
#
&& bunzip2 -c binutils-2.28.tar.bz2 | tar xf - && cd binutils-2.28 \
&& mkdir build && cd build \
&& ../configure --prefix=/usr/local/avr --target=avr --disable-nls \
&& make -j${NPROC} && make install && cd ../.. \
#
# Build gcc
#
&& bunzip2 -c gcc-7.1.0.tar.bz2 | tar xf - && cd gcc-7.1.0 \
&& mkdir build && cd build \
&& ../configure --prefix=/usr/local/avr --target=avr --enable-languages=c,c++ --disable-nls --disable-libssp --with-dwarf2 \
&& make -j${NPROC} && make install && cd ../.. \
#
# Building avr-libc
#
&& bunzip2 -c avr-libc-2.0.0.tar.bz2 | tar xf - && cd avr-libc-2.0.0 \
&& ./configure --prefix=/usr/local/avr --build=`./config.guess` --host=avr \
&& make -j${NPROC} && make install && cd ../.. \
&& rm -rf /tmp/distr \
&& apk del openssl libc-dev gmp-dev mpfr-dev mpc1-dev
