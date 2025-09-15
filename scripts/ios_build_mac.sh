time flutter build ipa --release --obfuscate --split-debug-info=misc/mapping/$version && \
osascript -e 'display notification "IPA Build Completed!" with title "iOS Builder"' && \
time xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey Y4329HM947 --apiIssuer d6d5f6db-e2ac-48b4-9e76-33b90d797bc3 && \
osascript -e 'display notification "App Upload Completed!" with title "iOS Builder"'