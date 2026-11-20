function tshot --wraps='grim ~/shot.png; and wl-copy < ~/shot.png' --description 'alias tshot=grim ~/shot.png; and wl-copy < ~/shot.png'
    sleep 3 && grim ~/shot.png; and wl-copy < ~/shot.png $argv
end
