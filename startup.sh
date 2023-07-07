#!/bin/bash
set -ex

# check if /app/models/wizardlm-uncensored-falcon-40b.ggccv1.q5_k.bin exists. If not, run wget
if [ ! -f /app/models/wizardlm-uncensored-falcon-40b.ggccv1.q5_k.bin ]; then
    wget https://huggingface.co/TheBloke/WizardLM-Uncensored-Falcon-40B-GGML/resolve/main/wizardlm-uncensored-falcon-40b.ggccv1.q5_k.bin
fi

/user/local/bin/falcon_main -t 24 -n 200 -m /app/models/wizardlm-uncensored-falcon-40b.ggccv1.q5_k.bin -p 8080