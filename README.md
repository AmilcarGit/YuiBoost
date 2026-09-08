# 🌿 YuiBoost

<p align="center">
  <img src="assets/yuiboost-cover.png" alt="YuiBoost" width="100%">
</p>

<p align="center">
  <strong>Optimización real para Android desde Termux.</strong><br>
  Sin promesas falsas. Sin telemetría. Con cambios medibles y reversibles.
</p>

<p align="center">
  <a href="#-características">Características</a> •
  <a href="#-instalación">Instalación</a> •
  <a href="#-uso">Uso</a> •
  <a href="#-seguridad">Seguridad</a> •
  <a href="#-limitaciones">Limitaciones</a>
</p>

---

## ✨ ¿Qué es YuiBoost?

**YuiBoost** es una herramienta de línea de comandos para **Android + Termux** enfocada en diagnóstico, mantenimiento y optimización segura.

El proyecto está diseñado con una regla fundamental:

> **Si una optimización no puede demostrarse o Android no permite aplicarla con los permisos disponibles, YuiBoost no fingirá que funciona.**

YuiBoost detecta las capacidades del dispositivo antes de ejecutar acciones y diferencia claramente entre funciones disponibles con permisos normales, **Termux:API**, **ADB** o **ROOT**.

### 🎯 Filosofía

- ⚡ Optimizar lo que realmente puede optimizarse.
- 📊 Medir antes y después cuando sea posible.
- 🛡️ No tocar partes críticas del sistema sin autorización.
- 🔄 Poder revertir los cambios realizados.
- 🔒 No recopilar información personal.
- 🚫 No vender humo con supuestos "boosters" mágicos.

---

## 🚀 Características

| Función | Descripción |
|---|---|
| 🎮 Gaming | Perfil de mantenimiento y optimización compatible con los permisos disponibles |
| ⚡ Optimización | Revisión y aplicación de ajustes seguros |
| 🧹 Limpieza | Limpieza controlada de archivos temporales accesibles |
| 📊 Diagnóstico | Estado del dispositivo, CPU, RAM, batería y almacenamiento |
| 🌡️ Temperatura | Lectura de temperatura cuando Android/Termux la expone |
| 🔋 Batería | Nivel, estado y datos disponibles |
| 🧠 CPU/RAM | Información del hardware y memoria |
| 📈 Benchmark | Comparación de métricas antes/después |
| 🛡️ Permisos | Detección de ROOT, ADB y capacidades disponibles |
| 🔄 Restauración | Registro y recuperación de cambios realizados |

---

## 📱 Compatibilidad

Diseñado para:

- Android moderno
- Termux
- Arquitecturas ARM/ARM64 y otras soportadas por Termux
- Dispositivos con o sin ROOT

Algunas funciones dependen directamente de la versión de Android, fabricante y permisos disponibles.

### 🔐 Niveles de acceso

**Sin ROOT**

Funciones normales de Termux y diagnóstico.

**Termux:API**

Permite acceder a información adicional del dispositivo cuando la aplicación complementaria está instalada y autorizada.

**ADB**

Puede habilitar operaciones adicionales que Android no permite desde un Termux normal.

**ROOT**

Permite operaciones avanzadas, pero YuiBoost debe detectarlo explícitamente antes de intentar utilizarlas.

> YuiBoost nunca debe asumir que ROOT o ADB existen.

---

# 📥 Instalación

## Método recomendado

Instala Termux desde una fuente confiable y abre una sesión.

Después:

```bash
pkg update -y
pkg upgrade -y
pkg install git -y

git clone https://github.com/AmilcarGit/YuiBoost.git
cd YuiBoost

chmod +x yui install.sh
./install.sh
```

Después de la instalación:

```bash
yui
```

También puedes ejecutar directamente:

```bash
./yui
```

---

# 🎮 Uso

Al iniciar YuiBoost aparecerá el menú principal:

```text
╭────────────────────────────────────╮
│          🌿 YUI BOOST ⚡            │
│       Android Optimization CLI      │
╰────────────────────────────────────╯

  [1] 🎮 Modo Gaming
  [2] ⚡ Optimizar
  [3] 🧹 Limpiar
  [4] 📊 Diagnóstico
  [5] 🌡️ Temperatura
  [6] 🔋 Batería
  [7] 📈 Benchmark
  [8] 🔄 Restaurar
  [9] ⚙️ Configuración
  [0] ❌ Salir
```

---

## 🩺 Diagnóstico

Antes de modificar nada puedes ejecutar:

```bash
yui diagnostic
```

El diagnóstico puede mostrar, cuando el sistema lo permite:

```text
📱 Dispositivo
Android: 15
Arquitectura: arm64

🧠 Memoria
RAM total: ...
RAM disponible: ...

⚙️ CPU
Núcleos: ...
Arquitectura: ...

🌡️ Temperatura
Estado: ...

🔋 Batería
Nivel: ...

🛡️ Permisos
ROOT: ❌
ADB: ❌
Termux: ✓
```

Los valores reales dependen de lo que Android exponga al entorno.

---

# 🎮 Modo Gaming

```bash
yui gaming
```

El modo Gaming está pensado para preparar el entorno de forma segura.

YuiBoost **no promete aumentar mágicamente los FPS**.

Puede realizar únicamente acciones que:

1. Sean compatibles con el dispositivo.
2. Estén disponibles con los permisos actuales.
3. No comprometan procesos críticos.
4. Puedan registrarse correctamente.
5. Sean reversibles cuando corresponda.

Si una función necesita ROOT o ADB:

```text
⚠ ROOT/ADB requerido

No se aplicó esta modificación.
```

Eso es intencional.

---

# 🧹 Limpieza segura

```bash
yui clean
```

Antes de eliminar archivos, YuiBoost debe:

1. Identificar la ruta.
2. Calcular el tamaño.
3. Mostrar lo que será eliminado.
4. Solicitar confirmación.
5. Ejecutar únicamente rutas permitidas.

### 🚫 Nunca debe eliminar automáticamente

- Fotos
- Vídeos
- Documentos
- Contactos
- Mensajes
- Bases de datos personales
- Aplicaciones
- Carpetas de WhatsApp
- Archivos fuera de las rutas permitidas

---

# 📈 Benchmark

Ejecuta:

```bash
yui benchmark
```

La idea es comparar métricas reales:

```text
╭────────────── BENCHMARK ──────────────╮

ANTES
CPU        : ...
RAM        : ...
Temperatura: ...
Storage    : ...

Aplicando operaciones...

DESPUÉS
CPU        : ...
RAM        : ...
Temperatura: ...
Storage    : ...

Resultado:
✓ Datos recopilados correctamente
```

Si no existe una diferencia significativa:

```text
Sin mejora significativa detectada.
```

**No se inventan porcentajes.**

---

# 🔄 Restauración

Antes de realizar modificaciones, YuiBoost debe registrar los valores originales cuando sea técnicamente posible.

Para restaurar:

```bash
yui restore
```

También puede existir:

```bash
./restore.sh
```

Si no existen cambios registrados:

```text
✓ No hay cambios para restaurar.
```

---

# 🛡️ Seguridad

YuiBoost está pensado para ser una herramienta de mantenimiento, no un script destructivo.

### Principios de seguridad

- Validación de argumentos.
- Validación de comandos disponibles.
- Detección de ROOT.
- Detección de ADB.
- Backups antes de modificaciones.
- Registro de operaciones.
- Rutas permitidas para limpieza.
- Sin ejecución de código remoto desconocido.
- Sin descarga y ejecución automática de scripts externos.
- Sin modificaciones silenciosas.
- Confirmación antes de operaciones destructivas.
- Restauración de cambios cuando sea posible.

### 🚫 No hacer

YuiBoost no debe utilizar:

```bash
rm -rf /
```

ni variantes peligrosas.

Tampoco debe modificar:

- `/system`
- `/vendor`
- `/data`
- particiones críticas
- configuraciones de seguridad

sin una implementación explícita, permisos adecuados, backup y validación.

---

# 🔒 Privacidad

YuiBoost está diseñado para funcionar localmente.

No debe recopilar ni enviar:

- IMEI
- número telefónico
- contactos
- mensajes
- fotos
- vídeos
- ubicación
- archivos personales

Tampoco necesita un servidor remoto para realizar sus funciones principales.

---

# ❗ Limitaciones reales

Android tiene restricciones importantes.

YuiBoost **NO puede garantizar**:

- +100 FPS
- +200% de rendimiento
- Menor ping automáticamente
- Overclock de CPU
- Overclock de GPU
- Más RAM física
- Batería infinita
- Eliminar el thermal throttling sin consecuencias
- Convertir un teléfono básico en uno de gama alta

### ¿Por qué?

Porque muchas de esas funciones requieren acceso que una aplicación normal o Termux no posee.

Además, el rendimiento de un juego depende de factores como:

- GPU
- CPU
- temperatura
- memoria
- optimización del juego
- versión de Android
- controladores
- resolución
- configuración gráfica
- carga del sistema

Por eso YuiBoost prioriza **mediciones reales sobre promesas**.

---

# 🧪 Calidad del proyecto

Antes de cada release se recomienda ejecutar:

```bash
bash -n yui
bash -n install.sh
bash -n restore.sh
```

Si `shellcheck` está instalado:

```bash
shellcheck yui
shellcheck install.sh
shellcheck restore.sh
```

Y probar:

```bash
./yui --help
./yui diagnostic
```

Las pruebas deben realizarse en un dispositivo Android/Termux real además de cualquier entorno de desarrollo.

---

# 📂 Estructura recomendada

```text
YuiBoost/
├── yui
├── install.sh
├── uninstall.sh
├── restore.sh
│
├── core/
│   └── ...
│
├── modules/
│   ├── gaming.sh
│   ├── optimize.sh
│   ├── cleanup.sh
│   ├── diagnostics.sh
│   ├── battery.sh
│   ├── temperature.sh
│   └── benchmark.sh
│
├── utils/
│   ├── colors.sh
│   ├── permissions.sh
│   ├── logging.sh
│   └── detection.sh
│
├── config/
├── backups/
├── logs/
│
├── assets/
│   └── yuiboost-cover.png
│
├── README.md
├── CHANGELOG.md
├── SECURITY.md
└── LICENSE
```

---

# 🌿 Estilo Yui

YuiBoost utiliza una identidad visual inspirada en:

```text
🌿 Naturaleza
🦋 Yui
⚡ Tecnología
💻 Termux
🎮 Gaming
🛡️ Seguridad
```

La interfaz debe mantenerse sencilla, rápida y agradable incluso en terminales pequeñas.

---

# 🤝 Contribuir

Las contribuciones son bienvenidas.

Antes de enviar un Pull Request:

1. Prueba el código.
2. Comprueba compatibilidad con Termux.
3. No agregues comandos destructivos.
4. No agregues "optimizaciones" sin evidencia.
5. Documenta requisitos de ROOT/ADB.
6. Ejecuta ShellCheck cuando sea posible.
7. Mantén la interfaz consistente.

---

# 🐛 Reportar errores

Al reportar un problema incluye, si es posible:

```text
Android:
Fabricante:
Modelo:
Versión de Termux:
Arquitectura:
ROOT:
ADB:
Comando ejecutado:
Mensaje de error:
```

Nunca publiques información personal o credenciales.

---

# 🗺️ Roadmap

## v0.1.x

- [x] CLI inicial
- [ ] Diagnóstico
- [ ] Detección de permisos
- [ ] Limpieza segura
- [ ] Sistema de logs
- [ ] Restauración

## v0.2.x

- [ ] Modo Gaming
- [ ] Benchmark
- [ ] Monitor de temperatura
- [ ] Integración opcional con Termux:API
- [ ] Mejor detección de Android

## v0.3.x

- [ ] Soporte avanzado ADB
- [ ] Perfiles configurables
- [ ] Comparaciones antes/después
- [ ] Más pruebas en dispositivos reales

## v1.0.0

- [ ] API estable
- [ ] Documentación completa
- [ ] Compatibilidad ampliada
- [ ] Sistema de plugins cuidadosamente aislado

---

# 📜 Licencia

Este proyecto se distribuirá bajo la licencia indicada en `LICENSE`.

Consulta el archivo `LICENSE` antes de redistribuir o modificar el proyecto.

---

# ⚠️ Aviso

YuiBoost es una herramienta de mantenimiento y diagnóstico.

El rendimiento final depende del hardware, Android, temperatura, aplicaciones y juegos utilizados.

**Ninguna función debe presentarse como garantía de aumento de FPS, potencia o duración de batería.**

---

<p align="center">

### 🌿 YuiBoost

**Optimiza lo que se puede. Mide lo que cambia. No inventes resultados.**

`// ANDROID • TERMUX • REAL OPTIMIZATION //`

</p>
