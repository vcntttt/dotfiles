#!/usr/bin/env python3

import argparse
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
DEV_ROOT = Path.home() / "dev"


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


def obtener_semestre(selector):
    texto = str(selector).strip()

    if texto.isdigit():
        semestre_dirs = SEMESTRES.get(int(texto))
        if semestre_dirs is not None:
            return semestre_dirs

    texto_casefold = texto.casefold()
    for files_semestre, notes_semestre in SEMESTRES.values():
        if texto_casefold in {files_semestre.casefold(), notes_semestre.casefold()}:
            return files_semestre, notes_semestre

    raise ValueError("Semestre invalido.")


def crear_symlink_directorio(link_path, target_path, etiqueta):
    destino_esperado = target_path.resolve()

    if link_path.is_symlink():
        destino_actual = link_path.resolve()
        if destino_actual == destino_esperado:
            print(f"  - {etiqueta} ya existe: {link_path}")
        else:
            print(f"  - Aviso: {link_path} ya apunta a otra ruta ({destino_actual}).")
        return

    if link_path.exists():
        print(f"  - Aviso: {link_path} ya existe y no es un symlink. Se omite.")
        return

    link_path.symlink_to(target_path, target_is_directory=True)
    print(f"  - {etiqueta} creado: {link_path} -> {target_path}")


def crear_symlink_notas(carpeta_principal, destino_notas):
    crear_symlink_directorio(
        carpeta_principal / "Notas", destino_notas, "Symlink notas"
    )


def crear_symlink_work(carpeta_principal, destino_work):
    crear_symlink_directorio(carpeta_principal / "work", destino_work, "Symlink work")


def encontrar_destino_notas(carpeta_principal, notes_semestre_dir):
    link_notas = carpeta_principal / "Notas"

    if link_notas.is_symlink():
        destino_actual = link_notas.resolve()
        if destino_actual.parent == notes_semestre_dir.resolve():
            return destino_actual

        print(
            f"  - Aviso: {link_notas} no apunta al semestre esperado ({notes_semestre_dir})."
        )

    candidatos = [
        path
        for path in sorted(notes_semestre_dir.iterdir())
        if path.is_dir() and slugify(path.name) == carpeta_principal.name
    ]

    if len(candidatos) == 1:
        return candidatos[0]

    if not candidatos:
        print(
            f"  - Aviso: no se encontro carpeta de notas para {carpeta_principal.name}."
        )
    else:
        print(
            f"  - Aviso: hay multiples carpetas de notas posibles para {carpeta_principal.name}."
        )

    return None


def reportar_enlaces_legacy(carpeta_principal, destino_work):
    destino_work_resuelto = destino_work.resolve()

    for path in sorted(carpeta_principal.iterdir()):
        if path.name in {"Notas", "work"} or not path.is_symlink():
            continue

        destino_actual = path.resolve()
        if destino_actual == destino_work_resuelto or destino_actual.is_relative_to(
            destino_work_resuelto
        ):
            print(
                f"  - Aviso: enlace legacy detectado en {path.name}. "
                "El modelo nuevo usa solo 'work'."
            )


def asegurar_semestre(files_semestre, notes_semestre):
    files_semestre_dir = FILES_DIR / files_semestre
    notes_semestre_dir = NOTES_ROOT / notes_semestre
    dev_semestre_dir = DEV_ROOT / files_semestre

    files_semestre_dir.mkdir(parents=True, exist_ok=True)
    notes_semestre_dir.mkdir(parents=True, exist_ok=True)
    dev_semestre_dir.mkdir(parents=True, exist_ok=True)

    crear_symlink_directorio(
        files_semestre_dir / "Notas", notes_semestre_dir, "Symlink semestre notas"
    )

    return files_semestre_dir, notes_semestre_dir, dev_semestre_dir


def crear_ramo(
    files_semestre_dir, notes_semestre_dir, dev_semestre_dir, nombre_visible, slug_ramo
):
    carpeta_principal = files_semestre_dir / slug_ramo
    carpeta_principal.mkdir(parents=True, exist_ok=True)
    print(f"  - Carpeta principal: {carpeta_principal}")

    carpeta_notas_destino = notes_semestre_dir / nombre_visible
    carpeta_notas_destino.mkdir(parents=True, exist_ok=True)
    print(f"  - Carpeta notas: {carpeta_notas_destino}")

    carpeta_work_destino = dev_semestre_dir / slug_ramo
    carpeta_work_destino.mkdir(parents=True, exist_ok=True)
    print(f"  - Carpeta work: {carpeta_work_destino}")

    crear_symlink_notas(carpeta_principal, carpeta_notas_destino)
    crear_symlink_work(carpeta_principal, carpeta_work_destino)


def modo_crear(selector_semestre):
    if selector_semestre is None:
        semestre_numero = pedir_entero("Ingrese el numero del semestre: ")
        semestre_dirs = SEMESTRES.get(semestre_numero)
        if semestre_dirs is None:
            print("Numero de semestre invalido.")
            sys.exit(1)
        files_semestre, notes_semestre = semestre_dirs
    else:
        try:
            files_semestre, notes_semestre = obtener_semestre(selector_semestre)
        except ValueError as error:
            print(error)
            sys.exit(1)

    files_semestre_dir, notes_semestre_dir, dev_semestre_dir = asegurar_semestre(
        files_semestre, notes_semestre
    )

    num_ramos = pedir_entero("Cuantos ramos hay? ")

    for indice in range(1, num_ramos + 1):
        print(f"\nRamo {indice} de {num_ramos}")

        nombre_visible = pedir_texto("Nombre del ramo para Notas: ")
        slug_sugerido = slugify(nombre_visible)
        slug_ingresado = input(f"Slug para Nextcloud y dev [{slug_sugerido}]: ").strip()
        slug_ramo = slug_ingresado or slug_sugerido

        if not slug_ramo:
            print("No se pudo generar un slug valido. Se omite este ramo.")
            continue

        crear_ramo(
            files_semestre_dir,
            notes_semestre_dir,
            dev_semestre_dir,
            nombre_visible,
            slug_ramo,
        )


def modo_normalizar(selector_semestre):
    try:
        files_semestre, notes_semestre = obtener_semestre(selector_semestre)
    except ValueError as error:
        print(error)
        sys.exit(1)

    files_semestre_dir, notes_semestre_dir, dev_semestre_dir = asegurar_semestre(
        files_semestre, notes_semestre
    )

    ramos = [
        path
        for path in sorted(files_semestre_dir.iterdir())
        if path.is_dir() and path.name != "Notas"
    ]

    if not ramos:
        print(f"No hay ramos para normalizar en {files_semestre_dir}.")
        return

    slugs_ramos = {path.name for path in ramos}
    print(f"Normalizando {len(ramos)} ramo(s) en {files_semestre_dir}\n")

    for carpeta_principal in ramos:
        print(f"Ramo: {carpeta_principal.name}")

        destino_notas = encontrar_destino_notas(carpeta_principal, notes_semestre_dir)
        if destino_notas is not None:
            destino_notas.mkdir(parents=True, exist_ok=True)
            crear_symlink_notas(carpeta_principal, destino_notas)

        destino_work = dev_semestre_dir / carpeta_principal.name
        destino_work.mkdir(parents=True, exist_ok=True)
        print(f"  - Carpeta work: {destino_work}")
        crear_symlink_work(carpeta_principal, destino_work)
        reportar_enlaces_legacy(carpeta_principal, destino_work)
        print()

    extras_dev = [
        path.name
        for path in sorted(dev_semestre_dir.iterdir())
        if path.is_dir() and path.name not in slugs_ramos
    ]
    if extras_dev:
        print("Aviso: carpetas extra en dev fuera del modelo del semestre:")
        for nombre in extras_dev:
            print(f"  - {nombre}")


def main():
    parser = argparse.ArgumentParser(
        description="Crea o normaliza la estructura de ramos entre Nextcloud, Notas y dev."
    )
    subparsers = parser.add_subparsers(dest="command")

    parser_crear = subparsers.add_parser(
        "crear", help="Crea ramos nuevos de forma interactiva"
    )
    parser_crear.add_argument(
        "semestre", nargs="?", help="Numero o nombre del semestre"
    )

    parser_normalizar = subparsers.add_parser(
        "normalizar", help="Normaliza un semestre existente al modelo Notas + work"
    )
    parser_normalizar.add_argument("semestre", help="Numero o nombre del semestre")

    args = parser.parse_args()

    if args.command in {None, "crear"}:
        modo_crear(getattr(args, "semestre", None))
        return

    if args.command == "normalizar":
        modo_normalizar(args.semestre)
        return


if __name__ == "__main__":
    main()
