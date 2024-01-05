/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SASHELP                                             */
/*   TITLE: Documentation Examples for SASHELP Data Sets        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: REG, PRINT, FREQ, CONTENTS                          */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

proc reg data=sashelp.Class;
   model weight = height;
quit;

/*---------------Uncomment to run these next steps----------------
ods select none;
proc contents data=sashelp._all_;
   ods output members=m;
run;
ods select all;

proc print;
   where memtype = 'DATA';
run;

proc contents data=sashelp._all_;
run;
*/

title 'Baseball Data';
proc contents data=sashelp.Baseball varnum;
   ods select position;
run;

title 'The First Five Observations Out of 322';
proc print data=sashelp.Baseball(obs=5);
run;

title 'BEI Data';
proc contents data=sashelp.bei varnum;
   ods select position;
run;

title 'The First Five Observations Out of 23,905';
proc print data=sashelp.bei(obs=5);
run;

title 'The Trees Variable';
proc freq data=sashelp.bei;
   tables Trees;
run;

title '2003 Birth Weight Data';
proc contents data=sashelp.BirthWgt varnum;
   ods select position;
run;

title 'The First Five Observations Out of 100,000';
proc print data=sashelp.BirthWgt (obs=5);
run;

title 'BMIMen Data';
proc contents data=sashelp.bmimen varnum;
   ods select position;
run;

title 'The First Five Observations Out of 3,264';
proc print data=sashelp.bmimen(obs=5);
run;

title 'Burrows Data';
proc contents data=sashelp.burrows varnum;
   ods select position;
run;

title 'The First Five Observations Out of 24,591';
proc print data=sashelp.burrows(obs=5);
run;

proc format;
   value bf -1 = "Killed by Predator" 0 = "Failed" 1 = "Successful";
run;

title 'The Status Variable';
proc freq data=sashelp.burrows;
   tables status;
   format status bf.;
run;

title 'Bone Marrow Transplant Data';
proc contents data=sashelp.BMT varnum;
   ods select position;
run;

title 'The First Five Observations Out of 137';
proc print data=sashelp.BMT(obs=5);
run;

title 'The Risk Group Variable';
proc freq data=sashelp.BMT;
   tables group;
run;

title '1997 Birth Weight Data';
proc contents data=sashelp.BWeight varnum;
   ods select position;
run;

title 'The First Five Observations Out of 50,000';
proc print data=sashelp.BWeight(obs=5);
run;

title 'Class Data';
proc contents data=sashelp.Class varnum;
   ods select position;
run;

title 'The Full Data Set';
proc print data=sashelp.Class;
run;

title 'Comet Data';
proc contents data=sashelp.Comet varnum;
   ods select position;
run;

title 'The First Five Observations Out of 4,050';
proc print data=sashelp.Comet(obs=5);
run;

title 'El Nino Southern Oscillation Data';
proc contents data=sashelp.ENSO varnum;
   ods select position;
run;

title 'The First Five Observations Out of 168';
proc print data=sashelp.ENSO(obs=5);
run;

title 'Finland''s Lake Laengelmaevesi Fish Catch Data';
proc contents data=sashelp.Fish varnum;
   ods select position;
run;

title 'The First Five Observations Out of 159';
proc print data=sashelp.Fish(obs=5);
run;

title 'The Fish Species Variable';
proc freq data=sashelp.Fish;
   tables species;
run;

title 'Exhaust Emissions Data';
proc contents data=sashelp.Gas varnum;
   ods select position;
run;

title 'The First Five Observations Out of 171';
proc print data=sashelp.Gas(obs=5);
run;

title 'The Fuel Type Variable';
proc freq data=sashelp.Gas;
   tables fuel;
run;

title 'Fisher (1936) Iris Data';
proc contents data=sashelp.Iris varnum;
   ods select position;
run;

title 'The First Five Observations Out of 150';
proc print data=sashelp.Iris(obs=5);
run;

title 'The Iris Species Variable';
proc freq data=sashelp.Iris;
   tables species;
run;

title 'Junk Email Data';
proc contents data=sashelp.JunkMail varnum;
   ods select position;
run;

title 'The First Five Observations Out of 4,601';
proc print data=sashelp.JunkMail(obs=5);
run;

title 'Leukemia Training Data';
proc contents data=sashelp.LeuTrain varnum;
   ods select position;
run;

title 'The First Five Observations and 11 Variables';
proc print data=sashelp.LeuTrain(obs=5);
   var y x1-x10;
run;

title 'Leukemia Type Variable';
proc freq data=sashelp.LeuTrain;
   tables y;
run;

title 'Leukemia Test Data';
proc contents data=sashelp.LeuTest varnum;
   ods select position;
run;

title 'The First Five Observations and 11 Variables';
proc print data=sashelp.LeuTest(obs=5);
   var y x1-x10;
run;

title 'Leukemia Type Variable';
proc freq data=sashelp.LeuTest;
   tables y;
run;

title 'Margarine Data';
proc contents data=sashelp.Margarin varnum;
   ods select position;
run;

title 'The First Six Observations Out of 20,430';
proc print data=sashelp.Margarin(obs=6);
run;

title 'Flying Mileages between 10 US Cities Data';
proc contents data=sashelp.Mileages varnum;
   ods select position;
run;

title 'The Full Data Set';
proc print data=sashelp.Mileages noobs;
   id city;
run;

title 'Earthquake Locations in the United States';
proc contents data=sashelp.Quakes varnum;
   ods select position;
run;

title 'The First Five Observations Out of 15,578';
proc print data=sashelp.Quakes(obs=5);
run;

title 'Hot Spring Locations in the United States';
proc contents data=sashelp.Springs varnum;
   ods select position;
run;

title 'The First Five Observations Out of 1,587';
proc print data=sashelp.Springs(obs=5);
run;

title 'Coal Seam Thickness Data';
proc contents data=sashelp.Thick varnum;
   ods select position;
run;

title 'The First Five Observations Out of 75';
proc print data=sashelp.Thick(obs=5);
run;

title 'US 1980 Presidential Election Data';
proc contents data=sashelp.vote1980 varnum;
   ods select position;
run;

title 'The First Five Observations Out of 3,107';
proc print data=sashelp.vote1980(obs=5);
run;

