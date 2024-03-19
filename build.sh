#!/usr/bin/env bash

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BUILD="build"

if ! [ -d "$DIR/$BUILD" ] ; then
  mkdir "$DIR/$BUILD"
fi

(
  cd "$DIR/$BUILD" || exit
  rm -r ./**
  cmake -G Ninja -DCMAKE_TOOLCHAIN_FILE=../toolchain.cmake ../
  ninja
)
