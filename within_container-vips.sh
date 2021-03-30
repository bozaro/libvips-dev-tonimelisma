#!/bin/bash -ex

echo Building package $PACKAGE for distribution $DISTRIBUTION to PPA $PPANAME

echo deb-src http://ru.archive.ubuntu.com/ubuntu/ $SOURCEDIST universe > /etc/apt/sources.list.d/ubuntu-backport.list
apt update

mkdir -p /tmp/build-$PACKAGE-$DISTRIBUTION && cd /tmp/build-$PACKAGE-$DISTRIBUTION
apt-get -q -y source $PACKAGE

SRCDIR=`find . -mindepth 1 -maxdepth 1 -type d`
echo Source dir is "$SRCDIR"

cd "$SRCDIR/debian"

cp /patches/*.patch patches/
ls /patches >> patches/series

cat control | sed 's/^Build-Depends: /Build-Depends: libheif-dev, /' > control.new
mv control.new control

dch --local tonimelisma --distribution $DISTRIBUTION 'Add HEIF support'
dch --local bozaro --distribution $DISTRIBUTION 'Signal error on EOF in jpegload more reliably'
debuild -us -uc

cp ../../*.deb /packages/
