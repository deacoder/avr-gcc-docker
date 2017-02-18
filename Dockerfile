FROM ubuntu:16.10
MAINTAINER Andreas L, andreas.laghamn@gmail.com

ENV PATH $PATH:/usr/local/avr/bin

RUN \
    ### install build tools ###
    apt-get update && apt-get install -y --no-install-recommends \
                              wget                               \
                              make                               \
                              build-essential                    \
                              libmpc-dev \
                              libmpfr-dev \
                              libgmp3-dev \
&& mkdir /opt/distr && cd /opt/distr \
   ### download build and install cmake
&& wget https://cmake.org/files/v3.7/cmake-3.7.2.tar.gz --no-check-certificate \
&& tar -zxvf cmake-3.7.2.tar.gz && cd cmake-3.7.2 \
&& ./bootstrap && make && make install && cd ..   \
   ### download build and install binutils
&& wget http://ftp.gnu.org/gnu/binutils/binutils-2.27.tar.bz2 \
&& bunzip2 -c binutils-2.27.tar.bz2 | tar xf - && cd binutils-2.27 \
&& mkdir build && cd build \
&& ../configure --prefix=/usr/local/avr --target=avr --disable-nls \
&& make && make install && cd ../..  \
&& wget http://ftp.acc.umu.se/mirror/gnu.org/gnu/gcc/gcc-6.3.0/gcc-6.3.0.tar.bz2 \
&& bunzip2 -c gcc-6.3.0.tar.bz2 | tar xf - && cd gcc-6.3.0 \
&& mkdir build && cd build \
&& ../configure --prefix=/usr/local/avr --target=avr --enable-languages=c,c++ --disable-nls --disable-libssp --with-dwarf2 \
&& make && make install && cd ../.. \
&& cd .. && rm -rf distr   \
&& apt-get remove -y       \
           wget            \
           build-essential \
&& apt-get autoremove -y   \
&& apt-get clean           \
&& rm -rf /var/lib/apt/lists

ENTRYPOINT ["/bin/bash"]