#!/bin/bash

source "$HOME/.config/sketchybar/icons.sh"
source "$HOME/.config/sketchybar/environment.sh"

# Fetch coordinates automatically via IP
geo_loc=$(curl --silent "http://ip-api.com/json/")
lat=$(echo "$geo_loc" | jq -r '.lat')
lon=$(echo "$geo_loc" | jq -r '.lon')

response=$(curl --silent "https://api.open-meteo.com/v1/forecast?latitude=${lat}&longitude=${lon}&current=temperature_2m,weather_code")
temperature_kelvin=$(echo $response | jq -r '.current.temperature_2m')
condition=$(echo $response | jq -r '.current.weather_code')
description="Weather Code $condition"
temperature=$(echo "scale=2; $temperature_kelvin" | bc  | cut -c 1-4)
is_night=$(echo $(( $(date +%H) >= 22 || $(date +%H) < 6 ? 1 : 0 )))

if (( description == "null" )); then
    description="Weather unavailable"
fi

if (( condition >= 95 && condition <= 99 )); then
    sketchybar --set weather icon="$THUNDERSTORM"
elif (( condition >= 51 && condition <= 57 )); then
    sketchybar --set weather icon="$DRIZZLE"
elif (( condition >= 61 && condition <= 67 )) || (( condition >= 80 && condition <= 82 )); then
    sketchybar --set weather icon="$RAIN"
elif (( condition >= 71 && condition <= 77 )) || (( condition >= 85 && condition <= 86 )); then
    sketchybar --set weather icon="$SNOW"
elif (( condition >= 45 && condition <= 48 )); then
    sketchybar --set weather icon="$ATMOSPHERE"
elif (( condition == 0 && is_night == 0 )); then
    sketchybar --set weather icon="$CLEAR"
elif (( condition == 0 && is_night == 1 )); then
    sketchybar --set weather icon="$CLEAR_NIGHT"
elif (( (condition == 1 || condition == 2) && is_night == 0 )); then
    sketchybar --set weather icon="$CLOUDS_LIGHT"
elif (( (condition == 1 || condition == 2) && is_night == 1 )); then
    sketchybar --set weather icon="$CLOUDS_LIGHT_NIGHT"
elif (( condition == 3 && is_night == 0 )); then
    sketchybar --set weather icon="$CLOUDS"
elif (( condition == 3 && is_night == 1 )); then
    sketchybar --set weather icon="$CLOUDS_NIGHT"
else
    sketchybar --set weather icon="$WEATHER_UNAVAILABLE"
fi

weather_popup_info=(
  icon="$IP"
  icon.padding_left=10
  label="$description"
  label.y_offset=0
  label.padding_left=10
  label.padding_right=10
  label.font="SF Pro:Bold:12.0"
  height=10
  blur_radius=100
)

sketchybar --add item weather.info popup.weather \
  --set weather.info "${weather_popup_info[@]}"


weather_popup_temperature=(
  icon="$TEMPERATURE"
  icon.padding_left=12
  label="$temperature °C"
  label.y_offset=0
  label.padding_left=12
  label.padding_right=10
  label.font="SF Pro:Bold:12.0"
  height=10
  blur_radius=100
)

sketchybar --add item weather.temperature popup.weather \
  --set weather.temperature "${weather_popup_temperature[@]}"