# Seguridad — YuiBoost

## Principios de diseño

- **Sin telemetría.** YuiBoost no envía información del dispositivo a ningún
  servidor. Todo se ejecuta y se registra localmente, dentro del propio
  repositorio (`logs/`, `backups/`).
- **Sin datos personales.** El proyecto nunca lee ni recopila IMEI, número
  telefónico, contactos, ubicación, mensajes, fotos ni archivos personales.
- **Rutas restringidas.** La limpieza (`modules/cleanup.sh`) solo actúa sobre
  una lista fija de directorios de caché propios de Termux
  (`$PREFIX/var/cache/apt/archives`, `$PREFIX/tmp`, `$HOME/.cache`). Nunca
  toca `/sdcard`, WhatsApp, fotos, vídeos o documentos.
- **Confirmación explícita.** Cualquier acción destructiva (borrar caché,
  cambiar el gobernador de CPU) muestra antes qué va a hacer y pide
  confirmación escrita ("si").
- **Nada de `rm -rf` sin control.** Los borrados usan `find ... -delete` /
  `-exec rm -f {} +` acotados con `-maxdepth`, nunca un `rm -rf` sobre una
  variable sin verificar.
- **Detección antes que acción.** Ninguna función asume que un comando o una
  ruta de `/sys` existe: primero comprueba (`command -v`, `[[ -r ... ]]`,
  `[[ -w ... ]]`) y solo entonces actúa.
- **ROOT nunca se fuerza.** `detect_root()` solo comprueba la presencia del
  binario `su`; YuiBoost nunca intenta elevar privilegios por su cuenta ni
  ejecuta `su -c` de forma oculta.
- **Reversible.** Todo cambio persistente (por ejemplo, el gobernador de CPU)
  se registra en `backups/changes.log` con fecha, ruta, valor anterior y
  valor nuevo, para poder deshacerse con `./yui restore`.
- **`set -uo pipefail`.** Los scripts usan variables no definidas y fallos en
  tuberías como errores. Se evita `set -e` global porque gran parte de la
  lógica de YuiBoost depende de que un comando falle limpiamente (por
  ejemplo, "esta ruta no existe") para decidir el siguiente paso — con `-e`
  esos casos abortarían el script en vez de mostrarse como un aviso.
- **Sin descargas ni ejecución remota.** El proyecto no descarga scripts de
  terceros para ejecutarlos. La única red que toca es la del propio
  `git clone` inicial.

## Reportar una vulnerabilidad

Si encuentras un problema de seguridad (por ejemplo, una ruta que escapa de
la lista blanca de limpieza, o un caso donde se aplica un cambio sin
comprobar permisos), abre un *issue* en el repositorio describiendo:

1. Pasos para reproducirlo.
2. Salida esperada vs. salida real.
3. Versión de Android/Termux donde ocurre.

No se aceptan reportes sobre "optimizaciones" que YuiBoost se niega a
simular (RAM x2, overclock, etc.) — ese comportamiento es intencional.
