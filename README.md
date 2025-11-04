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
   SecureAnon_Portable\Anon

2. Ejecuta:
   ejecutar_SecureAnon.bat

3. Archivos anonimizados se guardan en:
   SecureAnon_Portable\Anon\Limpios

4. Revisa los logs:
   • anon_log.txt  → detalle completo
   • anon_log.csv  → resumen por archivo

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

Autor: Equipo de Seguridad y Cumplimiento
Versión: 2.0 Portable
=======================================

