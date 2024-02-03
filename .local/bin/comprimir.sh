#!/bin/bash

for dir in */ ; do
    if [ "$dir" != "default/" ]; then
        if [ ! -f "${dir%/}.tar.gz" ]; then
            tar -czvf "${dir%/}.tar.gz" "$dir"
        else
            echo "El archivo ${dir%/}.tar.gz ya existe, omite la compresión de este directorio."
        fi
    fi
done

echo "Compresión de directorios completada."
