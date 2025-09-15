time flutter build appbundle --release --obfuscate --split-debug-info=misc/mapping/$version && \
osascript -e 'display notification "AppBundle Build Completed!" with title "Android Builder"' && \
open build/app/outputs/bundle/release/