#!/bin/bash
set -ex

# check if /app/models/wizardlm-uncensored-falcon-40b.ggccv1.q5_k.bin exists. If not, run wget
if [ ! -f /app/models/wizardlm-uncensored-falcon-40b.ggccv1.q5_k.bin ]; then
    pushd /app/models
    wget https://huggingface.co/TheBloke/WizardLM-Uncensored-Falcon-40B-GGML/resolve/main/wizardlm-uncensored-falcon-40b.ggccv1.q5_k.bin
    popd
fi

#/usr/local/bin/falcon_main -t 11 -n 32 -m /app/models/wizardlm-uncensored-falcon-40b.ggccv1.q5_k.bin -p "The answer is"
uvicorn server:app --host=0.0.0.0 --log-level trace