# pip install Pillow pikepdf
from PIL import Image
import os
import pikepdf

def strip_image_exif(infile, outfile):
    img = Image.open(infile)
    data = list(img.getdata())
    image_no_exif = Image.new(img.mode, img.size)
    image_no_exif.putdata(data)
    image_no_exif.save(outfile)

def strip_pdf_metadata(infile, outfile):
    pdf = pikepdf.Pdf.open(infile)
    pdf.docinfo.clear()
    if '/Metadata' in pdf.root:
        del pdf.root['/Metadata']
    pdf.save(outfile)
    pdf.close()

# ejemplo uso:
# strip_image_exif("entrada.jpg","salida.jpg")
# strip_pdf_metadata("entrada.pdf","salida.pdf")
