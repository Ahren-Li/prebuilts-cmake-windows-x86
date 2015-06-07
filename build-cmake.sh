#!/bin/bash -ex
# Download & build cmake on the local machine
# works on Linux, OSX, and Windows (Git Bash)
# leaves output in /tmp/cmake-build/install/
# cmake must be installed on Windows

PROJ=cmake
VER=3.2.3
MSVS=2013

source $(dirname "$0")/build-common.sh build-common.sh

TGZ=$PROJ-$VER.tar.gz  # has \n line feeds
curl -L http://www.cmake.org/files/v3.2/$TGZ -o $TGZ
tar xzf $TGZ
mkdir $RD/build
cd $RD/build

case "$OS" in
windows)
    #cmake -G "Visual Studio 12 2013" "$(cygpath -w $RD/$PROJ-$VER)"
    #devenv.com CMake.sln /Build Release /Out log.txt
    cmake -G "Unix Makefiles"  -DCMAKE_INSTALL_PREFIX:PATH="$(cygpath -w $INSTALL)" "$(cygpath -w $RD/$PROJ-$VER)"
    ;;
*)
    $RD/$PROJ-$VER/configure --prefix=$INSTALL
    ;;
esac
make -j$CORES
make install

commit_and_push
