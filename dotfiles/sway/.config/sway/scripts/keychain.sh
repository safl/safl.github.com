#!/bin/bash
eval $(keychain --eval --dir "$HOME/.config/keychain" --quiet --noask --agents gpg,ssh id_rsa)
