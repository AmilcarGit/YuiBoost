# YuiBoost CI

Este directorio contiene la automatización de calidad del proyecto mediante GitHub Actions.

## ¿Qué comprueba?

El workflow `ci.yml` ejecuta:

- Validación de archivos esenciales.
- Sintaxis Bash con `bash -n`.
- ShellCheck.
- Comprobación de ejecutables.
- Prueba de `./yui --help`.
- Detección básica de comandos destructivos.
- Detección básica de tokens/API keys expuestos.
- Validación del README.
- Validación de `SECURITY.md`.

## Seguridad

El workflow usa permisos mínimos:

```yaml
permissions:
  contents: read
```

No necesita secretos para ejecutar las comprobaciones normales.

## Dependabot

`dependabot.yml` mantiene actualizadas las GitHub Actions utilizadas por el proyecto.

## Resultado esperado

En GitHub Actions, una ejecución correcta debe terminar con:

```text
✓ Required files are present.
✓ Bash syntax is valid.
✓ Help command passed.
✓ No blocked destructive command pattern detected.
✓ No common hard-coded token pattern detected.
```

> Nota: el CI valida la calidad del código; no afirma que una optimización de Android mejore FPS. Las funciones de rendimiento deben probarse en dispositivos reales.
