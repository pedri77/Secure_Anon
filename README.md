# Secure_Anon
🔒 Sistema profesional de anonimización y limpieza de documentos

🛡️ SECUREANON RGPD - SISTEMA PORTABLE
=======================================

📦 OBJETIVO
------------
Herramienta profesional para anonimizar documentos 
conforme al Reglamento General de Protección de Datos (RGPD).

✅ FUNCIONES
------------
- Limpieza de metadatos (autor, empresa, software, fechas).
- Redacción automática de datos personales:
  • Nombres definidos en nombres.txt
  • DNIs / NIEs
  • Correos electrónicos
  • Números de teléfono
- Bloque negro opaco sobre cada coincidencia.
- Generación automática de logs (TXT y CSV).

📋 USO
-------
1. Coloca los documentos (.docx o .pdf) dentro de:
   SecureAnon_\Anon

2. Ejecuta:
   ejecutar_SecureAnon.bat

3. Archivos anonimizados se guardan en:
   SecureAnon_Portable\Anon\Limpios

4. Revisa los logs:
   • anon_log.txt  → detalle completo
   • anon_log.csv  → resumen por archivo

   C:\Anon\
   ├── documento1.docx
   ├── documento2.pdf
   ├── limpiar.ps1       ← script principal
   ├── redactar.py       ← script Python auxiliar
   └── nombres.txt       ← lista de nombres propios a borrar (uno por línea)


🧩 REQUISITOS
-------------
- Windows 10/11
- Python 3.8 o superior
- Librerías Python:
  pikepdf, pymupdf, python-docx
  (el script las instala automáticamente)

  python -m pip install pikepdf pymupdf python-docx

🧠 CONSEJO
-----------
Puedes ejecutar SecureAnon desde:
- Pendrive USB
- Carpeta de red
- OneDrive o Google Drive sincronizado

⚖️ CUMPLIMIENTO
---------------
El sistema trabaja localmente, sin conexión ni envío de datos.
Cumple los principios RGPD de minimización y privacidad por diseño.

Cómo usarlo
-------------------
Guarda los tres ficheros (limpiar.ps1, redactar.py, nombres.txt) dentro de C:\Anon.

Copia tus documentos .docx y .pdf dentro de esa carpeta.

Abre PowerShell:

cd C:\Anon
.\limpiar.ps1


Resultado → C:\Anon\Limpios con archivos limpios y redactados.
Verás mensajes tipo:

✓ Limpio DOCX: contrato.docx
✓ Redactado contrato.docx
✓ Limpio PDF: informe.pdf
✓ Redactado informe.pdf

Autor: David Moya García
Versión: 2.0 Portable
=======================================

Qué se elimina / sustituye

| Tipo de dato                              | Acción                              |
| ----------------------------------------- | ----------------------------------- |
| Autor, empresa, fechas, software, etc.    | Eliminados (metadatos)              |
| Correos electrónicos                      | `[REDACTADO]` o bloque negro en PDF |
| DNIs / NIEs                               | `[REDACTADO]`                       |
| Teléfonos                                 | `[REDACTADO]`                       |
| Nombres propios del fichero `nombres.txt` | `[REDACTADO]`                       |

