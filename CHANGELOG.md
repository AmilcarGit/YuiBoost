# Changelog

Todas las versiones notables de este proyecto se documentan aquí.
Formato basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

## [1.0.0] - 2026-09-08

### Añadido
- Primera versión pública de YuiBoost.
- Diagnóstico completo del dispositivo (Android, RAM, CPU, temperatura, batería, almacenamiento, permisos).
- Modo Gaming con flujo de 7 pasos: diagnóstico previo, registro de cambios planeados, comprobación de permisos, aplicación de solo lo permitido, resumen, diagnóstico posterior y comparación.
- Optimización general (sync, limpieza de paquetes, gobernador de CPU con ROOT).
- Limpieza segura restringida a rutas de caché propias de Termux, con confirmación previa.
- Monitor de temperatura vía `/sys/class/thermal` y Termux:API.
- Información de batería vía Termux:API o `/sys/class/power_supply`.
- Benchmark antes/después con mediciones reales de CPU, disco y RAM.
- Sistema de restauración (`./yui restore`) basado en un registro de cambios con valor anterior y nuevo.
- Detección de ROOT, ADB (adbd), Termux:API y acceso a almacenamiento.
- Instalador (`install.sh`) y desinstalador (`uninstall.sh`).
- Soporte para `--no-color` y variable de entorno `NO_COLOR`.
