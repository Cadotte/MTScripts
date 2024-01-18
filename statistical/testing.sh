# Script written and adapted by Antoine Cadotte (2023-2024)
# Partly based on examples from Moses SMT (http://www2.statmt.org/moses/)

# Define paths
HOME_DIR=path/to/your/home/
WORKING_DIR=$HOME_DIR/path/to/project/smt/model_name.ia-fr
MOSES_SRCDIR=$HOME_DIR/path/to/tools/mosesdecoder

echo "Translating test set..."
# Translate test set
nohup nice $MOSES_SRCDIR/bin/moses            \
   -f $WORKING_DIR/mert-work/moses.ini   \
   < $WORKING_DIR/corpus/test.ia-fr.true.ia                \
   > $WORKING_DIR/test.translated.ia-fr.fr         \
   2> $WORKING_DIR/test.out
   
echo "Detokenizing test set..."
# Detokenize generated translations
$MOSES_SRCDIR/scripts/tokenizer/detokenizer.perl -l fr \
   < $WORKING_DIR/test.translated.ia-fr.fr >$WORKING_DIR/translated.detok.ia-fr.fr
$MOSES_SRCDIR/scripts/tokenizer/detokenizer.perl -l fr \
   < $WORKING_DIR/corpus/test.ia-fr.true.fr >$WORKING_DIR/reference.detok.ia-fr.fr
   
echo "Calculating sacreBLEU and ChrF++ on generated translations..."
echo "BLEU:"
sacrebleu $WORKING_DIR/reference.detok.ia-fr.fr -i $WORKING_DIR/translated.detok.ia-fr.fr -m bleu -b -w 4 --sentence-level > bleu_resfile.txt
echo "ChrF++:"
sacrebleu $WORKING_DIR/reference.detok.ia-fr.fr -i $WORKING_DIR/translated.detok.ia-fr.fr -m chrf -b -w 4 --sentence-level > chrf_resfile.txt

