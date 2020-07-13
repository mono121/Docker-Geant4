FROM centos:7
MAINTAINER monomono 

ENV G4_VERSION 10.05.p01
ENV GCC_VERSION 8.2.0
ENV CMAKE_VERSION 3.17.2

RUN yum update; \
    yum -y groupinstall "GNOME Desktop"; \
    yum install -y make cmake gcc g++ gcc-c++ curl wget \
                   bzip2 devtoolset-8 \
                   libmpc-devel mpfr-devel gmp-devel \ 
                   freeglut freeglut-devel \
                   expat expat-devel \ 
                   openssl-devel libgcrypt-devel \
                   centos-release-scl \
                   qt5-linguist qt5-qtmultimedia-devel qt5-qtsvg-devel \
                   libXmu-devel \
    yum clean all

#install gcc cmake
WORKDIR /root/
RUN mkdir build; \
#install gcc
    curl -LO http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz; \
    tar xzfv gcc-${GCC_VERSION}.tar.gz -C /usr/local/src; \
    cd /usr/local/src/gcc-${GCC_VERSION}/; \
    ./contrib/download_prerequisites; \
    mkdir build && cd build; \
    ../configure --enable-languages=c,c++ --prefix=/usr/local --disable-bootstrap --disable-multilib; \
    make; \
    make install; \
    echo "/usr/local/lib64" >> /etc/ld.so.conf; \
    mv /usr/local/lib64/libstdc++.so.6.0.25-gdb.py  /usr/local/lib64/back_libstdc++.so.6.0.25-gdb.py; \
    ldconfig -v; \
#install cmake
    cd; \
    echo 'export PATH=/usr/local/opt/qt/bin:$PATH\n\
    export LDFLAGS="-L/usr/local/opt/qt/lib":$LDFLAGS\n\
    export CPPFLAGS="-I/usr/local/opt/qt/include":$CPPFLAGS\n\
    export PKG_CONFIG_PATH=/usr/local/opt/qt/lib/pkgconfig:$PKG_CONFIG_PATH\n\
    export CMAKE_ROOT=/usr/share/cmake-${CMAKE_VERSION}' >> .bash_profile; \
    wget https://cmake.org/files/v3.17/cmake-${CMAKE_VERSION}.tar.gz; \
    tar xzfv cmake-${CMAKE_VERSION}.tar.gz; \
    cd cmake-${CMAKE_VERSION} && ./bootstrap; \
    make && make install; \
    source ~/.bash_profile

#install Geant4
WORKDIR /opt/    
RUN mkdir Geant4; \ 
    mkdir Geant4/build; \
    mkdir Geant4/install; \
    cd Geant4; \
    curl -LO http://geant4-data.web.cern.ch/geant4-data/releases/geant4.${G4_VERSION}.tar.gz; \
    tar -zxzf geant4.${G4_VERSION}.tar.gz; \
    cd build; \
    cmake -DCMAKE_INSTALL_PREFIX=/opt/Geant4/install  \
          -DGEANT4_USE_QT=ON \
          -DGEANT4_INSTALL_DATA=ON /opt/Geant4/geant4.${G4_VERSION}; \
    make -j4; \
    make install; \