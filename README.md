# Dotfiles

Configuración del desktop principal con CachyOS, Hyprland Lua, Noctalia y Fish.
La rama `arch-hyprland-vanilla` conserva el setup anterior como referencia.

## Instalación

```bash
sudo pacman -S git stow
cd ~
git clone https://github.com/vcntttt/dotfiles.git
cd dotfiles
bash shell/install-dependencies.sh desktop
stow .
```

`.stowrc` desactiva el folding de directorios. De esta forma, Stow enlaza
archivos individuales y Noctalia puede seguir generando temas y estado local
sin escribirlos dentro del repositorio.

Si una instalación nueva ya contiene los mismos archivos como archivos reales,
respáldalos y retíralos antes de ejecutar Stow. No uses `stow --adopt` sin
revisar cuidadosamente el resultado.

## Noctalia

- `.config/noctalia/` contiene la configuración declarativa.
- `.local/state/noctalia/settings.toml` contiene los cambios persistidos por la
  GUI y también se versiona.
- El resto de `.local/state/noctalia/`, las credenciales y los temas generados
  permanecen locales.

La GUI escribe a través del symlink de `settings.toml`; sus cambios aparecen
como modificaciones normales en Git y deben revisarse antes de hacer commit.
Si un valor también se administra desde la GUI, edítalo desde código en ese
mismo `settings.toml`; evita duplicarlo en `config.toml`.

## Validación

```fish
stow --no --verbose=1 .
fish -n ~/.config/fish/config.fish
noctalia config validate
hyprctl configerrors
```
