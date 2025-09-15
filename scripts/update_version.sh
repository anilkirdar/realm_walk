major="2"
minor="4"
sub="43"
number="446"

version="$major.$minor.$sub"

sed -i '' -e "s/^version:.*$/version: $version+$number/g" ./pubspec.yaml
sed -i '' -e "s/FLUTTER_BUILD_NAME = .*;$/FLUTTER_BUILD_NAME = $version;/g" ./ios/Runner.xcodeproj/project.pbxproj
sed -i '' -e "s/FLUTTER_BUILD_NUMBER = .*;$/FLUTTER_BUILD_NUMBER = $number;/g" ./ios/Runner.xcodeproj/project.pbxproj
sed -i '' -e "s/MARKETING_VERSION = .*;$/MARKETING_VERSION = $version;/g" ./ios/Runner.xcodeproj/project.pbxproj

sed -i '' -e "s/majorVersion = .*;$/majorVersion = $major;/g" ./lib/core/constants/app/app_const.dart
sed -i '' -e "s/minorVersion = .*;$/minorVersion = $minor;/g" ./lib/core/constants/app/app_const.dart
sed -i '' -e "s/subVersion = .*;$/subVersion = $sub;/g" ./lib/core/constants/app/app_const.dart

sed -i '' -e "s/androidVersionInt = .*;$/androidVersionInt = $number;/g" ./lib/core/constants/app/app_const.dart
sed -i '' -e "s/iOSVersionInt = .*;$/iOSVersionInt = $number;/g" ./lib/core/constants/app/app_const.dart

git add .
git commit -m "update version to $version"