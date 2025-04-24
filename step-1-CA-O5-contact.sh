#  pdb file contain only those pdb-id having nucleotide more than or equal to 60
ls -d */ | sed 's,/,,g' > pdb
#        STEP-1 To identify the interface residue Pairs
#     file are the list of PDBID used for study
path=$(pwd)
for k in $(cat pdb)
do
        cd $k
#       make index for CA (amino acids) and O5' (nucleotide)
        grep "CA" $k-mod.pdb | awk '{if ($1=="ATOM") print $2 }' > pro
        grep "CA" $k-mod.pdb | awk '{if ($1=="ATOM") print $4"_"$5"_"$6 }' > PRO-res
        grep "O5'" $k-mod.pdb | awk '{if ($1=="ATOM") print $4"_"$5"_"$6 }' > DNA-res
        grep "O5'" $k-mod.pdb | awk '{ if ($1=="ATOM") print $2 }' > DNA
        for i in $(cat DNA-res)
        do
            for j in $(cat PRO-res)
            do
               echo "$k $i $j" >> res
        done
        done
        
        for i in $(cat DNA)
        do
            for j in $(cat pro)
            do
               echo "[ $i-$j ]" >>index.ndx  
               echo "$i $j" >> index.ndx
        done
        done
        wc=$(grep "\[" index.ndx | wc -l | awk '{ print $1-1 }') 
        seq 0 $wc > index
#          Compute the distance between CA-O5’ pairs (residue pair-wise distance)
             gmx_20202_s distance -f $k-mod.pdb -s $k-mod.pdb -n index.ndx -pbc no -oav avg_dist.xvg  < index
             grep -w "0.000" avg_dist.xvg | fmt -1 | sed 1d | paste res - > pdb_res_dist
             sed  's/_/ /g' pdb_res_dist > pdb_res_dist1
             awk '{ if (length($3) ==1 && length($6)==1) print $1,"\t",$2,"\t",$4,"\t",$5,"\t",$7,"\t",$8,"\t",$9,"\t",$10,"\t",$11; else if (length($3) >=2 && length($5)==1) print $1,"\t",$2,"\t",$3,"\t",$4,"\t",$6,"\t",$7,"\t",$8,"\t",$9,"\t",$10; else if (length($3) ==1 && length($6)>=2) print $1,"\t",$2,"\t",$4,"\t",$5,"\t",$6,"\t",$7,"\t",$8,"\t",$9,"\t",$10;else if (length($3) >=2 && length($6)>=2) print $1,"\t",$2,"\t",$3,"\t",$4,"\t",$5,"\t",$6,"\t",$7,"\t",$8,"\t",$9 }' pdb_res_dist1 > pdb_res_ID_res_ID_dist
             rm pdb_res_dist1 
      
#  select only those residue pair fall within cut-off 1.2 nm for R and K and rest 1.0 nm

   rm -r all_atom_dist_R_K_1.2_other_1.0
   mkdir all_atom_dist_R_K_1.2_other_1.0
   cd all_atom_dist_R_K_1.2_other_1.0
   cp ../pdb_res_dist .
   cp ../$k-mod.pdb .
   awk '{ if (($3 ~/ARG|\LYS/ && $4 <=1.2) || ($3 !~/ARG|\LYS/ && $4 <=1.0)) print $0 }' pdb_res_dist > dist_IRP
cd $path
done

################## END #########################################


