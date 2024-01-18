# Script written and adapted by Antoine Cadotte (2023-2024)
# Partly based on examples from Moses SMT (http://www2.statmt.org/moses/)

# Define paths
HOME_DIR=path/to/your/home/
WORKING_DIR=$HOME_DIR/path/to/project/smt/model_name.ia-fr
MOSES_SRCDIR=$HOME_DIR/path/to/tools/mosesdecoder

echo "Tuning model..."
# Tune model on valid test set
cd $WORKING_DIR
nohup nice $MOSES_SRCDIR/scripts/training/mert-moses.pl \
  $WORKING_DIR/corpus/valid.ia-fr.true.ia $WORKING_DIR/corpus/valid.ia-fr.true.fr \
  $MOSES_SRCDIR/bin/moses train/model/moses.ini --mertdir $MOSES_SRCDIR/bin/ \
  &> mert.out &
