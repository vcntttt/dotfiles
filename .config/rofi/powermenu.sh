#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Power Menu
#
## Powermenu Type 3 - Style 2

# Current Theme
dir="$HOME/.config/rofi/powermenu/"

# CMDs
uptime="$(uptime -p | sed -e 's/up //g')"
host=$(hostname)

# Options
shutdown=''
reboot=''
lock=''
suspend=''
logout=''
yes=''
no=''
push_now='push ahora'
cancel='cancelar'
dev_cmd="${DEV_CMD:-$HOME/.local/bin/dev}"

# Rofi CMD
rofi_cmd() {
    rofi -dmenu \
    -p "Uptime: $uptime" \
    -mesg "Uptime: $uptime" \
    -theme ${dir}/theme.rasi
}

# Confirmation CMD
confirm_cmd() {
    rofi -dmenu \
    -p 'Confirmation' \
    -mesg 'Are you Sure?' \
    -theme ${dir}/confirm.rasi
}

git_confirm_cmd() {
    local msg="$1"
    rofi -dmenu \
    -p 'Git' \
    -mesg "$msg" \
    -theme ${dir}/git-confirm.rasi
}

# Ask for confirmation
confirm_exit() {
    echo -e "$yes\n$no" | confirm_cmd
}

pending_push_dialog() {
    local action_label="$1"
    local continue_label="${action_label} igual"

    if [ ! -x "$dev_cmd" ]; then
        return 0
    fi

    while true; do
        local count
        local msg
        local selected
        local -a names=()

        count=$("$dev_cmd" pending-push 2>/dev/null || echo 0)
        if [ "$count" -eq 0 ]; then
            return 0
        fi

        mapfile -t names < <("$dev_cmd" pending-push --names 2>/dev/null)

        msg=$'Hay commits sin push en '
        msg+="$count"
        msg+=$' repo(s).'
        if [ "${#names[@]}" -gt 0 ]; then
            msg+=$'\n\nRepos:\n'
            local i=0
            for name in "${names[@]}"; do
                i=$((i + 1))
                if [ "$i" -gt 6 ]; then
                    msg+=$'...\n'
                    break
                fi
                msg+="- $name"
                msg+=$'\n'
            done
        fi

        selected=$(printf "%s\n%s\n%s" "$push_now" "$continue_label" "$cancel" | git_confirm_cmd "$msg")
        if [[ "$selected" == "$push_now" ]]; then
            "$dev_cmd" push
            continue
        fi
        if [[ "$selected" == "$continue_label" ]]; then
            return 0
        fi
        return 1
    done
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
    if [[ $1 == '--shutdown' ]]; then
        if ! pending_push_dialog "apagar"; then
            exit 0
        fi
    elif [[ $1 == '--reboot' ]]; then
        if ! pending_push_dialog "reiniciar"; then
            exit 0
        fi
    fi

    selected="$(confirm_exit)"
    if [[ "$selected" == "$yes" ]]; then
        if [[ $1 == '--shutdown' ]]; then
            systemctl poweroff
            elif [[ $1 == '--reboot' ]]; then
            systemctl reboot
            elif [[ $1 == '--suspend' ]]; then
            mpc -q pause
            amixer set Master mute
            systemctl suspend
            elif [[ $1 == '--logout' ]]; then
            if [[ -x '/usr/bin/hyprctl' ]]; then
                hyprctl dispatch exit
                pkill -9 code
                elif [[ "$DESKTOP_SESSION" == 'openbox' ]]; then
                openbox --exit
                elif [[ "$DESKTOP_SESSION" == 'bspwm' ]]; then
                bspc quit
                elif [[ "$DESKTOP_SESSION" == 'i3' ]]; then
                i3-msg exit
                elif [[ "$DESKTOP_SESSION" == 'plasma' ]]; then
                qdbus org.kde.ksmserver /KSMServer logout 0 0 0
            fi
        fi
    else
        exit 0
    fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
        run_cmd --shutdown
    ;;
    $reboot)
        run_cmd --reboot
    ;;
    $lock)
        if [[ -x '/usr/bin/hyprlock' ]]; then
            hyprlock
            elif [[ -x '/usr/bin/betterlockscreen' ]]; then
            betterlockscreen -l
            elif [[ -x '/usr/bin/i3lock' ]]; then
            i3lock
        fi
    ;;
    $suspend)
        run_cmd --suspend
    ;;
    $logout)
        run_cmd --logout
    ;;
esac
