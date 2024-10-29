

proc import datafile='\\apporto.com\dfs\UNCC\Users\douenden_uncc\Downloads\Airfoil.xlsx'
DBMS=xlsx out=airfoil replace; 

proc print data=airfoil;
run; 

/*Sampling 70:30 using random sampling method*/

proc surveyselect data=airfoil samprate= 0.7out=sample outallmethod=srs;
run;

proc print data=sample;
run;
data train; set sample;
if (selected =1) thenoutput;run;

data test; set sample;
if (selected =0) thenoutput;run; 

proc print data=train; 
run;

proc univariate data=train normalplot;
var frequency angle chord_length velocity thickness sound_level;
run; 

proc reg data=train; 
model sound_level = frequency angle chord_length velocity thickness / tolvif
collin;

plotr.*p.;
run; 

data mod_test; set test;
y_bar = 132.693 + (-0.00132*Frequency) + (-0.43238*Angle) +
(-35.85593*Chord_length) +(0.10621*velocity) + 
(-138.69674*thickness); 

Predicted_err = ((Sound_level -y_bar)**2); 
run; 
proc print data=mod_test;
run;
proc print data = mod_test;
