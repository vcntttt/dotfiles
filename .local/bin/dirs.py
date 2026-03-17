#!/usr/bin/env python3

import re
import sys
import unicodedata
from pathlib import Path


SEMESTRES = {
    1: ("1er-semestre", "1er-Semestre"),
    2: ("2do-semestre", "2do-Semestre"),
    3: ("3er-Semestre", "3er-Semestre"),
    4: ("4to-Semestre", "4to-Semestre"),
    5: ("5to-Semestre", "5to-Semestre"),
    6: ("6to-Semestre", "6to-Semestre"),
    7: ("7mo-Semestre", "7mo-Semestre"),
    8: ("8vo-Semestre", "8vo-Semestre"),
    9: ("9no-Semestre", "9no-Semestre"),
    10: ("10mo-Semestre", "10mo-Semestre"),
}

FILES_DIR = Path.home() / "Nextcloud" / "informatica"
NOTES_ROOT = Path.home() / "Notas" / "200 - UCT"


def pedir_entero(mensaje):
    while True:
        valor = input(mensaje).strip()
        try:
            return int(valor)
        except ValueError:
            print("Ingresa un número válido.")


def pedir_texto(mensaje):
    while True:
        valor = input(mensaje).strip()
        if valor:
            return valor
        print("El valor no puede estar vacío.")


def slugify(texto):
    texto_normalizado = unicodedata.normalize("NFKD", texto)
    texto_ascii = texto_normalizado.encode("ascii", "ignore").decode("ascii")
    texto_limpio = texto_ascii.lower().strip()
    texto_limpio = re.sub(r"[^a-z0-9]+", "-", texto_limpio)
    return texto_limpio.strip("-")


def crear_symlink_notas(carpeta_principal, destino_notas):
    carpeta_notas = carpeta_principal / "Notas"

    if carpeta_notas.is_symlink():
        destino_actual = carpeta_notas.resolve()
        if destino_actual == destino_notas.resolve():
            print(f"  - Symlink ya existe: {carpeta_notas}")
        else:
            print(
                f"  - Aviso: {carpeta_notas} ya apunta a otra ruta ({destino_actual})."
            )
        return

    if carpeta_notas.exists():
        print(f"  - Aviso: {carpeta_notas} ya existe y no es un symlink. Se omite.")
        return

    carpeta_notas.symlink_to(destino_notas, target_is_directory=True)
    print(f"  - Symlink creado: {carpeta_notas} -> {destino_notas}")


def main():
    semestre_numero = pedir_entero("Ingrese el número del semestre: ")
    semestre_dirs = SEMESTRES.get(semestre_numero)
    if semestre_dirs is None:
        print("Número de semestre inválido.")
        sys.exit(1)

    files_semestre, notes_semestre = semestre_dirs
    files_semestre_dir = FILES_DIR / files_semestre
    notes_semestre_dir = NOTES_ROOT / notes_semestre

    files_semestre_dir.mkdir(parents=True, exist_ok=True)
    notes_semestre_dir.mkdir(parents=True, exist_ok=True)

    num_ramos = pedir_entero("¿Cuántos ramos hay? ")

    for indice in range(1, num_ramos + 1):
        print(f"\nRamo {indice} de {num_ramos}")

        nombre_visible = pedir_texto("Nombre del ramo para Notas: ")
        slug_sugerido = slugify(nombre_visible)
        slug_ingresado = input(f"Slug para Nextcloud [{slug_sugerido}]: ").strip()
        slug_ramo = slug_ingresado or slug_sugerido

        if not slug_ramo:
            print("No se pudo generar un slug válido. Se omite este ramo.")
            continue

        carpeta_principal = files_semestre_dir / slug_ramo
        carpeta_principal.mkdir(parents=True, exist_ok=True)
        print(f"  - Carpeta principal: {carpeta_principal}")

        carpeta_notas_destino = notes_semestre_dir / nombre_visible
        carpeta_notas_destino.mkdir(parents=True, exist_ok=True)
        print(f"  - Carpeta notas: {carpeta_notas_destino}")

        crear_symlink_notas(carpeta_principal, carpeta_notas_destino)


if __name__ == "__main__":
    main()
