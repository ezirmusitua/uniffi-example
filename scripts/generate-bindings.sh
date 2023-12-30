#!/bin/bash

pushd shared_lib
  targets=("ios" "ios-sim" "darwin")
  for suffix in "${targets[@]}"
  do
    target="aarch64-apple-${suffix}"
    echo "Generating target=${target}"
    cargo build --target $target --release
    cargo run \
      --bin uniffi-bindgen generate \
      --library target/${target}/release/libshared_lib.a \
      --language swift \
      --out-dir out/${target}
    mv out/${target}/shared_libFFI.modulemap out/${target}/module.modulemap
  done
popd