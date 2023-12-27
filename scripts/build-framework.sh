ENV=${1:-"release"}

HEADER_DIR="shared_lib/bindings"
LIB_NAME="shared_lib"
NEW_HEADER_DIR="shared_lib/bindings/include"
OUTDIR="app/uniffi-example"
RELDIR="release"
STATIC_LIB_NAME="lib${LIB_NAME}.a"
TARGETDIR="shared_lib/target"

make bindings
make lib

mkdir -p "${NEW_HEADER_DIR}"
cp "${HEADER_DIR}/shared_libFFI.h" "${NEW_HEADER_DIR}/"
cp "${HEADER_DIR}/shared_libFFI.modulemap" "${NEW_HEADER_DIR}/module.modulemap"

rm -rf "${OUTDIR}/${NAME}_framework.xcframework"

rm -rf "${OUTDIR}/${LIB_NAME}_framework.xcframework"

xcodebuild -create-xcframework \
  -library "${TARGETDIR}/aarch64-apple-darwin/${ENV}/${STATIC_LIB_NAME}" \
  -headers "${NEW_HEADER_DIR}" \
  -library "${TARGETDIR}/aarch64-apple-ios/${ENV}/${STATIC_LIB_NAME}" \
  -headers "${NEW_HEADER_DIR}" \
  -library "${TARGETDIR}/aarch64-apple-ios-sim/${ENV}/${STATIC_LIB_NAME}" \
  -headers "${NEW_HEADER_DIR}" \
  -output "${OUTDIR}/${LIB_NAME}_framework.xcframework"