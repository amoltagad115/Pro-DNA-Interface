#     STEP-2 Compute the all heavy atom-to-atom distance for selected interface residue pairs


path=$(pwd)
for k in $(cat pdb)
do
     cd $k/all_atom_dist_R_K_1.2_other_1.0
# Make the index file of  inter-residue atom pair  for selected pair
   awk '{ print $2}' dist_IRP > group1
   awk '{ print $3}' dist_IRP > group2
   sed -i 's/_/ /g' group*
   awk '{ if (length($3) >4) print $2; else print $3}' group1 > G1 
   awk '{ if (length($3) >4) print $2; else print $3}' group2 > G2
   paste G1 G2 | awk '{ if ($1 ~ "[a-zA-Z]" || $2 ~ "[a-zA-Z]"); else print $0}' > part-1
   paste G1 G2 | awk '$1 ~ "[a-zA-Z]" || $2 ~ "[a-zA-Z]"' > part-2
   wc1=$(wc -l part-1 | awk '{ print $1 }')

#  Make index for heavy atom-to-atom for each Interface residue Pair
   for j in $(seq 1 $wc1)
   do
       GR1=$(awk 'NR=="'$j'"' part-1 |awk '{ print $1}')
       GR2=$(awk 'NR=="'$j'"' part-1 |awk '{ print $2}')
       awk '{if ($6=='$GR1' && ($3 !~/^H/)) print $2}' $k-mod.pdb > GR1_inde_p1
       awk '{if ($6=='$GR1' && ($3 !~/^H/)) print $3"_"$4"_"$5"_"$6}' $k-mod.pdb > GR1_atom
       awk '{if ($6=='$GR2' && ($3 !~/^H/)) print $2}' $k-mod.pdb > GR2_inde_p1
       awk '{if ($6=='$GR2' && ($3 !~/^H/)) print $3"_"$4"_"$5"_"$6}' $k-mod.pdb > GR2_atom
       for o in $(cat GR1_inde_p1)
       do
            for l in $(cat GR2_inde_p1)
            do
                echo "[ $o $l ]" >> index.ndx
                echo "$o $l" >> index.ndx
            done
       done
       for o in $(cat GR1_atom)
       do
            for l in $(cat GR2_atom)
            do
                echo "$k $o $l" >> atom_DNA_pro
            done
       done
     done            
     
     wc2=$(wc -l part-2 | awk '{ print $1 }')
     for j in $(seq 1 $wc2)
     do
         GR3=$(awk 'NR=="'$j'"' part-2 |awk '{ print $1}')
         GR4=$(awk 'NR=="'$j'"' part-2 |awk '{ print $2}')
         if [[ $GR3 =~ ^[a-zA-Z] ]] 
         then 
             grep -w "$GR3" $k-mod.pdb |awk '{ if ($3 !~/^H/) print $2}' > GR1_inde_p2
             grep -w "$GR3" $k-mod.pdb |awk '{ if ($3 !~/^H/) print $3"_"$4"_"$5}' > GR1_atom_p2
         else
             awk '{if ($6=='$GR3' && ($3 !~/^H/)) print $2}' $k-mod.pdb > GR1_inde_p2
             awk '{if ($6=='$GR3' && ($3 !~/^H/)) print $3"_"$4"_"$5"_"$6}' $k-mod.pdb > GR1_atom_p2
         fi
         if [[ $GR4 =~ ^[a-zA-Z] ]]  
         then 
              grep -w "$GR4" $k-mod.pdb |awk '{if ($3 !~/^H/) print $2}' > GR2_inde_p2
              grep -w "$GR4" $k-mod.pdb |awk '{ if ($3 !~/^H/) print $3"_"$4"_"$5}' > GR2_atom_p2
          else
             awk '{if ($6=='$GR4' && ($3 !~/^H/)) print $2}' $k-mod.pdb > GR2_inde_p2
             awk '{if ($6=='$GR4' && ($3 !~/^H/)) print $3"_"$4"_"$5"_"$6}' $k-mod.pdb > GR2_atom_p2
         fi
         for o in $(cat GR1_inde_p2)
         do
            for l in $(cat GR2_inde_p2)
            do
                echo "[ $o $l ]" >> index.ndx
                echo "$o $l" >> index.ndx
            done
        done
        for o in $(cat GR1_atom_p2)
        do
            for l in $(cat GR2_atom_p2)
            do
                echo "$k $o $l" >> atom_DNA_pro
            done
       done
     done  
     wc4=$(grep "\[" index.ndx | wc -l | awk '{ print $1-1 }')
     seq 0 $wc4 > index


#             Compute the heavy atom-to-atom distances 
              gmx_20202_s distance -f $k-mod.pdb -s $k-mod.pdb -n index.ndx -pbc no -oav junk.xvg  < index
              grep -w "0.000" junk.xvg | fmt -1 | sed 1d >> junk
              paste atom_DNA_pro junk > all_atom_dist
              sed -i 's/_/ /g' all_atom_dist
              awk '{ if (length($4) ==1 && length($8)==1) print $1,"\t",$2,"\t",$3,"\t",$5,"\t",$6,"\t",$7,"\t",$9,"\t",$10,"\t",$11; else if (length($4) >=2 && length($7)==1) print $1,"\t",$2,"\t",$3,"\t",$4,"\t",$5,"\t",$6,"\t",$8,"\t",$9,"\t",$10; else if (length($4) ==1 && length($8)>=2) print $1,"\t",$2,"\t",$3,"\t",$5,"\t",$6,"\t",$7,"\t",$8,"\t",$9,"\t",$10;else if (length($4) >=2 && length($8)>=2) print $1,"\t",$2,"\t",$3,"\t",$4,"\t",$5,"\t",$6,"\t",$7,"\t",$8,"\t",$9 }' all_atom_dist > all_pdb_res_ID_res_ID 
         cd ../../
         date > end3
         echo "$k" >>pdb-completed 
         echo "$k" | paste - start3 end3 >> time-all-atom-R_K_1.2_other_1.0
cd $path
done

########################## END ##################################


