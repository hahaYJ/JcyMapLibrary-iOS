#删除旧的xcframework
rm -rf ./JcyMapLibrary.xcframework

#构建模拟器
xcodebuild archive \
    -project ./JcyMapLibrary-iOS.xcodeproj \
    -scheme JcyMapLibrary \
    -destination "generic/platform=iOS Simulator" \
    -sdk iphonesimulator \
    -configuration Release \
    -archivePath ./build/iphonesimulator \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES

#构建真机
xcodebuild archive \
    -project ./JcyMapLibrary-iOS.xcodeproj \
    -scheme JcyMapLibrary \
    -destination "generic/platform=iOS" \
    -sdk iphoneos \
    -configuration Release \
    -archivePath ./build/iphone \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES

#构建xcframework
xcodebuild -create-xcframework \
    -framework ./build/iphone.xcarchive/Products/Library/Frameworks/JcyMapLibrary.framework \
    -framework ./build/iphonesimulator.xcarchive/Products/Library/Frameworks/JcyMapLibrary.framework \
    -output ./JcyMapLibrary.xcframework

#删除构建中间产物
rm -rf ./build
