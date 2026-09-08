#!/usr/bin/env bash
# CÓDIGO ORIGINAL DE YUIBOOST

YUI_BENCH_TMP="${YUI_HOME:-.}/logs/.bench_tmp"

# CPU: counts primes below a fixed bound and reports elapsed milliseconds.
# Lower is faster. Pure bash + awk, no external dependency required.
_bench_cpu_ms() {
    local bound="${YUI_CPU_BENCH_BOUND:-20000}"
    local start end
    start="$(date +%s%N)"
    awk -v n="$bound" 'BEGIN{
        count=0
        for (i=2; i<=n; i++) {
            is_prime=1
            for (j=2; j*j<=i; j++) { if (i%j==0){ is_prime=0; break } }
            if (is_prime) count++
        }
        print count
    }' > /dev/null
    end="$(date +%s%N)"
    printf '%d' $(( (end - start) / 1000000 ))
}

# Storage: writes then reads a 16 MB temp file, reports MB/s for each (0 if it fails).
_bench_storage() {
    local size_mb="${YUI_BENCH_SIZE_MB:-16}"
    local file="$YUI_BENCH_TMP.dat"
    mkdir -p "$(dirname "$file")" 2>/dev/null
    local start end write_ms read_ms write_mbs read_mbs

    start="$(date +%s%N)"
    if ! dd if=/dev/zero of="$file" bs=1M count="$size_mb" conv=fsync 2>/dev/null; then
        rm -f "$file" 2>/dev/null
        printf '0 0'
        return
    fi
    end="$(date +%s%N)"
    write_ms=$(( (end - start) / 1000000 ))
    [[ "$write_ms" -le 0 ]] && write_ms=1
    write_mbs="$(awk -v s="$size_mb" -v ms="$write_ms" 'BEGIN{printf "%.1f", (s*1000)/ms}')"

    sync 2>/dev/null
    start="$(date +%s%N)"
    dd if="$file" of=/dev/null bs=1M 2>/dev/null
    end="$(date +%s%N)"
    read_ms=$(( (end - start) / 1000000 ))
    [[ "$read_ms" -le 0 ]] && read_ms=1
    read_mbs="$(awk -v s="$size_mb" -v ms="$read_ms" 'BEGIN{printf "%.1f", (s*1000)/ms}')"

    rm -f "$file" 2>/dev/null
    printf '%s %s' "$write_mbs" "$read_mbs"
}

# Prints "cpu_ms write_mbs read_mbs ram_avail_kb temp"
_bench_measure() {
    local cpu_ms write_mbs read_mbs ram_avail temp_line
    cpu_ms="$(_bench_cpu_ms)"
    read -r write_mbs read_mbs <<< "$(_bench_storage)"
    read -r _ ram_avail <<< "$(detect_ram_raw)"
    temp_line="$(detect_temperature | head -1 | grep -oE '[0-9]+(\.[0-9]+)?°C' | head -1)"
    printf '%s %s %s %s %s' "$cpu_ms" "$write_mbs" "$read_mbs" "$ram_avail" "${temp_line:-N/A}"
}

_bench_print_block() {
    local label="$1" cpu_ms="$2" write_mbs="$3" read_mbs="$4" ram_avail="$5" temp="$6"
    printf '%s\n' "$label"
    printf '  CPU (20k primos): %s ms\n' "$cpu_ms"
    printf '  Almacenamiento: %s MB/s escritura, %s MB/s lectura\n' "$write_mbs" "$read_mbs"
    printf '  RAM disponible: %s\n' "$(_kb_to_human "$ram_avail")"
    printf '  Temperatura: %s\n' "$temp"
}

run_benchmark() {
    yui_title "📈 YUI BENCHMARK"
    echo
    yui_info "Ejecutando medición ANTES..."
    local before
    before="$(_bench_measure)"
    read -r b_cpu b_write b_read b_ram b_temp <<< "$before"
    echo
    _bench_print_block "ANTES" "$b_cpu" "$b_write" "$b_read" "$b_ram" "$b_temp"

    echo
    yui_info "Puedes ejecutar 'Optimizar' o 'Limpiar' ahora en otra sesión, o simplemente"
    yui_info "esperar. Pulsa ENTER cuando quieras medir DESPUÉS (o 'q' para salir)."
    read -r -p "> " answer
    if [[ "$answer" == "q" ]]; then
        yui_info "Benchmark cancelado."
        return 0
    fi

    yui_info "Ejecutando medición DESPUÉS..."
    local after
    after="$(_bench_measure)"
    read -r a_cpu a_write a_read a_ram a_temp <<< "$after"
    echo
    _bench_print_block "DESPUÉS" "$a_cpu" "$a_write" "$a_read" "$a_ram" "$a_temp"
    echo

    local cpu_delta_ms=$(( b_cpu - a_cpu ))
    local ram_delta_kb=$(( a_ram - b_ram ))
    local improved=0

    if [[ "$cpu_delta_ms" -gt 20 ]]; then
        yui_ok "CPU: ${cpu_delta_ms} ms más rápido en la prueba de referencia"
        improved=1
    elif [[ "$cpu_delta_ms" -lt -20 ]]; then
        yui_warn "CPU: $(( -cpu_delta_ms )) ms más lento (posible carga concurrente del sistema)"
    fi

    if [[ "$ram_delta_kb" -gt 51200 ]]; then
        yui_ok "RAM: +$(_kb_to_human "$ram_delta_kb") disponible"
        improved=1
    elif [[ "$ram_delta_kb" -lt -51200 ]]; then
        yui_warn "RAM: -$(_kb_to_human $(( -ram_delta_kb ))) disponible"
    fi

    if [[ "$improved" -eq 0 ]]; then
        yui_info "Sin mejora significativa detectada."
    fi
    yui_log "BENCHMARK" "before=[$before] after=[$after]"
    echo
}
