<#
limpiar.ps1
Anonimiza PDF y DOCX en la carpeta C:\Anon
- Limpia metadatos
- Redacta nombres, DNIs, correos y teléfonos
- Usa patrones definidos y nombres.txt
#>

# --- Configuración ---
$root = "C:\Anon"
$outdir = Join-Path $root "Limpios"
if (-not (Test-Path $outdir)) { New-Item -ItemType Directory -Path $outdir | Out-Null }

Add-Type -AssemblyName System.IO.Compression.FileSystem

# --- Función: Limpieza metadatos DOCX ---
function Limpiar-Docx {
    param($file,$out)
    $temp = Join-Path $env:TEMP ([IO.Path]::GetRandomFileName())
    New-Item -ItemType Directory -Path $temp | Out-Null
    $zipTemp = "$temp\doc.zip"
    Copy-Item $file $zipTemp -Force
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipTemp,"$temp\ex")

    $rutasBorrar = @(
        "$temp\ex\docProps",
        "$temp\ex\customXml",
        "$temp\ex\word\comments.xml",
        "$temp\ex\word\commentsExtended.xml"
    )

    foreach ($p in $rutasBorrar) {
        Get-ChildItem -Path $p -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }

    $newZip = "$temp\new.zip"
    [System.IO.Compression.ZipFile]::CreateFromDirectory("$temp\ex", $newZip)
    Copy-Item $newZip $out -Force

    Remove-Item -Recurse -Force $temp -ErrorAction SilentlyContinue
    Write-Host "✓ Limpio DOCX: $($file.Name)"
}

# --- Función: Limpieza metadatos PDF ---
function Limpiar-PDF {
    param($file,$out)
    $scriptPy = @"
import pikepdf, sys
src, dst = sys.argv[1], sys.argv[2]
pdf = pikepdf.Pdf.open(src)
pdf.docinfo.clear()
if '/Metadata' in pdf.root: del pdf.root['/Metadata']
pdf.save(dst)
pdf.close()
"@
    $tempPy = "$env:TEMP\cleanpdf.py"
    Set-Content -Path $tempPy -Value $scriptPy -Encoding utf8
    & python $tempPy $file.FullName $out
    Remove-Item $tempPy -Force
    Write-Host "✓ Limpio PDF: $($file.Name)"
}

# --- Función: Redacción de texto sensible ---
function Redactar-Texto {
    param($file,$out)
    & python "$root\redactar.py" $file $out
}

# --- Proceso principal ---
$archivos = Get-ChildItem -Path $root -File -Include *.docx,*.pdf

foreach ($f in $archivos) {
    $outFile = Join-Path $outdir $f.Name

    if ($f.Extension -ieq ".docx") {
        Limpiar-Docx -file $f -out $outFile
        Redactar-Texto -file $outFile -out $outFile
    }
    elseif ($f.Extension -ieq ".pdf") {
        Limpiar-PDF -file $f -out $outFile
        Redactar-Texto -file $outFile -out $outFile
    }
}

Write-Host "`n✓ Todos los archivos se han anonimizado y guardado en $outdir"
