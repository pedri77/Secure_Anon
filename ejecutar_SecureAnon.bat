@echo off
title SecureAnon RGPD Portable
color 0B
echo ====================================================
echo     🛡️  SECUREANON RGPD - SISTEMA PORTABLE
echo ====================================================
echo.

setlocal
set ROOT=%~dp0
cd /d "%ROOT%"

REM --- Comprobar Python ---
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] No se detecta Python en este equipo.
    echo Instala Python 3.8+ desde https://www.python.org/downloads/
    pause
    exit /b
)

echo [OK] Python detectado.
echo [INFO] Verificando librerias necesarias...
python -m pip install --quiet pikepdf pymupdf python-docx

echo [OK] Librerias listas.
if not exist "%ROOT%\Anon" mkdir "%ROOT%\Anon"
if not exist "%ROOT%\Anon\Limpios" mkdir "%ROOT%\Anon\Limpios"

echo.
echo ====================================================
echo Procesando documentos en: %ROOT%\Anon
echo ====================================================

powershell -ExecutionPolicy Bypass -Command "& {
Add-Type -AssemblyName System.IO.Compression.FileSystem;
$root = '%ROOT%Anon';
$outdir = Join-Path $root 'Limpios';
$files = Get-ChildItem -Path $root -File -Include *.docx,*.pdf;
foreach ($f in $files) {
    $out = Join-Path $outdir $f.Name;
    if ($f.Extension -ieq '.docx') {
        $tmpdir = Join-Path $env:TEMP ([IO.Path]::GetRandomFileName());
        New-Item -ItemType Directory -Path $tmpdir | Out-Null;
        $zipTemp = Join-Path $tmpdir 'file.zip';
        Copy-Item $f.FullName $zipTemp;
        [System.IO.Compression.ZipFile]::ExtractToDirectory($zipTemp, (Join-Path $tmpdir 'ex'));
        Remove-Item (Join-Path $tmpdir 'ex\docProps') -Recurse -Force -ErrorAction SilentlyContinue;
        Remove-Item (Join-Path $tmpdir 'ex\customXml') -Recurse -Force -ErrorAction SilentlyContinue;
        $newZip = Join-Path $tmpdir 'new.zip';
        [System.IO.Compression.ZipFile]::CreateFromDirectory((Join-Path $tmpdir 'ex'), $newZip);
        Copy-Item $newZip $out -Force;
        Remove-Item $tmpdir -Recurse -Force -ErrorAction SilentlyContinue;
        Write-Host ('✓ Limpio DOCX: ' + $f.Name);
    }
    elseif ($f.Extension -ieq '.pdf') {
        $scriptPy = '@
import pikepdf, sys
pdf = pikepdf.Pdf.open(sys.argv[1])
pdf.docinfo.clear()
if '/Metadata' in pdf.root: del pdf.root['/Metadata']
pdf.save(sys.argv[2])
pdf.close()
@';
        $t = '$env:TEMP\cleanpdf.py';
        Set-Content -Path $t -Value $scriptPy -Encoding utf8;
        & python $t $f.FullName $out;
        Remove-Item $t -Force;
        Write-Host ('✓ Limpio PDF: ' + $f.Name);
    }
    & python '%ROOT%redactar.py' $out $out;
}
Write-Host ('`n🟢 Procesamiento completado. Limpios en: ' + $outdir);
}"

echo.
echo ====================================================
echo SecureAnon RGPD finalizado correctamente.
echo Logs disponibles en Anon\Limpios\anon_log.txt y .csv
echo ====================================================
pause
