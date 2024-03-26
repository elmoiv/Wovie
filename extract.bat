bundletool.jar build-apks --bundle=app-release.aab --output=app-release.apks --mode=universal
7z x app-release.apks universal.apk
del app-release.apks