# Perfil de shell para Caburgua (Ubuntu Server).

if command -q apt
    abbr --add update-system 'sudo apt update; and sudo apt upgrade'
    abbr --add install 'sudo apt install'
    abbr --add remove 'sudo apt remove'
end
