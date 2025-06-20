#!/bin/bash

# Universal DOCX to PDF converter with automatic title extraction
# Usage: ./convert_auto_title.sh input.docx [output_name]

# Check if input file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 input.docx [output_name]"
    echo "Example: $0 document.docx my_paper"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_NAME="${2:-paper}"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found!"
    exit 1
fi
mcw20
echo "Converting $INPUT_FILE to $OUTPUT_NAME.pdf..."

# Step 1: Extract title using Pandoc's markdown conversion
echo "Step 1: Extracting title from document..."
TITLE=$(pandoc "$INPUT_FILE" --to=markdown --quiet | grep -E '^# ' | head -n 1 | sed 's/^# //')

if [ -z "$TITLE" ]; then
    # Try to find the first bold text (which might be the title)
    TITLE=$(pandoc "$INPUT_FILE" --to=markdown --quiet | grep -E '^\*\*.*\*\*$' | head -n 1 | sed 's/^\*\*//;s/\*\*$//')
fi

if [ -z "$TITLE" ]; then
    # Fallback: look for first substantial line
    TITLE=$(pandoc "$INPUT_FILE" --to=plain --quiet | grep -v '^$' | head -n 5 | grep -E '^[A-Z].*[a-z]' | head -n 1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
fi

if [ -z "$TITLE" ]; then
    TITLE="Document Title"
fi

echo "Extracted title: $TITLE"

# Step 2: Convert directly to LaTeX and extract media
echo "Step 2: Converting DOCX directly to LaTeX..."
pandoc -s "$INPUT_FILE" -o "${OUTPUT_NAME}.tex" --template=template/template.tex --extract-media=media_extracted --metadata title="$TITLE"

if [ $? -ne 0 ]; then
    echo "Error: Pandoc conversion failed!"
    exit 1
fi

# Step 3: Remove title from content and fix image widths
echo "Step 3: Processing LaTeX content..."
TEMP_TEX="${OUTPUT_NAME}_temp.tex"

# Create a backup
cp "${OUTPUT_NAME}.tex" "${OUTPUT_NAME}_before_processing.tex"

# Remove the title from content if it's not the fallback title
if [ "$TITLE" != "Document Title" ]; then
    echo "Removing title from content: $TITLE"
    
    # Use grep to find and remove the line containing the bold title
    grep -v "\\textbf{$TITLE}" "${OUTPUT_NAME}.tex" > "${OUTPUT_NAME}_temp.tex"
    mv "${OUTPUT_NAME}_temp.tex" "${OUTPUT_NAME}.tex"
fi

# Fix image paths and force column width
sed -i 's|media/media/|media_extracted/|g' "${OUTPUT_NAME}.tex"

# Replace all includegraphics to use columnwidth
sed -i 's/\\includegraphics\[[^]]*\]/\\includegraphics[width=\\columnwidth]/g' "${OUTPUT_NAME}.tex"

# Add a paragraph break and vertical space after every includegraphics to ensure space after images
sed -i 's/\(\\includegraphics[^}]*}\)/\1\\vspace{3pt}\\hspace{3pt} /g' "${OUTPUT_NAME}.tex"

# Create a backup after processing
cp "${OUTPUT_NAME}.tex" "${OUTPUT_NAME}_after_processing.tex"

# Step 4: Compile LaTeX to PDF
echo "Step 4: Compiling LaTeX to PDF..."
pdflatex "${OUTPUT_NAME}.tex"

if [ $? -ne 0 ]; then
    echo "Error: LaTeX compilation failed!"
    exit 1
fi

# Clean up temporary files
echo "Cleaning up temporary files..."
rm -f "${OUTPUT_NAME}.aux" "${OUTPUT_NAME}.log" "${OUTPUT_NAME}.out" "${OUTPUT_NAME}_before_processing.tex" "${OUTPUT_NAME}_after_processing.tex" "${OUTPUT_NAME}.tex"

echo "Success! Output file: ${OUTPUT_NAME}.pdf"
echo "Title used: $TITLE"
echo "Title removed from content to avoid duplication"
echo "All images set to width=\\columnwidth"