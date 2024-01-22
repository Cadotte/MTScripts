# Script partly written and adapted by Antoine Cadotte (2021-2024)
# See Copyright and Permission notice at end of script

# Define model, dataset, workspace and checkpoints names/directories
MODEL_NAME=model_name.src-tgt.bpe16k
TEXT=../data/corpora/$MODEL_NAME
WORK=workspaces/$MODEL_NAME
mkdir -p $WORK
CHECKPOINTS=checkpoints/$MODEL_NAME
mkdir -p $CHECKPOINTS

## Binarize dataset
fairseq-preprocess --source-lang src --target-lang tgt \
    --trainpref $TEXT/train.bpe.src-tgt \
    --validpref $TEXT/valid.bpe.src-tgt \
    --testpref $TEXT/test.bpe.src-tgt \
    --destdir $WORK \
    --workers 32

# Train Transformer model
time fairseq-train $WORK/ \
    --max-epoch 800 \
    --ddp-backend=no_c10d \
    --task translation \
    --arch transformer \
    --share-decoder-input-output-embed \
    --optimizer adam --adam-betas '(0.9, 0.98)' \
    --lr 0.0005 --lr-scheduler inverse_sqrt \
    --warmup-updates 4000 --warmup-init-lr '1e-07' \
    --label-smoothing 0.1 --criterion label_smoothed_cross_entropy \
    --dropout 0.3 --weight-decay 0.0001 \
    --max-tokens 4000 \
    --update-freq 8 \
    --save-dir $CHECKPOINTS \
    --no-epoch-checkpoints

## Evaluate

RESULTS_DIR=results/$MODEL_NAME
mkdir -p $RESULTS_DIR
LOG_FILE=$RESULTS_DIR/generation.log
RESULTS_FILE=$RESULTS_DIR/generation.out

BPE=../data/corpora/$MODEL_NAME

fairseq-generate \
    $WORK \
    --path $CHECKPOINTS/checkpoint_best.pt \
    --task translation \
    --source-lang src --target-lang tgt \
    --beam 5 \
    --tokenizer moses \
    --remove-bpe=sentencepiece \
    --batch-size 128 --scoring bleu \
    --results-path $RESULTS_FILE \
    | tee $LOG_FILE
    
# The above script is partly based on source code from fairseq (https://github.com/facebookresearch/fairseq), with the following licence:

# MIT License

# Copyright (c) Facebook, Inc. and its affiliates.

# Permission is hereby granted, tgtee of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice sha#ll be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
