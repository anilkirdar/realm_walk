# cd scripts
# python translate_arb.py (in scripts path)
# flutter pub global run intl_utils:generate

import json
import requests
import os
import re

DEEPL_API_KEY = "11d5b26b-2fab-404a-863b-a36e3b458a64:fx"
SOURCE_FILE = '../lib/l10n/intl_en.arb' # IMPORTANT
TARGET_LANGS = ['TR'] # IMPORTANT
OUTPUT_DIR = '../lib/l10n'
DEEPL_API_URL = "https://api-free.deepl.com/v2/translate"

PLACEHOLDER_PATTERN = re.compile(r'\{(\w+)\}')

# El ile düzeltilmiş çeviriler
CUSTOM_TRANSLATIONS = {
    # "onboardTitle1": {
    #     "TR": "Video oyunu oynayarak\nödeme alın!"
    # },
    # "onboardTitle2": {
    #     "TR": "Arkadaşlarınla\noyun planla"
    # },
    # "onboardTitle3": {
    #     "TR": "Metin, sesli\nve görüntülü sohbet"
    # },
    # "onboardSubtitle1": {
    #     "TR": "Bir oyunu kazandığında puan ve gerçek para kazan,\nkazancını anında nakde çevir!"
    # },
    # "onboardSubtitle2": {
    #     "TR": "Kolayca yaklaşan bir etkinlik oluştur\nve savaşa hazırlan. Evet! Gerçek savaşçı sensin."
    # },
    # "onboardSubtitle3": {
    #     "TR": "Gerçek hayat hissi mobilde.\nSavaştan önce ve sonra oyuncularla ücretsiz sohbet et!"
    # },
    # "letsCombat": {
    #     "TR": "Hadi kapışalım!"
    # }
}

def translate_text(text, target_lang):
    if not text.strip():
        return text
    
    lines = text.split('\n')
    if len(lines) > 1 and all(len(line.split()) <= 3 for line in lines if line.strip()):
        combined_text = ' '.join(lines)
        response = requests.post(
            DEEPL_API_URL,
            data={
                'auth_key': DEEPL_API_KEY,
                'text': combined_text,
                'target_lang': target_lang
            }
        )
        result = response.json()
        translated = result['translations'][0]['text']
        words = translated.split()
        mid_point = len(words) // 2
        line1 = ' '.join(words[:mid_point])
        line2 = ' '.join(words[mid_point:])
        final_result = f"{line1}\n{line2}"
        return final_result

    translated_lines = []
    for line in lines:
        if line.strip():
            response = requests.post(
                DEEPL_API_URL,
                data={
                    'auth_key': DEEPL_API_KEY,
                    'text': line,
                    'target_lang': target_lang
                }
            )
            result = response.json()
            translated = result['translations'][0]['text']
            translated_lines.append(translated)
        else:
            translated_lines.append(line)

    final_result = '\n'.join(translated_lines)
    return final_result

def preserve_placeholders(original_text, translated_text):
    placeholders = PLACEHOLDER_PATTERN.findall(original_text)
    for placeholder in placeholders:
        translated_text = re.sub(rf'\{{\s*{placeholder}\s*\}}', f'{{{placeholder}}}', translated_text)
    return translated_text

def translate_arb_for_lang(target_lang):
    lang_code = target_lang.lower()
    output_file = os.path.join(OUTPUT_DIR, f'intl_{lang_code}.arb')

    with open(SOURCE_FILE, 'r', encoding='utf-8') as src_file:
        source_data = json.load(src_file)

    if os.path.exists(output_file):
        with open(output_file, 'r', encoding='utf-8') as tgt_file:
            target_data = json.load(tgt_file)
    else:
        target_data = {}

    updated_data = target_data.copy()
    updated_data["@@locale"] = lang_code  # ✅ doğru locale burada atanıyor

    for key, value in source_data.items():
        if key.startswith('@'):
            if key == "@@locale":
                continue  # ❗️@@locale tekrar yazılmasın
            updated_data[key] = value
            continue

        if not isinstance(value, str) or not value.strip():
            updated_data[key] = value
            continue

        # El ile belirlenmiş özel çeviri varsa onu al
        custom = CUSTOM_TRANSLATIONS.get(key, {}).get(target_lang)
        if custom:
            translated_text = custom
        else:
            translated_text = translate_text(value, target_lang)
            translated_text = preserve_placeholders(value, translated_text)

        updated_data[key] = translated_text

    with open(output_file, 'w', encoding='utf-8') as outfile:
        json.dump(updated_data, outfile, indent=2, ensure_ascii=False)

if __name__ == "__main__":
    for lang in TARGET_LANGS:
        translate_arb_for_lang(lang)
