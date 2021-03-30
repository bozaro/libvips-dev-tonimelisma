#!/bin/bash -ex

DISTVERSION=20.04
DISTRIBUTION=hirsute

PACKAGE=vips
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ -z "${DISTRIBUTION}" ]; then
	echo "Define environment variable DISTRIBUTION as backport source (e.g. groovy)"
	exit 1
fi

if [ -z "${DISTVERSION}" ]; then
	echo "Define environment variable DISTVERSION as backport target (e.g. 20.04)"
	exit 1
fi

if [ -z "${PACKAGE}" ]; then
	echo Define environment variable PACKAGE "(e.g. vips)"
	exit 1
fi

echo Building base image:

docker build -t build-$PACKAGE:$DISTVERSION -f $DIR/Dockerfile-$PACKAGE-$DISTVERSION $DIR || (echo build failed 1>&2 && exit 1)

mkdir -p packages/$DISTVERSION
docker run --rm -ti -e SOURCEDIST=$DISTRIBUTION -v $(pwd)/packages/$DISTVERSION:/packages build-$PACKAGE:$DISTVERSION /within_container-$PACKAGE.sh
