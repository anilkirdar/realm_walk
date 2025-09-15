time flutter build appbundle --release --obfuscate --split-debug-info=misc/mapping/$version && \
osascript -e 'display notification "AppBundle Build Completed!" with title "Android Builder"' && \
firebase appdistribution:distribute build/app/outputs/bundle/release/app-release.aab  \
    --app 1:573426258434:android:2137a546b5508648cd4d1b  \
    --groups "internal-testers"
