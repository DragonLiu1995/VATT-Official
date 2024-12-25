#!/bin/bash

export TRANSFORMERS_CACHE=./hf_cache/
export HF_DATASETS_CACHE=./hf_cache/

output_dir='../exp/pretrain_v2a_scratch_all_vgg_audioset_ltu'
mkdir -p $output_dir
cp "$0" ${output_dir}/$(date +"%Y-%m-%d-%H-%M-%S").sh

torchrun --nproc_per_node=1 --master_port=1236 ../pretrain_visual_audio.py \
    --base_model '../../../pretrained_mdls/vicuna/' \
    --data_path '../../../data/dataset_all_v2a_plus_ltu_instruction.json' \
    --output_dir $output_dir \
    --batch_size 36 \
    --micro_batch_size 36 \
    --num_epochs 2 \
    --learning_rate 1e-4 \
    --cutoff_len 108 \
    --val_set_size 10 \
    --lora_r 16 \
    --lora_alpha 32 \
    --lora_dropout 0.05 \
    --lora_target_modules ['dummy'] \
    --train_on_inputs \
    --wandb_run_name ${output_dir} \
    --group_by_length \
    --save_steps 500 \
    --trainable_params all