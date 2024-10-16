#!/bin/bash

# Script Name: run_lm_eval.sh
# Description: Sequentially runs multiple lm_eval commands, continuing even if one fails.
# Usage: bash run_lm_eval.sh

# Function to execute a command and log its status
run_command() {
    local cmd="$1"
    local job_name="$2"

    echo "=============================="
    echo "Starting job: $job_name"
    echo "Command: $cmd"
    echo "=============================="

    # Execute the command
    eval "$cmd"
    local exit_status=$?

    if [ $exit_status -eq 0 ]; then
        echo "✅ Job succeeded: $job_name"
    else
        echo "❌ Job failed: $job_name with exit code $exit_status"
    fi

    echo
}

# Define the commands and their descriptive names
commands=(
    "CUDA_VISIBLE_DEVICES=3 python gen_model_answer.py --model-path stabilityai/stablelm-zephyr-3b --model-id stabilityai_stablelm-zephyr-3b"
    "CUDA_VISIBLE_DEVICES=3 python gen_model_answer.py --model-path h2oai/h2o-danube3-4b-chat --model-id h2oai_h2o-danube3-4b-chat"
    "CUDA_VISIBLE_DEVICES=3 python gen_model_answer.py --model-path microsoft/Phi-3-mini-4k-instruct --model-id microsoft_Phi-3-mini-4k-instruct"
    "CUDA_VISIBLE_DEVICES=3 python gen_model_answer.py --model-path microsoft/Phi-3.5-mini-instruct --model-id microsoft_Phi-3.5-mini-instruct"
)

job_names=(
    "stablelm-zephyr-3b Evaluation"
    "h2o-danube3-4b-chat Evaluation"
    "Phi-3-mini-4k-instruct Evaluation"
    "Phi-3.5-mini-instruct Evaluation"
)

# Ensure the number of commands matches the number of job names
if [ ${#commands[@]} -ne ${#job_names[@]} ]; then
    echo "Error: Number of commands and job names do not match."
    exit 1
fi

# Iterate over the commands and execute them sequentially
for i in "${!commands[@]}"; do
    run_command "${commands[$i]}" "${job_names[$i]}"
done

echo "All jobs have been processed."
