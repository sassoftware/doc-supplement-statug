/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: FACTPRIN                                            */
/*   TITLE: Principal Components Analysis of Car Preferences    */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: factor analysis, multivariate analysis              */
/*   PROCS: CORR FACTOR SGRENDER TEMPLATE SCORE SORT TRANSPOSE  */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

*---------------------------------------------------------------------+
|                                                                     |
|   Define Macro For Names of Ratings                                 |
|                                                                     |
+---------------------------------------------------------------------;

%let ratings = MPG Reliable Acceleration Braking Handling Ride Visibility
Comfort Quiet Cargo;

*---------------------------------------------------------------------+
|                                                                     |
|   Read Data                                                         |
|                                                                     |
+---------------------------------------------------------------------;

data cars;
   title 'Car Preferences';
   length Origin $8;
   input Make $1-10 Model $12-22 @24 (&ratings) (1.) origin $35
         @37 (Pref1-Pref25) (1.);
   if origin='E'|origin='J' then Import='Yes';
                            else import='No';
   if origin='A' then origin='AMC     ';
   if origin='C' then origin='Chrysler';
   if origin='F' then origin='Ford    ';
   if origin='G' then origin='GMC     ';
   if origin='E' then origin='Europe  ';
   if origin='J' then origin='Japan   ';
   datalines;
Cadillac   Eldorado    3234543533 G 0807990491240508971093809
Chevrolet  Chevette    5335425223 G 0051200423451043003515698
Chevrolet  Citation    4155555525 G 0453305814161643544747795
Chevrolet  Malibu      3333444544 G 0627400723121345545668658
Ford       Fairmont    3324345434 F 0224006715021443530648655
Ford       Mustang     3244323222 F 0507197705021101850657555
Ford       Pinto       4134313222 F 0021000303030201500514078
Honda      Accord      5554533433 J 9556897609699952998975078
Honda      Civic       5545435434 J 8436709507488852567765075
Lincoln    Continental 2453353555 F 0708990592230409962091909
Plymouth   Gran Fury   2134353535 C 0706000434101107333458708
Plymouth   Horizon     4345535235 C 0305005635461302444675655
Plymouth   Volare      2153333424 C 0405003614021602754476555
Pontiac    Firebird    1153551231 G 1007895613201206958265907
Volkswagen Dasher      5355545435 E 8458696508877795377895000
Volkswagen Rabbit      5454535424 E 8458509709695795487885000
Volvo      DL          4524555555 E 9989998909999987989919000
;

proc print;
   id make model origin import;
run;

*---------------------------------------------------------------------+
|                                                                     |
|   Compute Standardized Principal Component Scores                   |
|                                                                     |
+---------------------------------------------------------------------;

ods graphics on;
proc factor data=cars n=2 score outstat=fact plots(nplot=2)=all;
   var pref1-pref25;
   title2 'Principal Components of the Preferences';
run;

proc score data=cars score=fact out=prin;
   var pref1-pref25;
run;

*---------------------------------------------------------------------+
|                                                                     |
|   List Cars Sorted By Principal Components                          |
|                                                                     |
+---------------------------------------------------------------------;

%macro listpc(var);
   proc sort data=prin;
      by &var;
   run;

   proc print;
      id make model;
      var &var;
   run;
%mend;

title2 'Sorted by First Principal Component';
%listpc(factor1);

title2 'Sorted by Second Principal Component';
%listpc(factor2);

*---------------------------------------------------------------------+
|                                                                     |
|   Plot Principal Components                                         |
|                                                                     |
+---------------------------------------------------------------------;

proc template;
   define statgraph scatter;
      begingraph / designheight=defaultdesignwidth;
         entrytitle 'Plots of the First Two Principal Components';
         layout lattice / rows=2 columns=2 rowgutter=10 columngutter=10;
            scatterplot x=factor1 y=factor2 / markercharacter=origin;
            scatterplot x=factor1 y=factor2 / markercharacter=make;
            scatterplot x=factor1 y=factor2 / markercharacter=model;
         endlayout;
      endgraph;
   end;
run;

proc sgrender data=prin template=scatter;
run;

*---------------------------------------------------------------------+
|                                                                     |
|   Plot Both Cars And Component Pattern                              |
|                                                                     |
+---------------------------------------------------------------------;

data pat;
   set fact;
   drop _type_;
   if _type_='PATTERN';
   _name_ = compress(_name_, 'actor');
run;

proc transpose out=pat;
run;

data biplot(keep=F: _n: car);
   merge pat prin;
   _name_ = compress(_name_, 'Pref');
   Car = trim(make) || ' ' || model;
run;

proc template;
   define statgraph biplot;
      begingraph;
         entrytitle 'Biplot Showing Both Cars and Preference Vectors';
         layout overlayequated;
            scatterplot x=factor1 y=factor2 / datalabel=car;
            vectorplot x=f1 y=f2 xorigin=0 yorigin=0 / datalabel=_name_;
         endlayout;
      endgraph;
   end;
run;

proc sgrender data=biplot template=biplot;
run;

*---------------------------------------------------------------------+
|                                                                     |
|   Plot Both Cars And Attribute Vectors                              |
|                                                                     |
+---------------------------------------------------------------------;

proc corr data=prin nosimple noprob outp=attcor;
   var factor1-factor2;
   with &ratings;
run;

data attcor;
   set attcor;
   drop _type_;
   if _type_='CORR';
run;

data attrplot(keep=F: _n: car);
   merge attcor(rename=(factor1=F1 factor2=F2)) prin;
   Car = trim(make) || ' ' || model;
run;

proc template;
   define statgraph attrplot;
      begingraph;
         entrytitle 'Plot Showing Both Cars and Attribute Vectors';
         layout overlayequated;
            scatterplot x=factor1 y=factor2 / datalabel=car;
            vectorplot x=f1 y=f2 xorigin=0 yorigin=0 / datalabel=_name_;
         endlayout;
      endgraph;
   end;
run;

proc sgrender data=attrplot template=attrplot;
run;

ods graphics off;
