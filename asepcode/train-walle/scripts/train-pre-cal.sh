#!/bin/zsh

# Initialize mode variable
mode=""

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)
      mode="$2"
      shift 2  # Shift past the flag and its value
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

# Check if the mode argument is provided
if [[ -z ${mode} ]]; then
  echo "mode is not provided, choices: dev, train"
  exit 1
fi

# Source the setup-wandb.sh script to set environment variables
source ~/Documents/GSU/Projects/Antibody-Design/epitope-prediction/epitope-pred/asepcode/train-walle/scripts/setup-wandb.sh

# ------------------------------------------------------------------------------
# dev
# ------------------------------------------------------------------------------
if [[ ${mode} == 'dev' ]]; then
  python3 train.py \
    mode='dev' \
    "wandb_init.project=retrain-walle-dev" \
    "wandb_init.notes='pre_cal'" \
    hparams.max_epochs=5 \
    hparams.pos_weight=100 \
    hparams.train_batch_size=128 \
    hparams.val_batch_size=32 \
    hparams.test_batch_size=32 \
    dataset.node_feat_type='pre_cal' \
    dataset.ab.embedding_model='igfold' \
    dataset.ag.embedding_model='esm2'
fi

# ------------------------------------------------------------------------------
# train
# ------------------------------------------------------------------------------
if [[ ${mode} == 'train' ]]; then
  python3 train.py \
    mode='train' \
    "wandb_init.project=retrain-walle" \
    "wandb_init.notes='pre_cal'" \
    "wandb_init.tags='pre_cal'" \
    hparams.max_epochs=10 \
    hparams.pos_weight=100 \
    hparams.train_batch_size=32 \
    hparams.val_batch_size=32 \
    hparams.test_batch_size=32 \
    dataset.node_feat_type='pre_cal' \
    dataset.ab.embedding_model='esm2' \
    dataset.ag.embedding_model='esm2' \
    "callbacks.early_stopping=null"
fi

# Print the mode for debugging
# echo "Mode: ${mode}"