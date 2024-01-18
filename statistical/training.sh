# Script written and adapted by Antoine Cadotte (2023-2024)
# Partly based on examples from Moses SMT (http://www2.statmt.org/moses/)

# Define paths
HOME_DIR=path/to/your/home/
WORKING_DIR=$HOME_DIR/path/to/project/smt/model_name.ia-fr
MOSES_SRCDIR=$HOME_DIR/path/to/tools/mosesdecoder

echo "Language model training..."
# Language model training
$MOSES_SRCDIR/bin/lmplz -o 3 <$WORKING_DIR/corpus/train.ia-fr.true.fr > train.ia-fr.arpa.fr

# Binarize
$MOSES_SRCDIR/bin/build_binary \
   train.ia-fr.arpa.fr \
   train.ia-fr.blm.fr

echo "Training model..."
# Train model
nohup nice $MOSES_SRCDIR/scripts/training/train-model.perl -root-dir train \
 -corpus $WORKING_DIR/corpus/train.ia-fr.true                             \
 -f ia -e fr -alignment grow-diag-final-and -reordering msd-bidirectional-fe \
 -lm 0:3:$WORKING_DIR/train.ia-fr.blm.fr:8                          \
 -external-bin-dir $MOSES_SRCDIR/tools >& training.out &
