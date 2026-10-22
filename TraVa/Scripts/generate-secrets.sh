#!/bin/sh
#
#  generate-secrets.sh
#  Networking
#
#  Build-фаза таргета Networking. Берёт OMDB_API_KEY из build settings
#  (Configs/Secrets.xcconfig или `xcodebuild OMDB_API_KEY=...`) и генерирует
#  Swift-файл с XOR-обфусцированным ключом в DERIVED_FILE_DIR.
#
#  Зачем так:
#  - ключ не попадает в git (ни в исходники, ни в project.pbxproj);
#  - ключ не лежит открытым текстом в Info.plist и не находится через `strings`;
#  - сгенерированный файл живёт только в DerivedData.
#
#  Обфускация — не шифрование: ключ, зашитый в клиент, можно извлечь.
#  Полноценная защита — только серверный прокси (см. README).
#

set -eu

OUTPUT_FILE="${SCRIPT_OUTPUT_FILE_0:?SCRIPT_OUTPUT_FILE_0 is not set}"
KEY="${OMDB_API_KEY:-}"

if [ -z "$KEY" ]; then
    MESSAGE="OMDB_API_KEY is not set. Copy Configs/Secrets.xcconfig.example to Configs/Secrets.xcconfig and fill in the key."
    if [ "${CONFIGURATION:-Debug}" = "Release" ]; then
        echo "error: $MESSAGE"
        exit 1
    fi
    echo "warning: $MESSAGE"
fi

# Детерминированная соль: одинаковый ключ даёт одинаковый файл,
# поэтому Networking не перекомпилируется на каждой сборке.
SALT_SEED="${PRODUCT_BUNDLE_IDENTIFIER:-TraVa}.omdb"
SALT_HEX=$(printf '%s' "$SALT_SEED" | shasum -a 256 | cut -c1-64)

KEY_BYTES=""
SALT_BYTES=""
INDEX=0
REST="$KEY"
while [ -n "$REST" ]; do
    CHAR=$(printf '%s' "$REST" | cut -c1)
    REST=$(printf '%s' "$REST" | cut -c2-)

    OFFSET=$(( (INDEX % 32) * 2 + 1 ))
    SALT_BYTE=$(( 0x$(printf '%s' "$SALT_HEX" | cut -c"$OFFSET"-"$(( OFFSET + 1 ))") ))
    CHAR_CODE=$(printf '%d' "'$CHAR")

    KEY_BYTES="$KEY_BYTES$(( CHAR_CODE ^ SALT_BYTE )), "
    SALT_BYTES="$SALT_BYTES$SALT_BYTE, "
    INDEX=$(( INDEX + 1 ))
done

TMP_FILE="$(mktemp)"
trap 'rm -f "$TMP_FILE"' EXIT

cat > "$TMP_FILE" <<EOF
// Сгенерировано Scripts/generate-secrets.sh. Не редактируйте и не коммитьте.

enum OMDbSecrets {
    static let obfuscatedAPIKey: [UInt8] = [${KEY_BYTES%, }]
    static let salt: [UInt8] = [${SALT_BYTES%, }]
}
EOF

mkdir -p "$(dirname "$OUTPUT_FILE")"
if ! cmp -s "$TMP_FILE" "$OUTPUT_FILE"; then
    cp "$TMP_FILE" "$OUTPUT_FILE"
fi
