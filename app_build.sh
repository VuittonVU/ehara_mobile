flutter clean
flutter pub get

cd ios
rm -rf Pods
rm -f Podfile.lock

pod repo update
pod install

cd ..