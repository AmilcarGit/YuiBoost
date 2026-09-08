#!/usr/bin/env bash
# CÓDIGO ORIGINAL DE YUIBOOST

# Valores por defecto. El usuario puede editar este archivo directamente;
# YuiBoost no lo sobrescribe automáticamente.

: "${YUI_NO_COLOR:=0}"          # 1 = fuerza salida sin color
: "${YUI_BENCH_SIZE_MB:=16}"    # tamaño del archivo de prueba en el benchmark de disco
: "${YUI_CPU_BENCH_BOUND:=20000}" # límite superior de la criba de primos usada como referencia de CPU
