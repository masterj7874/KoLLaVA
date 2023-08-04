#!/bin/bash

# Uncomment and set the following variables correspondingly to run this script:

################## VICUNA ##################
# PROMPT_VERSION=v1
# MODEL_VERSION="vicuna-v1-3-7b"
MODEL_VERSION=kfkas/Llama-2-ko-7b-Chat #beomi/llama-2-ko-7b
################## VICUNA ##################

################## LLaMA-2 ##################
PROMPT_VERSION="llava_llama_2"
# MODEL_VERSION="llama-2-7b-chat"
################## LLaMA-2 ##################

deepspeed llava/train/train_mem.py \
    --deepspeed /root/LLaVA/scripts/zero2.json \
    --lora_enable True \
    --bits 4 \
    --model_name_or_path $MODEL_VERSION \
    --version $PROMPT_VERSION \
    --data_path /root/dataset/json/ko_llava_instruct_150k.json \
    --image_folder /root/dataset/train2014 \
    --vision_tower openai/clip-vit-large-patch14 \
    --pretrain_mm_mlp_adapter /root/LLaVA_old/checkpoints/llava-beomi/llama-2-ko-7b-pretrain/mm_projector.bin \
    --mm_vision_select_layer -2 \
    --mm_use_im_start_end False \
    --mm_use_im_patch_token False \
    --bf16 True \
    --output_dir ./checkpoints/llava-$MODEL_VERSION-finetune_lora \
    --num_train_epochs 1 \
    --per_device_train_batch_size 16 \
    --per_device_eval_batch_size 4 \
    --gradient_accumulation_steps 2 \
    --evaluation_strategy "no" \
    --save_strategy "steps" \
    --save_steps 500 \
    --save_total_limit 1 \
    --learning_rate 2e-4 \
    --weight_decay 0. \
    --warmup_ratio 0.03 \
    --lr_scheduler_type "cosine" \
    --logging_steps 1 \
    --tf32 True \
    --model_max_length 2048 \
    --gradient_checkpointing True \
    --lazy_preprocess True \
    --dataloader_num_workers 4 \
    --report_to wandb \
    --freeze_mm_mlp_adapter True