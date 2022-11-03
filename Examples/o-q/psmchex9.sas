/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: PSMCHEX09                                           */
/*   TITLE: Documentation Example 9 for PROC PSMATCH            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Propensity score matching                           */
/*   PROCS: PSMATCH                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC PSMATCH, EXAMPLE 9                             */
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

data drugs;
   set drugs;
   PatientID= _n_;

   LDL= 4*rannor(611213);
   if (Drug='Drug_X') then LDL= 2 + 3*rannor(960303);

   if (Gender='Female') then LDL= LDL + 2 + 0.5*rannor(890221);
   if (BMI < 25) then LDL= LDL + 1.5 + 0.5*rannor(890221);
   if (Age < 40) then LDL= LDL + 1.5 + 0.5*rannor(890221);

   LDL= 0.01 *int(100*LDL);
run;

proc print data=Drugs(obs=8);
   var PatientID Drug Gender Age BMI;
run;

proc psmatch data=drugs region=cs;
   class Drug Gender;
   psmodel Drug(Treated='Drug_X')= Gender Age BMI;
   match method=optimal(k=1) exact=Gender distance=lps caliper=0.25
         weight=none;
   output out(obs=match)=Outgs lps=_Lps matchid=_MatchID;
run;

data Cholesterol;
   set Outgs;
   keep PatientID LDL;
run;

proc sort data=Outgs out=Outgs1;
   by PatientID;
run;

proc sort data=Cholesterol out=Cholesterol1;
   by PatientID;
run;

data OutEx9a;
   merge Outgs1 Cholesterol1;
   by PatientID;
run;

proc print data=OutEx9a(obs=8);
   var PatientID Drug Gender Age BMI LDL _MatchID;
run;

proc sort data=OutEx9a out=OutEx9b;
   by _MatchID Drug;
run;

proc transpose data=OutEx9b out=OutEx9c;
   by _MatchID;
   var LDL;
run;

data OutEx9c;
   set OutEx9c;
   Diff= Col2 - Col1;
   drop Col1 COl2;
run;

proc print data=OutEx9c(obs=4);
run;

ods select TestsForLocation;
proc univariate data=OutEx9c;
   var Diff;
   ods output TestsForLocation=LocTest;
run;

data SgnRank;
   set LocTest;
   nPairs=113;
   if (Test='Signed Rank');
   SgnRank= Stat + nPairs*(nPairs+1)/4;
   keep nPairs SgnRank;
run;

proc print data=SgnRank;
   var nPairs SgnRank;
run;

data Test1;
   set SgnRank;
   mean0     = nPairs*(nPairs+1)/2;
   variance0 = mean0*(2*nPairs+1)/3;

   do Gamma=1 to 1.5 by 0.05;
      mean     = Gamma/(1+Gamma) * mean0;
      variance = Gamma/(1+Gamma)**2 * variance0;
      tTest    = (SgnRank - mean) / sqrt(variance);
      pValue   = 1 - probt(tTest, nPairs-1);
      output;
   end;
 run;

 proc print data=Test1;
 run;
