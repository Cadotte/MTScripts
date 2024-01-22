# Script written and adapted by Antoine Cadotte (2023-2024)
# Partly based on examples from Moses SMT (http://www2.statmt.org/moses/)

# Define paths
HOME_DIR=path/to/your/home/
WORKING_DIR=$HOME_DIR/path/to/project/smt/model_name.src-tgt
MOSES_SRCDIR=$HOME_DIR/path/to/tools/mosesdecoder

echo "Language model training..."
# Language model training
$MOSES_SRCDIR/bin/lmplz -o 3 <$WORKING_DIR/corpus/train.src-tgt.true.tgt > train.src-tgt.arpa.tgt

# Binarize
$MOSES_SRCDIR/bin/build_binary \
   train.src-tgt.arpa.tgt \
   train.src-tgt.blm.tgt

echo "Training model..."
# Train model
nohup nice $MOSES_SRCDIR/scripts/training/train-model.perl -root-dir train \
 -corpus $WORKING_DIR/corpus/train.src-tgt.true                             \
 -f src -e tgt -alignment grow-dsrcg-final-and -reordering msd-bidirectional-fe \
 -lm 0:3:$WORKING_DIR/train.src-tgt.blm.tgt:8                          \
 -external-bin-dir $MOSES_SRCDIR/tools >& training.out &
