/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: CTRTGS                                              */
/*   TITLE: Getting Started Example for PROC CAUSALTRT          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Inverse probability weights                         */
/*   PROCS: CAUSALTRT                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CAUSALTRT, GETTING STARTED EXAMPLE             */
/*    MISC:                                                     */
/****************************************************************/

data drug1;
   do jorder=1 to 490;
      if (ranuni(99) < .55) then Gender='Male  ';
      else                       Gender='Female';

      Age= 30 + 20*ranuni(99) + 3*rannor(9);
      if (Age < 25) then  Age= 20 - (Age-25)/2;
      Age= int(Age);

      BMI= 20 + 6*ranuni(99) + 0.02*Age + rannor(9);
      if (BMI < 18) then BMI= 18 - (BMI-18)/4;
      BMI= int(BMI*100) / 100;

      pscore= 4. - 0.25*Age + 0.2*BMI + 0.02*rannor(99);
      if (Gender='Female') then pscore= pscore - 0.2;
      output;
   end;
run;

proc sort data=drug1 out=drug2;
   by pscore;
run;
proc rank data=drug2 out=drug3 descending;
   var pscore;
   ranks porder;
run;

data drug4;
   set drug3;
   if (porder < 150) then do;
      if (ranuni(99) < .45) then Drug= 'Drug_X';
      else                       Drug= 'Drug_A';
   end;
   else if (porder < 300) then do;
      if (ranuni(99) < .35) then Drug= 'Drug_X';
      else                       Drug= 'Drug_A';
   end;
   else if (porder < 450) then do;
      if (ranuni(99) < .25) then Drug= 'Drug_X';
      else                       Drug= 'Drug_A';
   end;
   else                          Drug= 'Drug_A';
run;

data drug5;
   set drug4;
   if (porder > 4);
run;

proc sort data=drug5 out=drugs (keep=Drug Gender Age BMI);
   by jorder;
run;

data drug6;
   set drug5;
   pdev = -.1 + .02*age;
   if (Drug = 'Drug_X') then pdev = pdev -.2;
   if (Gender = 'Male') then pdev = pdev - .1;
   psdev = exp(pdev)/(1+exp(pdev));
   if (pdev > ranuni(99)) then Diabetes2 = 'Yes';
   else                      Diabetes2 = 'No';
run;

proc sort data=drug6 out=drugs (keep=Drug Gender Age BMI Diabetes2);
   by jorder;
run;

proc print data=drugs(obs=10);
run;

proc causaltrt data=drugs method=ipwr ppsmodel;
   class Gender;
   psmodel Drug(ref='Drug_A') = Age Gender BMI;
   model Diabetes2(ref='No') / dist = bin;
run;

proc causaltrt data=drugs method=aipw;
   class Gender;
   psmodel Drug(ref='Drug_A') = Age Gender BMI;
   model Diabetes2(ref='No') = Age Gender BMI / dist = bin;
run;
