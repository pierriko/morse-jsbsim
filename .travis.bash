#!/bin/bash -e
export _WR=$(pwd)
export _WP=$_WR/ws
export _WS=$_WP/src
mkdir -p $_WS

cd $_WS
git clone --depth=5 git://git.code.sf.net/p/jsbsim/code jsbsim
cd jsbsim
./autogen.sh --enable-libraries --prefix=$_WP
make install

cd $_WS
git clone --depth=5 git://git.savannah.nongnu.org/certi.git
cd certi
mkdir build; cd build
cmake -DCMAKE_INSTALL_PREFIX=$_WP ..
make -j; make install

cd $_WS
name=PyHLA-1.1.1-Source
wget http://download.savannah.gnu.org/releases/certi/contrib/PyHLA/${name}.tar.gz
tar xvf ${name}.tar.gz; cd ${name}
mkdir build; cd build
cmake -DCMAKE_INSTALL_PREFIX=$_WP ..
make -j; make install

cd $_WS
git clone --depth=5 https://github.com/morse-simulator/morse.git
cd morse
mkdir build; cd build
cmake -DPYTHON_EXECUTABLE=/usr/bin/python3.4 -DCMAKE_INSTALL_PREFIX=$_WP ..
make -j; make install

cd $_WR/cpp
mkdir build; cd build
cmake -DCERTI_DIR=$_WP/share/scripts -DJSBSIM_ROOT_DIR=$_WP ..
make -j

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$_WP/lib
export PATH=$PATH:$_WP/bin

cd $_WR
morse import $(pwd)

'''
rtig
# export JSBSIM_MORSE_HOME=./jsbsim/

./cpp/build/jsbsim_node
xvfb-run --auto-servernum --server-args="-screen 0 160x120x16" morse --noaudio run morse-jsbsim
'''
