mkdir Analysis; cd Analysis
mkdir CA-O5;cd CA-O5
cd ../../pdb .
rm comb_all_pdb_res_ID_res_ID junk
for i in $(cat pdb)
do
   cat ../../$i/pdb_res_ID_res_ID_dist >> junk
done
awk '{ if (NF ==7) print $1,"\t",$2,"\t",$3,"\t",$4,"\t",$5,"\t",$7; else print $0}' junk | awk '{ if ( $6 <=1.2)  print $0 }'  > comb_pdb_res_ID_res_ID_dist

###################### Relpace the A,T,G,C by DA,DT,DG,DC#################################################################################
awk '{ if ($2 =="T") print $1,"\t","DT","\t",$3,"\t",$4,"\t",$5,"\t",$6; else if ($2 =="G") print $1,"\t","DG","\t",$3,"\t",$4,"\t",$5,"\t",$6; else if($2 =="C") print $1,"\t","DC","\t",$3,"\t",$4,"\t",$5,"\t",$6; else if ($2 =="A") print $1,"\t","DA","\t",$3,"\t",$4,"\t",$5,"\t",$6; else print $1,"\t",$2,"\t",$3,"\t",$4,"\t",$5,"\t",$6 }' comb_pdb_res_ID_res_ID_dist > junk
mv junk comb_pdb_res_ID_res_ID_dist
###################Only keep the DA,DT,DG,DC residue, remove all other######################################################################
awk '{ if ($2 =="DA"||$2 =="A" ||$2 =="DG"||$2 =="G"||$2 =="DT"||$2 =="T"||$2 =="DC"||$2 =="C") print $0 }' comb_pdb_res_ID_res_ID_dist | awk '{ if ($4=="ALA" || $4=="ARG" || $4=="ASN" || $4=="ASP" || $4=="CYS" || $4=="GLU" || $4=="GLN" || $4=="GLY" || $4=="HIS" || $4=="ILE" || $4=="LEU" || $4=="LYS" || $4=="MET" || $4=="PHE" || $4=="PRO" || $4=="SER" || $4=="THR" || $4=="TRP" || $4=="TYR" || $4=="VAL") print $0 }' > DA_DT_DC_DG_pro_std
rm total_pro_res junk res_distribution res total_pro_res_per_pdb
rm junk res 
###################################To calculate the exact protein residue present in the DNA-Protein complex#####################
for i in $(cat pdb)
do
     awk '$1 =="'$i'"' DA_DT_DC_DG_pro_std | sort -k 5n | awk '!_[$5]++' > total_pro_res
     cat total_pro_res >> total_pro_res_per_pdb
###############################To calculate the total residuewise contribution in the DNA-Protein complex#####################
    for j in ALA ARG ASN ASP CYS GLU GLN GLY HIS ILE LEU LYS MET PHE PRO SER THR TRP TYR VAL
    do
         echo "$i $j" >> res
         grep -c "$j" total_pro_res  >> junk
    done
    echo "$i"
done
paste res junk > res_distribution
rm res junk total_pro_res
######################################Used cutoff distance ###############################################################
rm -r cutoff1
mkdir cutoff1
cd cutoff1
#####################################To calculate residue within cutoff################################################
for m in 1.00 0.60 0.65 0.70 0.75 0.80 1.20
do 
    mkdir $m
    cd $m
    awk '{ if ($6 <= '$m') print $0 }' ../../DA_DT_DC_DG_pro_std > cutoff_$m
    rm res res_$m res_distrib_$m sum 
    cp ../../pdb .
######################################To calculate the exact residue and contribution of each within cutoff range wrt pdb_id##################################
    for i in $(cat pdb)
    do
        awk '$1 == "'$i'"' cutoff_$m | sort -k 5n | awk '!_[$5]++' > total
        cat total >> total_pro_res_per_pdb
        for j in ALA ARG ASN ASP CYS GLU GLN GLY HIS ILE LEU LYS MET PHE PRO SER THR TRP TYR VAL
        do
             echo "$i $j" >>res
             grep -c "$j" total >> res_$m
        done
    done
    paste res res_$m  > res_distrib_$m
##########################################To compare the total residue present and residue present within cutoff in the Pro-DNA complex wrt pdb_id#####
    paste ../../res_distribution res_distrib_$m | awk '{ if ($3=="0") print $1,"\t",$2,"\t",$3,"\t",$6,"\t",0; else print $1,"\t",$2,"\t",$3,"\t",$6,"\t",(($6/$3)*100) }'> pro_total_within_cutoff_per
    wc_l=$(grep -c "ALA" pro_total_within_cutoff_per)
    for j in ALA ARG ASN ASP CYS GLU GLN GLY HIS ILE LEU LYS MET PHE PRO SER THR TRP TYR VAL
    do
       echo "$j" >>res1
       awk '$2 == "'$j'"' pro_total_within_cutoff_per | awk '{SUM5+=$5 ; SUM3+=$3 ; SUM4+=$4  }END{print SUM3,"\t",SUM4,"\t",((SUM4/SUM3)*100),"\t",SUM5/452}' >> sum
    done
##########################################To calculate the contribution wrt the average of overall and individual pdb_id (%)############################ 
    paste res1 sum > res_withcut_$m
    rm *.xvg res1 res
    cd ../
done 
#########################################################END###################################################################################
