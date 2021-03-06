#!/bin/bash -e

EXT_INSTALL_PATH=$PWD/extlibs

CWD=$PWD

DIRECTORY=$(cd `dirname $0` && pwd)

pushd $DIRECTORY
    if [[ "$#" -eq "1" && "$1" == "--clean" ]]; then
        quilt pop -afq || test $? = 2
        make distclean
    elif [[ "$#" -eq "1" && "$1" == "--force-clean" ]]; then
        git clean -fdx .
        git checkout .
    else
        tar --strip-components=1 -xf gettext-0.19.8.1.tar.gz
        PKG_CONFIG_PATH=$EXT_INSTALL_PATH/lib/pkgconfig ./configure --prefix=$EXT_INSTALL_PATH \
        --disable-dependency-tracking --without-lispdir --disable-csharp \
        --disable-libasprintf --disable-java --disable-native-java --disable-openmp --without-emacs
        make -j$(getconf _NPROCESSORS_ONLN)
        make install
    fi
popd

