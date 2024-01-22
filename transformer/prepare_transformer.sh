# Script partly written and adapted by Antoine Cadotte (2021-2024)
# See Copyright and Permission notice at end of script

# Define paths to moses pre-processing scripts
MOSES_SCRIPTS=path/to/tools/moses-scripts/scripts
TOKENIZER=$MOSES_SCRIPTS/tokenizer/tokenizer.perl
NORM_PUNC=$MOSES_SCRIPTS/tokenizer/normalize-punctuation.perl
REM_NON_PRINT_CHAR=$MOSES_SCRIPTS/tokenizer/remove-non-printing-char.perl

# Define paths to fairseq segmentation scripts
FAIRSEQ_SCRIPTS=/path/to/tools/fairseq/scripts  
SPM_TRAIN=$FAIRSEQ_SCRIPTS/spm_train.py
SPM_ENCODE=$FAIRSEQ_SCRIPTS/spm_encode.py

# Define source and target languages
SRCS=("src")
TGT=tgt

# Define BPE vocabulary size, min and max sentence lenghts
BPESIZE=16000
TRAIN_MINLEN=1  # remove sentences with <1 BPE token
TRAIN_MAXLEN=250  # remove sentences with >250 BPE tokens

# Define model name and create preprocessed & segmented data directory
MODEL_NAME=model_name.ia-tgt
ORIG=../data/corpora/$MODEL_NAME
DATA=../data/corpora/$MODEL_NAME.bpe16k
mkdir -p "$DATA"
cp "$ORIG"/* "$DATA"

# Pre-process train, valid and test sets using moses scripts
echo "pre-processing data with moses..."
for SRC in "${SRCS[@]}"; do
    for LANG in "${SRC}" "${TGT}"; do
        cat "$DATA/train.${SRC}-${TGT}.${LANG}" | \
            perl $NORM_PUNC ${LANG} | \
            perl $REM_NON_PRINT_CHAR | \
            perl $TOKENIZER -threads 32 -a -l ${LANG} >> "$DATA/train.${SRC}-${TGT}.tok.${LANG}"

        # for validation dataset
        cat "$DATA/valid.${SRC}-${TGT}.${LANG}" | \
            perl $NORM_PUNC ${LANG} | \
            perl $REM_NON_PRINT_CHAR | \
            perl $TOKENIZER -threads 32 -a -l ${LANG} >> "$DATA/valid.${SRC}-${TGT}.tok.${LANG}"

        # for test dataset
        cat "$DATA/test.${SRC}-${TGT}.${LANG}" | \
            perl $NORM_PUNC ${LANG} | \
            perl $REM_NON_PRINT_CHAR | \
            perl $TOKENIZER -threads 32 -a -l ${LANG} >> "$DATA/test.${SRC}-${TGT}.tok.${LANG}"

    done
done




echo "...done"

# Learn BPE model with sentencepiece
TRAIN_FILES=$(for SRC in "${SRCS[@]}"; do echo $DATA/train.${SRC}-${TGT}.tok.${SRC}; echo $DATA/train.${SRC}-${TGT}.tok.${TGT}; done | tr "\n" ",")

echo "learning joint BPE over ${TRAIN_FILES}..."
python "$SPM_TRAIN" \
    --input=$TRAIN_FILES \
    --model_prefix=$DATA/sentencepiece.bpe \
    --vocab_size=$BPESIZE \
    --character_coverage=1.0 \
    --model_type=bpe

# encode train set
echo "encoding train with learned BPE..."
for SRC in "${SRCS[@]}"; do
    python "$SPM_ENCODE" \
        --model "$DATA/sentencepiece.bpe.model" \
        --output_format=piece \
        --inputs $DATA/train.${SRC}-${TGT}.tok.${SRC} $DATA/train.${SRC}-${TGT}.tok.${TGT} \
        --outputs $DATA/train.bpe.${SRC}-${TGT}.${SRC} $DATA/train.bpe.${SRC}-${TGT}.${TGT} \
        --min-len $TRAIN_MINLEN --max-len $TRAIN_MAXLEN
done

echo "encoding valid with learned BPE..."

SRC=src

# encode valid set
python "$SPM_ENCODE" \
    --model "$DATA/sentencepiece.bpe.model" \
    --output_format=piece \
    --inputs $DATA/valid.${SRC}-${TGT}.tok.${SRC} $DATA/valid.${SRC}-${TGT}.tok.${TGT} \
    --outputs $DATA/valid.bpe.${SRC}-${TGT}.${SRC} $DATA/valid.bpe.${SRC}-${TGT}.${TGT}
    
echo "encoding valid with learned BPE..."

# test set bpe
python "$SPM_ENCODE" \
    --model "$DATA/sentencepiece.bpe.model" \
    --output_format=piece \
    --inputs $DATA/test.${SRC}-${TGT}.tok.${SRC} $DATA/test.${SRC}-${TGT}.tok.${TGT} \
    --outputs $DATA/test.bpe.${SRC}-${TGT}.${SRC} $DATA/test.bpe.${SRC}-${TGT}.${TGT}


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

