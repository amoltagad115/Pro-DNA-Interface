# This script used to download the pdb from RCSB database, select only those pdb structure has nucleotide greater than 60 and remove non-standard nucleotide and protein residues from pdb file. 

#All PDB ID are present in the pdb file

############ Download PDB structure ###########################
path=$(pwd)
for k in $(cat pdb)
do
#  wget used to download the pdb file from the RCSB database
   wget https://ftp.rcsb.org/download/$k.pdb
   count=$(grep "O5'" "$k".pdb | wc -l)
#  Choose only those pdb structure has nucleotide greater than or equal to 60 for analysis

   if [ "$count" -ge 60 ]
   then
        mkdir "$k"
        cd "$k"
        mv ../"$k".pdb .
        echo "1" | gmx_20202_s editconf -f $k.pdb -o "$k"-mod.pdb -resnr 1 
        sed -i '1,4d' "$k"-mod.pdb
     #  remove all non-standard residues
        sed -i  '/ANISOU\|HETATM\|TITLE\|CONECT/d' "$k"-mod.pdb

    else
        rm "$k".pdb "$k"-mod.pdb
    fi
    cd $path
done
################ END ########################################

