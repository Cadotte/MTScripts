# Script written and adapted by Antoine Cadotte (2023-2024)
# Partly based on examples from Moses SMT (http://www2.statmt.org/moses/)

# Define paths
HOME_DIR=path/to/your/home/
WORKING_DIR=$HOME_DIR/path/to/project/smt/model_name.src-tgt
MOSES_SRCDIR=$HOME_DIR/path/to/tools/mosesdecoder

echo "Translating test set..."
# Translate test set
nohup nice $MOSES_SRCDIR/bin/moses            \
   -f $WORKING_DIR/mert-work/moses.ini   \
   < $WORKING_DIR/corpus/test.src-tgt.true.src                \
   > $WORKING_DIR/test.translated.src-tgt.tgt         \
   2> $WORKING_DIR/test.out
   
echo "Detokenizing test set..."
# Detokenize generated translations
$MOSES_SRCDIR/scripts/tokenizer/detokenizer.perl -l tgt \
   < $WORKING_DIR/test.translated.src-tgt.tgt >$WORKING_DIR/translated.detok.src-tgt.tgt
$MOSES_SRCDIR/scripts/tokenizer/detokenizer.perl -l tgt \
   < $WORKING_DIR/corpus/test.src-tgt.true.tgt >$WORKING_DIR/reference.detok.src-tgt.tgt
   
echo "Calculating sacreBLEU and ChrF++ on generated translations..."
echo "BLEU:"
sacrebleu $WORKING_DIR/reference.detok.src-tgt.tgt -i $WORKING_DIR/translated.detok.src-tgt.tgt -m bleu -b -w 4 --sentence-level > bleu_resfile.txt
echo "ChrF++:"
sacrebleu $WORKING_DIR/reference.detok.src-tgt.tgt -i $WORKING_DIR/translated.detok.src-tgt.tgt -m chrf -b -w 4 --sentence-level > chrf_resfile.txt

