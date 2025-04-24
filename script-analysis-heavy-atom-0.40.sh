mkdir heavy-atom-0.40; cd heavy-atom-0.40
cd ../../pdb .
rm comb_all_pdb_res_ID_res_ID
for i in $(cat pdb)
do
   cat  ../../$i/all_atom_dist_R_K_1.2_other_1.0/all_pdb_res_ID_res_ID >> comb_all_pdb_res_ID_res_ID
done
##################### Relpace the A,T,G,C by DA,DT,DG,DC#################################################################################
awk '{ if ($3 =="T") print $1,"\t",$2,"\t","DT","\t",$4,"\t",$5,"\t",$6,"\t",$7,"\t",$8; else if ($3 =="G") print $1,"\t",$2,"\t","DG","\t",$4,"\t",$5,"\t",$6,"\t",$7,"\t",$8; else if($3 =="C") print  $1,"\t",$2,"\t","DC","\t",$4,"\t",$5,"\t",$6,"\t",$7,"\t",$8; else if ($3 =="A") print $1,"\t",$2,"\t","DA","\t",$4,"\t",$5,"\t",$6,"\t",$7,"\t",$8; else print $1,"\t",$2,"\t",$3,"\t",$4,"\t",$5,"\t",$6,"\t",$7,"\t",$8 }' comb_all_pdb_res_ID_res_ID > junk
mv junk comb_all_pdb_res_ID_res_ID
##################Only keep the DA,DT,DG,DC residue, remove all other######################################################################
awk '{ if ($3 =="DA"||$3 =="A" ||$3 =="DG"||$3 =="G"||$3 =="DT"||$3 =="T"||$3 =="DC"||$3 =="C") print $0 }' comb_all_pdb_res_ID_res_ID | awk '{ if ($6=="ALA" || $6=="ARG" || $6=="ASN" || $6=="ASP" || $6=="CYS" || $6=="GLU" || $6=="GLN" || $6=="GLY" || $6=="HIS" || $6=="ILE" || $6=="LEU" || $6=="LYS" || $6=="MET" || $6=="PHE" || $6=="PRO" || $6=="SER" || $6=="THR" || $6=="TRP" || $6=="TYR" || $6=="VAL") print $0 }' > DA_DT_DC_DG_pro_std
rm total_pro_res junk res_distribution res
###############################To calculate the exact protein residue present in the DNA-Protein complex#####################
for i in $(cat pdb)
do
     grep "$i" DA_DT_DC_DG_pro_std >> DA_DT_DC_DG_pro_std-1
done

rm junk AA
awk -F"\t" '!seen[$1, $7 ]++ { print $6}' DA_DT_DC_DG_pro_std-1 > res
for j in ALA ARG ASN ASP CYS GLU GLN GLY HIS ILE LEU LYS MET PHE PRO SER THR TRP TYR VAL
do
      grep -c "$j" res >> junk
      echo "$j" >> AA
done
paste AA junk > res_distribution
rm AA junk 
######################################Used cutoff distance ###############################################################
rm -r cutoff1

mkdir cutoff1
cd cutoff1
#####################################To calculate residue within cutoff################################################
for m in 0.40 
do 
    rm -r $m
    mkdir $m
    cd $m
    mkdir AA-pho AA-sug AA-base Main-DNA Side-DNA Popul_AA
    awk '{ if ($8 <= '$m') print $0 }' ../../DA_DT_DC_DG_pro_std > cutoff_$m
    awk -F"\t" '!seen[$1, $7 ]++ { print $6}'  cutoff_$m > cutoff_AA


 
#    rm res res_$m res_distrib_$m sum 
    cp ../../pdb .
##########To calculate the exact residue and contribution of each within cutoff range wrt pdb_id##################################
    for j in ALA ARG ASN ASP CYS GLU GLN GLY HIS ILE LEU LYS MET PHE PRO SER THR TRP TYR VAL
    do
             echo "$j" >>res
             grep -c "$j" cutoff_AA >> junk4
    paste ../../res_distribution junk4 | awk '{ if ($2=="0") print $1,"\t",$2,"\t",$3,"\t",0; else print $1,"\t",$2,"\t",$3,"\t",(($3/$2)*100) }'> AA_distribution
    cd ../
done 

#########################################################END###################################################################################
