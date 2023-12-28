make bindings

DEST="../app/uniffi-example/shared_lib_framework.xcframework"
ENV="release"
HEADER_DIR="out"
STATIC_LIB_NAME="libshared_lib.a"
TARGET_DIR="target"

cd shared_lib

rm -rf $DEST

xcodebuild -create-xcframework \
  -library "${TARGET_DIR}/aarch64-apple-darwin/${ENV}/${STATIC_LIB_NAME}" \
  -headers "${HEADER_DIR}/aarch64-apple-darwin" \
  -library "${TARGET_DIR}/aarch64-apple-ios/${ENV}/${STATIC_LIB_NAME}" \
  -headers "${HEADER_DIR}/aarch64-apple-ios" \
  -library "${TARGET_DIR}/aarch64-apple-ios-sim/${ENV}/${STATIC_LIB_NAME}" \
  -headers "${HEADER_DIR}/aarch64-apple-ios-sim" \
  -output  $DEST