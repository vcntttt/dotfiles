import os

def main():
    semestres = {
        1: "1er-Semestre",
        2: "2do-Semestre",
        3: "3er-Semestre",
        4: "4to-Semestre",
        5: "5to-Semestre",
        6: "6to-Semestre",
        7: "7mo-Semestre",
        8: "8vo-Semestre",
        9: "9no-Semestre",
        10: "10mo-Semestre",
    }

    filesDir = os.path.expanduser("~/Dropbox/")
    notesDir = os.path.expanduser(f"{filesDir}/Obsidian-Notes/02 - UCT")

    numSemestre = int(input("Ingrese el número del semestre: "))

    # Obtener el nombre del semestre
    semestreDir = semestres.get(numSemestre, None)
    if semestreDir is None:
        print("Número de semestre inválido.")
        return

    os.makedirs(os.path.join(filesDir, semestreDir), exist_ok=True)

    numRamos = int(input("¿Cuántos ramos hay? "))

    for _ in range(numRamos):
        nombreRamo = input("Ingrese el nombre del ramo: ")
        
        # Crear la primera carpeta del ramo en la ubicación principal
        carpetaPrincipal = os.path.join(filesDir, semestreDir, nombreRamo)
        os.makedirs(carpetaPrincipal, exist_ok=True)
        
        # Crear la segunda carpeta del ramo con el número de semestre en la segunda ubicación
        segundaUbicacion = os.path.join(notesDir, f"{numSemestre} - {nombreRamo}")
        os.makedirs(segundaUbicacion, exist_ok=True)
        
        # Enlazar simbólicamente la carpeta de la segunda ubicación con la carpeta Notas en la primera ubicación
        carpetaNotas = os.path.join(carpetaPrincipal, "Notas")
        if not os.path.exists(carpetaNotas):
            os.symlink(segundaUbicacion, carpetaNotas)

if __name__ == "__main__":
    main()
