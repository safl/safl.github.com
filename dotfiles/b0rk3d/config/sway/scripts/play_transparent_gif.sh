#!/usr/bin/env bash
mpv \
--no-config \
--profile=low-latency \
--no-border \
--geometry=100%x100% \
--player-operation-mode=pseudo-gui \
--vo=gpu \
--gpu-context=wayland \
--alpha=yes \
--background=0.0/0.0/0.0/0.0 \
$1
