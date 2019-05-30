#! /bin/bash

INSTALL_DIR="/opt"

JN="10"

# Install gmp 6.1.2
tar xvf gmp-6.1.2.tar.xz
cd gmp-6.1.2
./configure --prefix=$INSTALL_DIR/gmp-6.1.2
make -j $JN && make install
cd ..

# Install mpfr 3.1.6
tar xvf mpfr-3.1.6.tar.gz
cd mpfr-3.1.6
./configure --prefix=$INSTALL_DIR/mpfr-3.1.6 --with-gmp=$INSTALL_DIR/gmp-6.1.2
make -j $JN && make install
cd ..

# Install mpc 1.0.3
tar xvf mpc-1.0.3.tar.gz
cd mpc-1.0.3
./configure --prefix=$INSTALL_DIR/mpc-1.0.3 --with-gmp=$INSTALL_DIR/gmp-6.1.2 --with-mpfr=$INSTALL_DIR/mpfr-3.1.6
make -j $JN && make install
cd ..

# ld configure
echo "$INSTALL_DIR/gmp-6.1.2/lib"  >> /etc/ld.so.conf
echo "$INSTALL_DIR/mpfr-3.1.6/lib" >> /etc/ld.so.conf
echo "$INSTALL_DIR/mpc-1.0.3/lib"  >> /etc/ld.so.conf
ldconfig -v

# Install GCC 6.4.0
tar xvf gcc-6.4.0.tar.xz
cd gcc-6.4.0
./configure --enable-checking=release --enable-languages=c,c++ --disable-multilib \
						--prefix=$INSTALL_DIR/gcc-6.4.0 --with-gmp=$INSTALL_DIR/gmp-6.1.2 \
						--with-mpfr=$INSTALL_DIR/mpfr-3.1.6 --with-mpc=$INSTALL_DIR/mpc-1.0.3
echo $LIBRARY_PATH > tmp.libpath
sed -i "s@::@:@g" tmp.libpath
FT=`head -c1 tmp.libpath`
if [ "$FT" = ":" ]; then
	sed -ie '1s/^.//' tmp.libpath
fi
export LIBRARY_PATH=`cat tmp.libpath`
make -j $JN
make install
