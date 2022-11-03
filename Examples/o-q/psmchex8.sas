/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: PSMCHEX8                                            */
/*   TITLE: Documentation Example 8 for PROC PSMATCH            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Propensity score matching                           */
/*   PROCS: PSMATCH                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC PSMATCH, EXAMPLE 8                             */
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

      pscore= 4. - 0.35*Age + 0.35*BMI + 0.01*rannor(99);
      if (Gender='Female') then pscore= pscore - 0.2;

      id1= ranuni(99);
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
   if (porder < 100) then do;
      if (ranuni(99) < .45) then Drug= 'Drug_X';
      else                       Drug= 'Drug_A';
   end;
   else if (porder < 300) then do;
      if (ranuni(99) < .30) then Drug= 'Drug_X';
      else                       Drug= 'Drug_A';
   end;
   else if (porder < 450) then do;
      if (ranuni(99) < .15) then Drug= 'Drug_X';
      else                       Drug= 'Drug_A';
   end;
   else                          Drug= 'Drug_A';
run;

data drug5;
   set drug4;
   if (porder > 4);
run;

proc sort data=drug5;
   by id1;
run;

data drug5;
   set drug5;
   PatientID= _n_;
run;

proc sort data=drug5 out=drugs (keep=PatientID Drug Gender Age BMI);
   by jorder;
run;


ods select none;
proc logistic data=drugs;
   class Drug Gender;
   model Drug(Event='Drug_X')= Gender Age BMI / link=cloglog;
   output out=drug1 p=pscore;
run;
ods select all;

proc print data=drug1(obs=10);
   var PatientID Drug Gender Age BMI pscore;
run;

ods graphics on;
proc psmatch data=Drug1 region=cs;
   class Drug Gender;
   psdata treatvar=Drug(Treated='Drug_X') ps=pscore;
   match method=optimal(k=1) exact=Gender distance=lps caliper=0.5
         weight=none;
   assess lps var=(Gender Age BMI);
   output out(obs=match)=OutEx8 lps=_Lps matchid=_MatchID;
run;

proc sort data=OutEx8 out=OutEx8a;
   by _MatchID;
run;

proc print data=OutEx8a(obs=10);
   var PatientID Drug Gender Age BMI pscore _LPS _MatchWgt_ _MatchID;
run;
