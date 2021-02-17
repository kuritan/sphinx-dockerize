#!/bin/bash

WORK_DIR="$PWD"
DOC_DIR="$WORK_DIR/test-project"
BUILD_DIR="$DOC_DIR/build"
SOURCE_DIR="$DOC_DIR/source"
CONFIG_FILE_NAME="Makefile"
BUILD_CONTENT_PACKAGE="site.tar.gz"
BUILD_COMMAND="make html"
SERVE_COMMAND="sphinx-autobuild --host 0.0.0.0 $SOURCE_DIR $BUILD_DIR"

# 
# help information
#
function usage {
    cat <<EOF
$(basename ${0}) is a tool for build and serve sphinx-doc.

Usage:
    $(basename ${0}) [command] [<options>]

Options:
    build                  build docs and package all site contents
    serve                  after build stage, extract built site contents and running sphinx-doc
    version|--version|-v   show $(basename ${0}) version
    help|--help|-h         show this usage text
EOF
}

# 
# tool version information
#
function version {
    echo "$(basename ${0}) version 1.0 "
}

# 
# build handler
#
function build {
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
}

# 
# serve handler
#
function serve {
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
}

#
# options
#

# check option number
if [ $# -eq 1 ]; then
    case ${1} in

        build)
            build
        ;;

        serve)
            serve
        ;;

        help|--help|-h)
            usage
        ;;

        version|--version|-v)
            version
        ;;

        *)
            echo "[ERROR] Invalid subcommand '${1}'"
            usage
            exit 1
        ;;
    esac
else
    echo "[ERROR] Invalid subcommand"
    usage
    exit 1
fi