# Script written and adapted by Antoine Cadotte (2023-2024)
# Partly based on examples from Moses SMT (http://www2.statmt.org/moses/)

# Define paths
HOME_DIR=path/to/your/home/
WORKING_DIR=$HOME_DIR/path/to/project/smt/model_name.src-tgt
MOSES_SRCDIR=$HOME_DIR/path/to/tools/mosesdecoder

echo "Tokenizing training data..."
# Tokenization
$MOSES_SRCDIR/scripts/tokenizer/tokenizer.perl -l src \
    < $WORKING_DIR/corpus/training/train.src-tgt.src    \
    > $WORKING_DIR/corpus/train.src-tgt.tok.src

$MOSES_SRCDIR/scripts/tokenizer/tokenizer.perl -l tgt \
    < $WORKING_DIR/corpus/training/train.src-tgt.tgt    \
    > $WORKING_DIR/corpus/train.src-tgt.tok.tgt

echo "Truecaser Training..."
# Truecaser Training
$MOSES_SRCDIR/scripts/recaser/train-truecaser.perl \
     --model $WORKING_DIR/corpus/truecase-model.src --corpus     \
     $WORKING_DIR/corpus/train.src-tgt.tok.src
$MOSES_SRCDIR/scripts/recaser/train-truecaser.perl \
     --model $WORKING_DIR/corpus/truecase-model.tgt --corpus     \
     $WORKING_DIR/corpus/train.src-tgt.tok.tgt

echo "Truecasing training data..."
# Truecasing
$MOSES_SRCDIR/scripts/recaser/truecase.perl \
   --model $WORKING_DIR/corpus/truecase-model.src         \
   < $WORKING_DIR/corpus/train.src-tgt.tok.src \
   > $WORKING_DIR/corpus/train.src-tgt.true.src
$MOSES_SRCDIR/scripts/recaser/truecase.perl \
   --model $WORKING_DIR/corpus/truecase-model.tgt         \
   < $WORKING_DIR/corpus/train.src-tgt.tok.tgt \
   > $WORKING_DIR/corpus/train.src-tgt.true.tgt
   
echo "Tokenizing and Truecasing tuning data..."
# Tokenize and Truecase tuning data
cd $WORKING_DIR/corpus
$MOSES_SRCDIR/scripts/tokenizer/tokenizer.perl -l src \
   < dev/valid.src-tgt.src > valid.tok.src-tgt.src
$MOSES_SRCDIR/scripts/tokenizer/tokenizer.perl -l tgt \
   < dev/valid.src-tgt.tgt > valid.tok.src-tgt.tgt
$MOSES_SRCDIR/scripts/recaser/truecase.perl --model truecase-model.src \
   < valid.tok.src-tgt.src > valid.src-tgt.true.src
$MOSES_SRCDIR/scripts/recaser/truecase.perl --model truecase-model.tgt \
   < valid.tok.src-tgt.tgt > valid.src-tgt.true.tgt

echo "Tokenizing and Truecasing testing data..."
# Tokenize and Truecase testing data
cd $WORKING_DIR/corpus
$MOSES_SRCDIR/scripts/tokenizer/tokenizer.perl -l src \
   < test/test.src-tgt.src >test.tok.src-tgt.src
$MOSES_SRCDIR/scripts/tokenizer/tokenizer.perl -l tgt \
   < test/test.src-tgt.tgt >test.tok.src-tgt.tgt
$MOSES_SRCDIR/scripts/recaser/truecase.perl --model truecase-model.src \
   <test.tok.src-tgt.src >test.src-tgt.true.src
$MOSES_SRCDIR/scripts/recaser/truecase.perl --model truecase-model.tgt \
   <test.tok.src-tgt.tgt >test.src-tgt.true.tgt
