# Universal DOCX to Academic PDF Converter

Convert any Word document to a professional, double-column academic PDF format with automatic title extraction and image handling.

## Quick Start

```bash
# Activate your conda environment (with Pandoc and LaTeX)
conda activate yoloe

# Install Python dependencies 
conda install -c conda-forge texlive-core pandoc

# Convert any DOCX to PDF
chmod + convert.sh

./convert.sh docx/input.docx my_paper
# Output: my_paper.pdf
```

## What You Get

- **Double-column academic layout** (like research papers)
- **Professional formatting** with Times New Roman font
- **Automatic title extraction** (from first heading or bold text)
- **Title removed from body** (no duplication)
- **Automatic image handling** (images fit column, no overlap)
- **Word formatting support** (underlines, strikethrough)
- **Clean, print-ready PDF**

## Files

- `template/template.tex` - Universal academic LaTeX template
- `convert.sh` - Automated conversion script
- `docx/input.docx` - Example input DOCX
- `media_extracted/` - Extracted images from DOCX


### File Structure
```
arxiv-dox/
├── docx/
│   └── input.docx          # Input DOCX file
├── template.tex            # LaTeX template (FINAL WORKING VERSION)
├── convert_auto_title.sh   # Conversion script
├── output/
│   └── output.pdf          # Generated PDF
├── media/                  # Images from DOCX
├── README.md              # Documentation
```

## Script Details

### `convert_auto_title.sh` Workflow
1. **Extract Title**: Convert DOCX to markdown and extract first heading/bold text as title
2. **Remove Title**: Remove the exact title line from LaTeX content
3. **Generate LaTeX**: Convert DOCX to LaTeX using template
4. **Compile PDF**: Use pdflatex to generate final PDF

### Title Extraction Logic
- Looks for first `# ` heading (H1)
- Falls back to first `**bold text**` if no heading found
- Uses regex patterns for precise matching
- Preserves all other content

## Template Features

### `template.tex` Capabilities
- **Document Class**: `article` with `twocolumn` option
- **Font**: Times New Roman (`times` package)
- **Text Alignment**: Fully justified (no `\raggedright`)
- **Hyphenation**: Minimal with standard penalties
- **Formatting**: 
  - Underlines (`\ul` command)
  - Strikethroughs (`\sout` command)
  - Bold and italic text
- **Layout**: Professional academic paper appearance
- **Metadata**: Uses Pandoc variables for title and author

## Troubleshooting

### Common Issues
1. **Missing Images**: Ensure images are in `media/` directory
2. **Font Issues**: Times New Roman should be available on most systems
3. **Compilation Errors**: Check for special characters in content
4. **Title Not Extracted**: Verify document has clear heading or bold title

## Requirements

- Pandoc
- LaTeX (pdflatex, texlive)
  - **pdflatex is required** (included in texlive-full, or install separately)
- bash (for running the script)
- Python (optional, for advanced customization)

See `requirements.txt` for details.

## Usage

```bash
# Basic conversion
./convert.sh docx/input.docx my_paper
# Output: my_paper.pdf

# If you omit the output name, it defaults to 'output.pdf'
./convert.sh docx/input.docx
```

The script will:
1. Extract the document title from the DOCX (first heading or bold text)
2. Remove the title from the body content
3. Convert DOCX to LaTeX using the academic template
4. Fix image sizing and placement for double-column layout
5. Compile the LaTeX to PDF
6. Clean up temporary files

## Features

- Universal compatibility (any DOCX)
- Double-column academic formatting
- Professional typography (Times New Roman)
- Automatic title extraction/removal
- Image support (all images fit column)
- Word formatting preservation
- Error-free compilation

---

**Perfect for academic papers, research documents, and professional reports!**

## Requirements.txt

See the included `requirements.txt` for a list of required packages and installation instructions. 