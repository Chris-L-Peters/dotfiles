#!/bin/sh
jq -r '
  def esc: "\u001b[" + . + "m";
  (.model.display_name // "?") as $model
  | ((.context_window.used_percentage // 0) | floor) as $pct
  | (if $pct >= 85 then "38;5;204" elif $pct >= 60 then "38;5;180" else "38;5;114" end) as $colour
  | ("38;5;145" | esc) + $model + ("0" | esc)
  + " " + ("38;5;59" | esc) + "\u00b7" + ("0" | esc) + " "
  + ($colour | esc) + ($pct | tostring) + "%" + ("0" | esc)
  + " " + ("38;5;59" | esc) + "context" + ("0" | esc)
'
