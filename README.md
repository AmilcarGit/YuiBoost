# 🌿 YuiBoost

Herramienta de optimización **real** para Android, ejecutada desde Termux.
Sin placebos, sin promesas falsas: cada acción que YuiBoost aplica es una
acción que realmente puede ejecutar Termux con los permisos disponibles —
y cuando no puede, te lo dice claramente en vez de fingir que lo hizo.

## Qué es YuiBoost

YuiBoost es un conjunto de scripts de Bash, pensados para Termux, que:

- **Diagnostican** tu dispositivo (Android, CPU, RAM, batería, temperatura,
  almacenamiento, permisos) usando solo lo que el sistema expone sin ROOT.
- **Limpian** de forma segura la caché propia de Termux, nunca tus archivos.
- **Miden** con un benchmark real (no inventado) si algo cambió.
- **Aplican** un puñado de optimizaciones legítimas — sync de disco, limpieza
  de paquetes, y el gobernador de CPU *solo si tienes ROOT* — y **registran**
  cada cambio para poder deshacerlo con `./yui restore`.

## Qué hace realmente

| Función | Sin ROOT/ADB | Con ROOT |
|---|---|---|
| Diagnóstico (Android, CPU, RAM, almacenamiento) | ✅ Completo | ✅ Completo |
| Temperatura | ✅ Si el kernel expone `/sys/class/thermal`, o con Termux:API | ✅ |
| Batería | ✅ Con Termux:API o `/sys/class/power_supply` | ✅ |
| Limpieza de caché de Termux | ✅ | ✅ |
| `sync` de disco | ✅ | ✅ |
| `apt-get clean` (paquetes de Termux) | ✅ | ✅ |
| Gobernador de CPU → `performance` | ❌ Se avisa y se omite | ✅ Se aplica y se registra |
| Benchmark CPU/disco/RAM antes-después | ✅ | ✅ |
| Restaurar cambios | ✅ | ✅ |

## Instalación

```bash
pkg update -y
pkg install git -y
git clone https://github.com/AmilcarGit/YuiBoost.git
cd YuiBoost
chmod +x yui
./yui
```

O usando el instalador, que además intenta dejar el comando `yui` disponible
desde cualquier carpeta:

```bash
./install.sh
```

Para desinstalar el enlace global (el repositorio no se borra solo):

```bash
./uninstall.sh
```

## Uso

```
🌿 YUI BOOST

 1. 🎮 Gaming
 2. ⚡ Optimizar
 3. 🧹 Limpiar
 4. 📊 Diagnóstico
 5. 🌡️  Temperatura
 6. 🔋 Batería
 7. 📈 Benchmark
 8. 🔄 Restaurar
 9. ⚙️  Configuración
 0. ❌ Salir
```

También puedes ejecutar acciones directamente:

```bash
./yui gaming
./yui optimize
./yui clean
./yui diagnostic
./yui temperature
./yui battery
./yui benchmark
./yui restore
```

## Filosofía

YuiBoost no es un "booster" mágico. Android impone límites importantes y
Termux no puede cambiar arbitrariamente el kernel, la GPU, la memoria física
o los procesos de otras aplicaciones.

Por eso el proyecto sigue estas reglas:

- ⚡ Solo aplicar cambios técnicamente posibles.
- 📊 Medir en lugar de inventar resultados.
- 🛡️ Detectar permisos antes de intentar operaciones avanzadas.
- 🔄 Registrar cambios y permitir restaurarlos cuando sea posible.
- 🔒 Mantener el funcionamiento local y minimizar la exposición de datos.
- 🚫 No descargar ni ejecutar scripts remotos desconocidos automáticamente.

## Modo Gaming

El modo Gaming prepara el entorno con las operaciones que realmente están
disponibles en el dispositivo. No promete FPS específicos ni overclocking
mágico.

Si una acción requiere ROOT o no está disponible, YuiBoost la omite y lo
indica claramente.

## Seguridad

YuiBoost evita operaciones destructivas y mantiene las modificaciones dentro
de rutas y capacidades permitidas.

Nunca debe utilizar comandos peligrosos como:

```bash
rm -rf /
```

Tampoco modifica `/system`, `/vendor`, `/data` ni particiones críticas sin una
implementación explícita, permisos adecuados, respaldo y validación.

Antes de una release se recomienda comprobar la sintaxis con:

```bash
bash -n yui
bash -n install.sh
bash -n uninstall.sh
```

Y, si está disponible:

```bash
shellcheck yui install.sh uninstall.sh
```

## Compatibilidad

Diseñado para Android con Termux. Algunas funciones dependen de la versión
de Android, fabricante, kernel y permisos disponibles.

- **Sin ROOT:** diagnóstico, limpieza propia de Termux y otras funciones
  disponibles desde el espacio de usuario.
- **Termux:API:** puede proporcionar información adicional del dispositivo.
- **ADB:** puede permitir operaciones adicionales si se configura de forma
  explícita.
- **ROOT:** habilita algunas operaciones avanzadas que YuiBoost detecta antes
  de intentar utilizar.

YuiBoost nunca debe asumir que ROOT, ADB o Termux:API están disponibles.

## Privacidad

El proyecto está diseñado para funcionar localmente. No necesita un servidor
remoto para sus funciones principales y no debe recopilar credenciales,
mensajes, contactos, fotos, vídeos, ubicación ni otros datos personales.

## Limitaciones reales

YuiBoost **no garantiza**:

- +100 FPS o porcentajes concretos de rendimiento.
- Menor ping automáticamente.
- Overclock de CPU/GPU.
- Más RAM física.
- Batería infinita.
- Eliminación segura del thermal throttling.
- Convertir un teléfono básico en uno de gama alta.

El resultado depende del hardware, GPU, CPU, temperatura, memoria, versión de
Android, controladores, resolución, configuración gráfica y carga del sistema.

## Estructura

```text
YuiBoost/
├── yui
├── install.sh
├── uninstall.sh
├── core/
│   ├── menu.sh
│   └── restore.sh
├── modules/
│   ├── gaming.sh
│   ├── optimize.sh
│   ├── cleanup.sh
│   ├── diagnostics.sh
│   ├── battery.sh
│   ├── temperature.sh
│   └── benchmark.sh
├── utils/
│   ├── colors.sh
│   ├── permissions.sh
│   ├── logging.sh
│   └── detection.sh
├── config/
├── backups/
├── logs/
├── README.md
├── CHANGELOG.md
├── SECURITY.md
└── LICENSE
```

## 🤝 Contribuir

Las contribuciones son bienvenidas. Antes de enviar cambios:

1. Prueba el código en Termux cuando sea posible.
2. No agregues comandos destructivos.
3. No presentes optimizaciones sin evidencia.
4. Documenta requisitos de ROOT/ADB/Termux:API.
5. Ejecuta ShellCheck cuando sea posible.
6. Mantén la interfaz y la documentación consistentes.

## 🐛 Reportar errores

Incluye, cuando sea posible:

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

No publiques credenciales ni información personal.

## 🗺️ Roadmap

### v0.1.x

- [x] CLI inicial
- [x] Diagnóstico
- [x] Detección de permisos
- [x] Limpieza segura
- [x] Sistema de logs
- [x] Restauración

### v0.2.x

- [x] Modo Gaming
- [x] Benchmark
- [x] Monitor de temperatura
- [ ] Integración opcional con Termux:API
- [ ] Mejor detección de Android

### v0.3.x

- [ ] Soporte avanzado ADB
- [ ] Perfiles configurables
- [ ] Comparaciones antes/después más completas
- [ ] Más pruebas en dispositivos reales

### v1.0.0

- [ ] API estable
- [ ] Documentación completa
- [ ] Compatibilidad ampliada
- [ ] Sistema de plugins cuidadosamente aislado

## 📜 Licencia

Este proyecto se distribuye bajo la licencia MIT. Consulta `LICENSE` para los
términos completos.

---

<p align="center">

### 🌿 YuiBoost

**Optimiza lo que se puede. Mide lo que cambia. No inventes resultados.**

`// ANDROID • TERMUX • REAL OPTIMIZATION //`

</p>
