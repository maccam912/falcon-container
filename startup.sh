#!/bin/bash
set -ex

# check if /app/models/wizardlm-uncensored-falcon-40b.ggccv1.q5_k.bin exists. If not, run wget
# check if /app/models/wizardlm-7b-uncensored.ggccv1.q8_0.bin exists. If not, run wget
if [ ! -f /app/models/wizardlm-7b-uncensored.ggccv1.q8_0.bin ]; then
# if [ ! -f /app/models/wizardlm-uncensored-falcon-40b.ggccv1.q5_k.bin ]; then
    pushd /app/models
    wget https://huggingface.co/TheBloke/WizardLM-Uncensored-Falcon-7B-GGML/resolve/main/wizardlm-7b-uncensored.ggccv1.q8_0.bin
    # wget https://huggingface.co/TheBloke/WizardLM-Uncensored-Falcon-40B-GGML/resolve/main/wizardlm-uncensored-falcon-40b.ggccv1.q5_k.bin
    popd
fi

uvicorn server:app --host=0.0.0.0 --log-level trace