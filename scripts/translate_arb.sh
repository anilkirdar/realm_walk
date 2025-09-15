#!/bin/bash
set -e

BASE_DIR="../lib/l10n"
AZURE_API_KEY="FJRzlq1dPyUfyAlaOKcZScyWiYN463BuRdW7I7OQuobwSr3G8zFpJQQJ99BGACPV0roXJ3w3AAAbACOGW6fc"
AZURE_REGION="germanywestcentral"

COMMON_ARGS=( "--srcFile=$BASE_DIR/intl_en.arb" "--srcLng=en" "--srcFormat=arb" "--targetFormat=arb" )

attranslate "${COMMON_ARGS[@]}" --targetFile=$BASE_DIR/intl_tr.arb --targetLng=tr --service=azure --serviceConfig="$AZURE_API_KEY,$AZURE_REGION"
# attranslate "${COMMON_ARGS[@]}" --targetFile=$BASE_DIR/intl_de.arb --targetLng=de --service=azure --serviceConfig="$AZURE_API_KEY,$AZURE_REGION"
# attranslate "${COMMON_ARGS[@]}" --targetFile=$BASE_DIR/intl_fr.arb --targetLng=fr --service=azure --serviceConfig="$AZURE_API_KEY,$AZURE_REGION"

echo "All languages updated"

flutter pub global run intl_utils:generate
