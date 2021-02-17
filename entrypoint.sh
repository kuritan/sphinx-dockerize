#!/bin/sh
set -x

MAKE_ACTION="build"
SERVE_ACTION="serve"
WORK_DIR="/root"
DOC_DIR="$WORK_DIR/test-project"
BUILD_DIR="$DOC_DIR/build"
SOURCE_DIR="$DOC_DIR/source"
CONFIG_FILE_NAME="Makefile"
BUILD_CONTENT_PACKAGE="site.tar.gz"
BUILD_COMMAND="make html"
SERVE_COMMAND="sphinx-autobuild $SOURCE_DIR $BUILD_DIR"

# check option number
# just execute if option number > 1
if [ $# -gt 1 ]; then
    exec "$@"
# 
# build handler
#
elif [ $1 = $MAKE_ACTION ]; then
    if [ ! -d $DOC_DIR -o ! -f $DOC_DIR/$CONFIG_FILE_NAME ]; then
        echo "doc directory or Makefile does not exist."
        echo "make sure you set them up."
        echo "please check project README.md for more information."
        exit 1
    fi

    # build docs
    cd $DOC_DIR
    $BUILD_COMMAND

    # package all site contents
    cd $BUILD_DIR
    tar -zcvf $BUILD_CONTENT_PACKAGE *
    # move to the project's root dir
    mv $BUILD_CONTENT_PACKAGE $WORK_DIR/$BUILD_CONTENT_PACKAGE
    echo "Built all site contents."
    exit 0

# 
# serve handler
#
elif [ $1 = $SERVE_ACTION ]; then
    # root dir now
    if [ ! -f $BUILD_CONTENT_PACKAGE ]; then
        echo "site files tar file does not exist."
        echo "make sure you set it up."
        echo "please check project README.md for more information."
        exit 1
    fi

    # extract all site contents to target dir
    mkdir -p $BUILD_DIR
    rm -rf $BUILD_DIR/*
    tar -xvzf $BUILD_CONTENT_PACKAGE -C $BUILD_DIR/

    cd $DOC_DIR
    $SERVE_COMMAND
    
else
    echo "wrong argument."
    echo "please check project README.md for more information."
    exit 1
fi
