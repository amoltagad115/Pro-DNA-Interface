shuf -n 94 Energy_matrix_sum>TRAIN70
#awk -F: 'FNR==NR {a[$1]++; next} !a[$1]' TRAIN70 Energy_matrix_sum >TEST30


awk '{print $4,$2}' TRAIN70 > TRAIN70_ELEC	
awk '{print $4,$3}' TRAIN70 > TRAIN70_LJ	
awk '{print $4,$5}' TRAIN70 > TRAIN70_TOTAL	

awk '{print $4,$2}' TEST30 > TEST30_ELEC	
awk '{print $4,$3}' TEST30 > TEST30_LJ	
awk '{print $4,$5}' TEST30 > TEST30_TOTAL	

gnuplot -p<<PLOT
m=1.0;
c=1.0;
f(x)=m*x+c;

fit f(x) 'TRAIN70_TOTAL' using 1:2 via m,c

set print "temp_total"
print m,c
PLOT

var1=$(awk '{print $1}' temp_total)
var2=$(awk '{print $2}' temp_total)

sed "s/4444/$var1/g" gen_test.cpp > gen_test_total.cpp
sed -i "s/333/$var2/g" gen_test_total.cpp
sed "s/4444/$var1/g" gen_train.cpp >gen_train_total.cpp
sed -i "s/333/$var2/g" gen_train_total.cpp

g++ gen_test_total.cpp
./a.out<TEST30_TOTAL>out_TOTAL_TEST
g++ gen_train_total.cpp
./a.out<TRAIN70_TOTAL>out_TOTAL_TRAIN

var3=$(tail -1 out_TOTAL_TEST)
var4=$(tail -1 out_TOTAL_TRAIN)


gnuplot -p<<PLOT
set term post color enhanced font "Times,22"
set output "Total_rmsd.ps"

set xlabel "Total energy/kJ mol^{-1}" font "Times-Roman,20"
set ylabel "Residuals/kJ mol^{-1}"  font "Times-Roman,20"

set title "Test $var3, Train $var4"
set xrange [-55000:-5000]

set arrow from -55000, 0 to -5000, 0 dt 2 lw 4 lc rgb "black" nohead
set xtics -50000,10000,-10000 font "Times-Roman,18"
set ytics font "Times-Roman,18"
set border lw 2

plot "out_TOTAL_TEST" u 2:4 w p pt 7 lc rgb "red" title "Test data", "out_TOTAL_TRAIN" u 2:4 w p pt 7 lc rgb "green" title "Training data"

PLOT

ps2pdf Total_rmsd.ps

gnuplot -p<<PLOT
set term post color enhanced font "Times,22"
set output "Total.ps"

set xlabel "Matrix Sum" font "Times-Roman,20"
set ylabel "Total Energy/kJ mol^{-1}" font "Times-Roman,20"

#set title "Test $var3, Train $var4"
#set xrange [-55000:-5000]

#set arrow from -55000, 0 to -5000, 0 dt 2 lw 4 lc rgb "black" nohead
#set xtics -50000,10000,-10000

m=$var1
c=$var2
f(x)=m*x+c

set border lw 2
plot "out_TOTAL_TEST" u 1:2 w p pt 7 lc rgb "red" title "Test data", "out_TOTAL_TRAIN" u 1:2 w p pt 7 lc rgb "green" title "Training data", f(x) w l lw 4 title "f(x)"

PLOT

ps2pdf Total.ps




gnuplot -p<<PLOT
m=1.0;
c=1.0;
f(x)=m*x+c;

fit f(x) 'TRAIN70_ELEC' using 1:2 via m,c

set print "temp_elec"
print m,c
PLOT

var1=$(awk '{print $1}' temp_elec)
var2=$(awk '{print $2}' temp_elec)

sed "s/4444/$var1/g" gen_test.cpp > gen_test_elec.cpp
sed -i "s/333/$var2/g" gen_test_elec.cpp
sed "s/4444/$var1/g" gen_train.cpp >gen_train_elec.cpp
sed -i "s/333/$var2/g" gen_train_elec.cpp

g++ gen_test_elec.cpp
./a.out<TEST30_ELEC>out_ELEC_TEST
g++ gen_train_elec.cpp
./a.out<TRAIN70_ELEC>out_ELEC_TRAIN

var3=$(tail -1 out_ELEC_TEST)
var4=$(tail -1 out_ELEC_TRAIN)


gnuplot -p<<PLOT
set term post color enhanced font "Times,22"
set output "Elec_rmsd.ps"

set xlabel "Electrostatic energy/kJ mol^{-1}"
set ylabel "Residuals/kJ mol^{-1}"

set title "Test $var3, Train $var4"
set xrange [-55000:-5000]

set arrow from -55000, 0 to -5000, 0 dt 2 lw 4 lc rgb "black" nohead
set xtics -50000,10000,-10000

set border lw 2

plot "out_ELEC_TEST" u 2:4 w p pt 7 lc rgb "red" title "Test data", "out_ELEC_TRAIN" u 2:4 w p pt 7 lc rgb "green" title "Training data"

PLOT

ps2pdf Elec_rmsd.ps

gnuplot -p<<PLOT
set term post color enhanced font "Times,22"
set output "Elec.ps"

set xlabel "Matrix Sum"
set ylabel "Electrostatic Energy/kJ mol^{-1}"

#set title "Test $var3, Train $var4"
#set xrange [-55000:-5000]

#set arrow from -55000, 0 to -5000, 0 dt 2 lw 4 lc rgb "black" nohead
#set xtics -50000,10000,-10000

m=$var1
c=$var2
f(x)=m*x+c

set border lw 2
plot "out_ELEC_TEST" u 1:2 w p pt 7 lc rgb "red" title "Test data", "out_ELEC_TRAIN" u 1:2 w p pt 7 lc rgb "green" title "Training data", f(x) w l lw 4 title "f(x)"

PLOT

ps2pdf Elec.ps

gnuplot -p<<PLOT
m=0.0;
c=0.0;
f(x)=m*x+c;

fit f(x) 'TRAIN70_LJ' using 1:2 via m,c

set print "temp_LJ"
print m,c
PLOT

var1=$(awk '{print $1}' temp_LJ)
var2=$(awk '{print $2}' temp_LJ)


sed "s/4444/$var1/g" gen_test.cpp > gen_test_lj.cpp
sed -i "s/333/$var2/g" gen_test_lj.cpp
sed "s/4444/$var1/g" gen_train.cpp >gen_train_lj.cpp
sed -i "s/333/$var2/g" gen_train_lj.cpp

g++ gen_test_lj.cpp
./a.out<TEST30_LJ>out_LJ_TEST
g++ gen_train_lj.cpp
./a.out<TRAIN70_LJ>out_LJ_TRAIN

var3=$(tail -1 out_LJ_TEST)
var4=$(tail -1 out_LJ_TRAIN)


gnuplot -p<<PLOT
set term post color enhanced font "Times,22"
set output "LJ_rmsd.ps"

set xlabel "LJ energy/kJ mol^{-1}"
set ylabel "Residuals/kJ mol^{-1}"

set title "Test $var3, Train $var4"
#set xrange [-55000:-5000]

#set arrow from -55000, 0 to -5000, 0 dt 2 lw 4 lc rgb "black" nohead
#set xtics -50000,10000,-10000

set border lw 2
plot "out_LJ_TEST" u 2:4 w p pt 7 lc rgb "red" title "Test data", "out_LJ_TRAIN" u 2:4 w p pt 7 lc rgb "green" title "Training data"

PLOT

ps2pdf LJ_rmsd.ps

gnuplot -p<<PLOT
set term post color enhanced font "Times,22"
set output "LJ.ps"

set xlabel "Matrix Sum"
set ylabel "LJ Energy/kJ mol^{-1}"

#set title "Test $var3, Train $var4"
#set xrange [-55000:-5000]

#set arrow from -55000, 0 to -5000, 0 dt 2 lw 4 lc rgb "black" nohead
#set xtics -50000,10000,-10000

m=$var1
c=$var2
f(x)=m*x+c

set border lw 2
plot "out_LJ_TEST" u 1:2 w p pt 7 lc rgb "red" title "Test data", "out_LJ_TRAIN" u 1:2 w p pt 7 lc rgb "green" title "Training data", f(x) w l lw 4 title "f(x)"

PLOT

ps2pdf LJ.ps
