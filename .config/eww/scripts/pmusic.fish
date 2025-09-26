#!/usr/bin/env fish
set -l base_dir "$HOME/.config/eww"
set -l state_file "$base_dir/music-state.json"

function format_time --argument-names seconds
    set -l mins (math -s0 "$seconds / 60")
    set -l secs (math -s0 "$seconds % 60")
    printf "%d:%02d" $mins $secs
end

# ensure state file exists with zeros
if not test -f "$state_file"
    jq -n -c '{title:"", position:0, positionStr:"0:00", length:0}' > "$state_file"
end

playerctl -F metadata -f '{{playerName}}|{{title}}|{{position}}|{{mpris:length}}' | while read -l line
    set -l parts (string split '|' -- $line)
    set -l player   $parts[1]
    set -l title    $parts[2]
    set -l position $parts[3]
    set -l length   $parts[4]

    set -l pos_sec 0
    set -l len_sec 0
    if test -n "$position"; and test -n "$length"
        set pos_sec (math -s0 "( $position + 500000 ) / 1000000")
        set len_sec (math -s0 "( $length + 500000 ) / 1000000")

        # reset progress when track title changes
        if test -f "$state_file"
            set -l last_title (jq -r '.title' "$state_file" 2>/dev/null)
            if test "$title" != "$last_title"
                set pos_sec 0
            end
        end
    else
        # if metadata missing, keep previous state
        if test -f "$state_file"
            cat "$state_file"
            continue
        end
    end

    set -l pos_str (format_time $pos_sec)
    jq -n -c \
        --arg title "$title" \
        --argjson position "$pos_sec" \
        --arg positionStr "$pos_str" \
        --argjson length "$len_sec" \
        '{title:$title, position:$position, positionStr:$positionStr, length:$length}' > "$state_file"

    cat "$state_file"
end
