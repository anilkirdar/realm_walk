time flutter build ipa --release --obfuscate --split-debug-info=misc/mapping/$version --export-method ad-hoc && \
osascript -e 'display notification "IPA Build Completed!" with title "iOS Builder"' && \
firebase appdistribution:distribute build/ios/ipa/linqiApp.ipa  \
    --app 1:573426258434:ios:08e149bc419efa6ecd4d1b  \
    --groups "internal-testers"
