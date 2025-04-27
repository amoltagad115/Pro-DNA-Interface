Here is a step-by-step guide to running the script for analyzing protein-DNA interface interactions:
Make PDB ID list and file named as pdb
Step-1 Download the PDB file
       bash download.sh

Step-2 Identify Cα - O5' Contacts at the interface
       bash step-1-CA-O5-contact.sh
#       Interface-residue pair(dist_IRP)

Step-3 To compute all heavy atom contact
       bash step-2-heavy-atom-contact.sh
#  atom pair contact (time-all-atom-R_K_1.2_other_1.0)

#########Analyze the data for all pdb data ###############
Step-4 To Analyze the CA-O5 contact 
       bash script-Analysis-CA-O5-contact.sh

Step-5 Analyze Heavy Atom Contacts
       bash script-analysis-heavy-atom-0.40.sh
##################END##################################


For machine learning 
proc.sh
gen_test.cpp
gen_train.cpp

run by (in working directory gen_test.cpp, gen_train.cpp and input file must present) 
./proc.sh 
