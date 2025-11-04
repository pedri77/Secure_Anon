# clean_pdf.py
# pip install pikepdf pymupdf
import sys
import pikepdf
import fitz  # pymupdf
import re

def strip_metadata(infile, outfile):
    # Remove all metadata (Info and XMP)
    pdf = pikepdf.Pdf.open(infile)
    pdf.docinfo.clear()
    try:
        if '/Metadata' in pdf.root:
            del pdf.root['/Metadata']
    except Exception:
        pass
    pdf.save(outfile, linearize=True)
    pdf.close()

def redact_regex(infile, outfile, patterns):
    doc = fitz.open(infile)
    for page in doc:
        text = page.get_text("text")
        for pat in patterns:
            for m in re.finditer(pat, text, flags=re.IGNORECASE):
                # get quads/rects of matches
                areas = page.search_for(m.group(0))
                for r in areas:
                    page.add_redact_annot(r, fill=(0,0,0))  # black redact
        page.apply_redactions()
    doc.save(outfile)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Uso: python clean_pdf.py input.pdf output.pdf")
        sys.exit(1)
    inp = sys.argv[1]; out = sys.argv[2]
    tmp = out + ".tmp.pdf"
    strip_metadata(inp, tmp)
    # ejemplo patrones a redactar: correos y DNI (ajusta regex)
    patterns = [r"\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b", r"\b\d{8}[A-Z]\b"]
    redact_regex(tmp, out, patterns)
    print("Hecho:", out)
