# Script partly written and adapted by Antoine Cadotte (2021-2024)
# See Copyright and Permission notice at end of script

# Define paths
MODEL_NAME=model_name.src-tgt.bpe16k
CHECKPOINTS=checkpoints/$MODEL_NAME
WORK=workspaces/$MODEL_NAME
BPE=../data/corpora/$MODEL_NAME
SCRIPTS=/path/to/tools/moses-scripts/scripts
TOKENIZER=$SCRIPTS/tokenizer/tokenizer.perl

# Launch interactive translation interface
fairseq-interactive $WORK \
--path $CHECKPOINTS/checkpoint_best.pt \
--beam 5 --source-lang src --target-lang tgt \
--tokenizer moses \
--bpe sentencepiece --sentencepiece-model $BPE/sentencepiece.bpe.model

# The above script is partly based on source code from fairseq (https://github.com/facebookresearch/fairseq), with the following licence:

# MIT License

# Copyright (c) Facebook, Inc. and its affiliates.

# Permission is hereby granted, free of charge, to any person obtaining a copy
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
