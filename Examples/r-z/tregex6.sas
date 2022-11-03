
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: TREGEX6                                             */
/*   TITLE: Documentation Example 6 for PROC TRANSREG           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: marketing research                                  */
/*   PROCS: TRANSREG PRINQUAL                                   */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC TRANSREG, EXAMPLE 6                            */
/*    MISC:                                                     */
/****************************************************************/

title 'Preference Ratings for Automobiles Manufactured in 1980';

options validvarname=any;

data CarPreferences;
   input Make $ 1-10 Model $ 12-22 @25 ('1'n-'25'n) (1.)
         MPG Reliability Ride;
   datalines;
Cadillac   Eldorado     8007990491240508971093809 3 2 4
Chevrolet  Chevette     0051200423451043003515698 5 3 2
Chevrolet  Citation     4053305814161643544747795 4 1 5
Chevrolet  Malibu       6027400723121345545668658 3 3 4
Ford       Fairmont     2024006715021443530648655 3 3 4
Ford       Mustang      5007197705021101850657555 3 2 2
Ford       Pinto        0021000303030201500514078 4 1 1
Honda      Accord       5956897609699952998975078 5 5 3
Honda      Civic        4836709507488852567765075 5 5 3
Lincoln    Continental  7008990592230409962091909 2 4 5
Plymouth   Gran Fury    7006000434101107333458708 2 1 5
Plymouth   Horizon      3005005635461302444675655 4 3 3
Plymouth   Volare       4005003614021602754476555 2 1 3
Pontiac    Firebird     0107895613201206958265907 1 1 5
Volkswagen Dasher       4858696508877795377895000 5 3 4
Volkswagen Rabbit       4858509709695795487885000 5 4 3
Volvo      DL           9989998909999987989919000 4 5 5
;


ods graphics on;

* Compute Coordinates for a 2-Dimensional Scatter Plot of Automobiles;
proc prinqual data=CarPreferences out=PResults(drop='1'n-'25'n)
              n=2 replace standard scores mdpref=2;
   id Model MPG Reliability Ride;
   transform identity('1'n-'25'n);
   title2 'Multidimensional Preference (MDPREF) Analysis';
   ods output mdprefplot=md;
run;

options validvarname=v7;

title2 'Preference Mapping (PREFMAP) Analysis';

* Add the Labels from the Plot to the Results Data Set;
data plot;
   if 0 then set md(keep=prin:);
   set presults;
run;

* Compute Endpoints for MPG and Reliability Vectors;
proc transreg data=plot rsquare;
   Model identity(MPG Reliability)=identity(Prin1 Prin2);
   output tstandard=center coordinates replace out=TResult1;
   id Model;
run;

* Compute Ride Ideal Point Coordinates;
proc transreg data=plot rsquare;
   Model identity(Ride)=point(Prin1 Prin2);
   output tstandard=center coordinates replace noscores out=TResult2;
   id Model;
run;

proc print;
run;
