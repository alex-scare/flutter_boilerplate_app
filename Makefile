
locale: locale_translate locale_csv_format locale_jsons locale_keys

# Translate localization texts (only lines without some values will be translated)
locale_translate: 
	dart scripts/i18n/localization_translate.dart -s assets/translations/source.csv --g_cloud_app_name karteto-app

# Fix value wrapping in csv file
locale_csv_format: 
	dart scripts/i18n/localization_csv_format.dart -s assets/translations/source.csv

# Generate locale keys
locale_keys: 
	dart scripts/i18n/localization_keys.dart -s assets/translations/en-US.json -o lib/services/i18n/locale_key.g.dart

# Generate locale jsons
locale_jsons: 
	dart scripts/i18n/localization_jsons.dart -s assets/translations/source.csv -o assets/translations
