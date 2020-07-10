FROM centos:7
MAINTAINER monomono 

RUN yum update; \
    yum install "X Software Development"; \
    yum install -y make cmake gcc g++ gcc-c++ curl wget \
                   bzip2 devtoolset-8 \
                   libmpc-devel mpfr-devel gmp-devel \ 
                   freeglut freeglut-devel \
                   expat expat-devel \ 
                   openssl-devel libgcrypt-devel \
                   centos-release-scl \
                   qt5-linguist qt5-qtmultimedia-devel qt5-qtsvg-devel \
    yum clean all; \
    echo "export PATH=/usr/local/opt/qt/bin:$PATH\n
          export LDFLAGS="-L/usr/local/opt/qt/lib":$LDFLAGS\n
          export CPPFLAGS="-I/usr/local/opt/qt/include":$CPPFLAGS\n
          export PKG_CONFIG_PATH=/usr/local/opt/qt/lib/pkgconfig:$PKG_CONFIG_PATH\n
          export CMAKE_ROOT=/usr/share/cmake-3.17\n
          " >> .bash_profile; \
    source .bash_profile: \


#install gcc cmake
RUN mkdir build; \
#install gcc
    curl -LO http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-8.2.0/gcc-8.2.0.tar.gz; \
    tar xzfv gcc-8.2.0.tar.gz -C /usr/local/src; \
    cd /usr/local/src/gcc-8.2.0/; \
    ./contrib/download_prerequisites; \
    mkdir build && build; \
    ../configure --enable-languages=c,c++ --prefix=/usr/local --disable-bootstrap --disable-multilib; \
    make; \
    make install; \
    echo "/usr/local/lib64" >> /etc/ld.so.conf; \
    mv /usr/local/lib64/libstdc++.so.6.0.25-gdb.py  /usr/local/lib64/back_libstdc++.so.6.0.25-gdb.py; \
    ldconfig -v; \
#install cmake
    wget https://cmake.org/files/v3.6/cmake-3.6.2.tar.gz; \
    tar xzfv cmake-3.6.2.tar.gz ; \

WORKDIR /apt/
RUN mkdir Geant4; \ 
    mkdir Geant4/build; \
    mkdir Geant4/install; \
    cd Geant4; \
    curl -LO http://geant4-data.web.cern.ch/geant4-data/releases/geant4.10.06.p02.tar.gz; \
    tar -zxzf geant4.10.06.p02.tar.gz; \
    cd build; \
    cmake -DCMAKE_INSTALL_PREFIX=/opt/Geant4/install  \
          -DGEANT4_USE_QT=ON \
          -DGEANT4_INSTALL_DATA=ON /opt/Geant4/geant4.10.06.p02; \
    make -j4; \
    make install; \