#!/usr/bin/env fish
set -l base_dir "$HOME/.config/eww"
set -l image_file "$base_dir/image.jpg"
mkdir -p "$base_dir"

playerctl metadata -F -f '{{playerName}}|{{title}}|{{artist}}|{{mpris:artUrl}}|{{status}}|{{mpris:length}}' | while read -l line
  set -l parts (string split '|' -- $line)
  set -l name        $parts[1]
  set -l title       $parts[2]
  set -l artist      $parts[3]
  set -l artUrl      $parts[4]
  set -l play_status $parts[5]
  set -l length      $parts[6]

  set -l len_sec 0
  set -l lengthStr ""
  if test -n "$length"; and string match -rq '^[0-9]+$' -- "$length"
    set len_sec (math -s0 "( $length + 500000 ) / 1000000")
    set -l mins (math -s0 "$len_sec / 60")
    set -l secs (math -s0 "$len_sec % 60")
    set lengthStr (printf "%d:%02d" $mins $secs)
  end

  if string match -rq '^file://.*' -- "$artUrl"
    set -l local_path (string replace -r '^file://' '' -- "$artUrl")
    if test -f "$local_path"
      cp "$local_path" "$image_file"
    else
      cp "$base_dir/scripts/cover.png" "$image_file"
    end
  else if string match -rq '^https?://.*' -- "$artUrl"
    curl -Ls --max-time 5 "$artUrl" -o "$image_file" 2>/dev/null
    if test $status -ne 0
      cp "$base_dir/scripts/cover.png" "$image_file"
    end
  else
    cp "$base_dir/scripts/cover.png" "$image_file"
  end

  jq -n -c \
    --arg name "$name" \
    --arg title "$title" \
    --arg artist "$artist" \
    --arg artUrl "$image_file" \
    --arg status "$play_status" \
    --argjson length "$len_sec" \
    --arg lengthStr "$lengthStr" \
    '{name:$name, title:$title, artist:$artist, thumbnail:$artUrl, status:$status, length:$length, lengthStr:$lengthStr}'
end
