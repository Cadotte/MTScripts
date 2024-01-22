# MTScripts

Series of Shell scripts for Machine Translation, to serve as examples for MT projects. These scripts are derived from scripts I used during for my masters thesis (M. Sc. in Computer Science).

Note: In all these examples, "src" is the source language and "tgt" is the target language, to be replaced for example with the actual ISO codes for the chosen languages.

## Transformer (NMT)

Scripts to train a Transformer NMT model, based on train, valid and test sets. These scripts are partly adapted from fairseq scripts (https://github.com/facebookresearch/fairseq)

### transformer/prepare_transformer_ia-fr.sh
Pre-processing (tokenizing, punctuation standardization, etc.) and segmentation steps. Segmentation is performed by training & applying a sentencepiece BPE model.
Preprocessing requires Moses scripts and segmentation requires fairseq scripts.

### transformer/train-evaluate_transformer_ia-fr.sh
Training and evaluation of Transformer model using pre-processed train, valid and test sets. Both steps require fairseq scripts.

### transformer/use-interactive_transformer_ia-fr.sh
Interactively use the model trained with train-evaluate_transformer_ia-fr.sh script to produce translations (from ia to fr). This requires fairseq scripts.

## Statistical (SMT)

Scripts to train a SMT model, based on train, valid and test sets. These scripts are partly adapted from Moses SMT examples (http://www2.statmt.org/moses/) and require Moses scripts to function properly. 

### statistical/preprocessing.sh
Pre-process all sets (tokenizing, truecasing).

### statistical/training.sh
Train SMT model.

### statistical/tuning.sh
Tune model resulting from training step on valid parallel set.

### statistical/testing.sh
Produces translation hypotheses for sentences in test set, compare them to reference translation and produce BLEU (sacrebleu) and Chrf++ scores.
The scoring step requires sacrebleu (https://github.com/mjpost/sacrebleu).

