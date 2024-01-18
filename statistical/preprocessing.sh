# Script written and adapted by Antoine Cadotte (2023-2024)
# Partly based on examples from Moses SMT (http://www2.statmt.org/moses/)

# Define paths
HOME_DIR=path/to/your/home/
WORKING_DIR=$HOME_DIR/path/to/project/smt/model_name.ia-fr
MOSES_SRCDIR=$HOME_DIR/path/to/tools/mosesdecoder

echo "Tokenizing training data..."
# Tokenization
$MOSES_SRCDIR/scripts/tokenizer/tokenizer.perl -l ia \
    < $WORKING_DIR/corpus/training/train.ia-fr.ia    \
    > $WORKING_DIR/corpus/train.ia-fr.tok.ia

$MOSES_SRCDIR/scripts/tokenizer/tokenizer.perl -l fr \
    < $WORKING_DIR/corpus/training/train.ia-fr.fr    \
    > $WORKING_DIR/corpus/train.ia-fr.tok.fr

echo "Truecaser Training..."
# Truecaser Training
$MOSES_SRCDIR/scripts/recaser/train-truecaser.perl \
     --model $WORKING_DIR/corpus/truecase-model.ia --corpus     \
     $WORKING_DIR/corpus/train.ia-fr.tok.ia
$MOSES_SRCDIR/scripts/recaser/train-truecaser.perl \
     --model $WORKING_DIR/corpus/truecase-model.fr --corpus     \
     $WORKING_DIR/corpus/train.ia-fr.tok.fr

echo "Truecasing training data..."
# Truecasing
$MOSES_SRCDIR/scripts/recaser/truecase.perl \
   --model $WORKING_DIR/corpus/truecase-model.ia         \
   < $WORKING_DIR/corpus/train.ia-fr.tok.ia \
   > $WORKING_DIR/corpus/train.ia-fr.true.ia
$MOSES_SRCDIR/scripts/recaser/truecase.perl \
   --model $WORKING_DIR/corpus/truecase-model.fr         \
   < $WORKING_DIR/corpus/train.ia-fr.tok.fr \
   > $WORKING_DIR/corpus/train.ia-fr.true.fr
   
echo "Tokenizing and Truecasing tuning data..."
# Tokenize and Truecase tuning data
cd $WORKING_DIR/corpus
$MOSES_SRCDIR/scripts/tokenizer/tokenizer.perl -l ia \
   < dev/valid.ia-fr.ia > valid.tok.ia-fr.ia
$MOSES_SRCDIR/scripts/tokenizer/tokenizer.perl -l fr \
   < dev/valid.ia-fr.fr > valid.tok.ia-fr.fr
$MOSES_SRCDIR/scripts/recaser/truecase.perl --model truecase-model.ia \
   < valid.tok.ia-fr.ia > valid.ia-fr.true.ia
$MOSES_SRCDIR/scripts/recaser/truecase.perl --model truecase-model.fr \
   < valid.tok.ia-fr.fr > valid.ia-fr.true.fr

echo "Tokenizing and Truecasing testing data..."
# Tokenize and Truecase testing data
cd $WORKING_DIR/corpus
$MOSES_SRCDIR/scripts/tokenizer/tokenizer.perl -l ia \
   < test/test.ia-fr.ia >test.tok.ia-fr.ia
$MOSES_SRCDIR/scripts/tokenizer/tokenizer.perl -l fr \
   < test/test.ia-fr.fr >test.tok.ia-fr.fr
$MOSES_SRCDIR/scripts/recaser/truecase.perl --model truecase-model.ia \
   <test.tok.ia-fr.ia >test.ia-fr.true.ia
$MOSES_SRCDIR/scripts/recaser/truecase.perl --model truecase-model.fr \
   <test.tok.ia-fr.fr >test.ia-fr.true.fr
