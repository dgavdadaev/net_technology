#!/usr/bin/env bash
#
# Пакетная конвертация всех .qmd файлов (рекурсивно, в подпапках) в .docx и .pdf
# Работает через pandoc, без необходимости устанавливать Quarto.
#
# Использование:
#   1) Положите этот скрипт в папку, где лежат все ваши .qmd файлы
#      (например, у каждого студента своя подпапка с файлом .qmd и подпапкой image/)
#   2) chmod +x convert_qmd_to_docx_pdf.sh
#   3) ./convert_qmd_to_docx_pdf.sh
#
# Результаты появятся в подпапке ./converted (отдельно docx и pdf для каждого файла).

set -e

INPUT_DIR="."                 # где искать .qmd файлы (рекурсивно)
OUTPUT_DIR="./converted"      # куда складывать результаты
MAINFONT="DejaVu Serif"       # шрифт с поддержкой кириллицы для PDF
SANSFONT="DejaVu Sans"
MONOFONT="DejaVu Sans Mono"

mkdir -p "$OUTPUT_DIR"

count=0
find "$INPUT_DIR" -iname "*.qmd" | while IFS= read -r qmd; do
    dir=$(dirname "$qmd")
    name=$(basename "$qmd" .qmd)

    echo "==> Конвертирую: $qmd"

    # DOCX
    pandoc "$qmd" \
        --resource-path="$dir" \
        -o "$OUTPUT_DIR/$name.docx" \
        || echo "    [!] Ошибка при создании DOCX для $qmd"

    # PDF (через xelatex — лучше работает с кириллицей)
    pandoc "$qmd" \
        --resource-path="$dir" \
        --pdf-engine=xelatex \
        -V mainfont="$MAINFONT" \
        -V sansfont="$SANSFONT" \
        -V monofont="$MONOFONT" \
        -o "$OUTPUT_DIR/$name.pdf" \
        || echo "    [!] Ошибка при создании PDF для $qmd"

    count=$((count + 1))
done

echo ""
echo "Готово. Результаты в папке: $OUTPUT_DIR"
