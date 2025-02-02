#!/bin/sh
CURRENT_PROJECT_VERSION="$1"  # e.g. 2.75
BUILT_PRODUCTS_DIR="build/Jitouch_${CURRENT_PROJECT_VERSION}"
OBJROOT=build/staging
PRODUCT_BUNDLE_IDENTIFIER="com.jitouch.Jitouch"
signing_cert="Developer ID Installer: Aaron Kollasch (5UQY3B3594)"

rm -rf "$OBJROOT"/*
mkdir -p "$OBJROOT/pkg_staging/"
cp -rp ${BUILT_PRODUCTS_DIR}/Jitouch.prefPane ${OBJROOT}/pkg_staging/Jitouch.prefPane
pkgbuild --root ${OBJROOT}/pkg_staging/ --component-plist prefpane/components.plist --identifier ${PRODUCT_BUNDLE_IDENTIFIER} --version ${CURRENT_PROJECT_VERSION} --sign "${signing_cert}" --timestamp "${OBJROOT}/JitouchPrefpane.pkg"  --install-location /Library/PreferencePanes
productbuild --distribution prefpane/distribution.xml --package-path ${OBJROOT} --identifier ${PRODUCT_BUNDLE_IDENTIFIER} --version ${CURRENT_PROJECT_VERSION} --sign "${signing_cert}" --timestamp "${BUILT_PRODUCTS_DIR}/Install-Jitouch.pkg"
xcrun notarytool submit "${BUILT_PRODUCTS_DIR}/Install-Jitouch.pkg" --keychain-profile "aaron@kollasch.dev" --wait
spctl --assess -vv --type install "${BUILT_PRODUCTS_DIR}/Install-Jitouch.pkg"

