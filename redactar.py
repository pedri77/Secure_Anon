# redactar.py
import sys, re, os
import fitz  # pymupdf
import pikepdf
from docx import Document

root = os.path.dirname(os.path.abspath(__file__))
nombres_path = os.path.join(root, "nombres.txt")

# --- patrones base ---
patterns = [
    r"\b\d{8}[A-Z]\b",                     # DNI
    r"\b\d{9}[A-Z]\b",                     # NIE o similar
    r"[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}",  # email
    r"\b(\+34|0034|34)?[6-9]\d{8}\b"       # teléfono español
]

# Añadir nombres del fichero
if os.path.exists(nombres_path):
    with open(nombres_path, "r", encoding="utf-8") as f:
        for line in f:
            name = line.strip()
            if name:
                # Escapar para regex
                patterns.append(re.escape(name))

def redact_pdf(src, dst):
    doc = fitz.open(src)
    for page in doc:
        text = page.get_text("text")
        for pat in patterns:
            for m in re.finditer(pat, text, flags=re.IGNORECASE):
                areas = page.search_for(m.group(0))
                for r in areas:
                    page.add_redact_annot(r, fill=(0,0,0))
        page.apply_redactions()
    doc.save(dst)
    doc.close()

def redact_docx(src, dst):
    doc = Document(src)
    for p in doc.paragraphs:
        for pat in patterns:
            if re.search(pat, p.text, re.IGNORECASE):
                p.text = re.sub(pat, "[REDACTADO]", p.text, flags=re.IGNORECASE)
    doc.save(dst)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Uso: python redactar.py input output")
        sys.exit(1)
    src, dst = sys.argv[1], sys.argv[2]
    ext = os.path.splitext(src)[1].lower()
    try:
        if ext == ".pdf":
            redact_pdf(src, dst)
        elif ext == ".docx":
            redact_docx(src, dst)
        print(f"✓ Redactado {os.path.basename(src)}")
    except Exception as e:
        print(f"Error redactando {src}: {e}")
