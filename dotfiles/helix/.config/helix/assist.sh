#!/bin/bash
TEXT=$(cat)

# Run Mistral-7B with llama.cpp
~/git/llama.cpp/build/bin/llama-cli -m ~/git/llama.cpp/models/mistral-7b-instruct-v0.1.Q4_K_M.gguf \
 -p "Fix spelling and grammer of the text:\n\n$TEXT" \
--temp 0.2 --top-k 40 --top-p 0.9 --repeat_penalty 1.1 --n-gpu-layers 35 \
  2>/dev/null | awk 'NR>1' | sed -e 's/\[end of text\]//g'
