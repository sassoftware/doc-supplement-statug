/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: PSMCHEX6                                            */
/*   TITLE: Documentation Example 6 for PROC PSMATCH            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Propensity score matching                           */
/*   PROCS: PSMATCH                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC PSMATCH, EXAMPLE 6                             */
/*    MISC:                                                     */
/****************************************************************/

data School;
   Music= 'Yes';
   do j=1 to 60;
      if (ranuni(1312) > 0.4) then Gender='Female';
      else                         Gender='Male';

      Absence = ranexp(99);
      if (Absence < 0.5) then GPA= 4 + rannor(99)/3.5;
      else                    GPA= 4 - abs(rannor(99)/3.5);

      if (Gender='Female') then GPA= GPA + 0.02;

      id1= ranuni(99);
      id2= ranuni(99);
      output;
   end;

   Music= 'No';
   do j=1 to 100;

      Absence= ranexp(99);
      if (ranuni(99) > 0.45) then Gender='Female';
      else                        Gender='Male';
      if (Absence < 0.5) then GPA= 4 + rannor(99)/4.2;
      else                    GPA= 4 - abs(rannor(99)/4.2);

      id1= ranuni(99);
      id2= ranuni(99);
      output;
   end;

   do j=1 to 40;
      Absence= 2 + ranexp(99);
      if (ranuni(99) > 0.5) then Gender='Female';
      else                       Gender='Male';

      GPA= 3.4 - abs(rannor(99)/4.2);

      id1= ranuni(99);
      id2= ranuni(99);
      output;
   end;
run;

proc sort data=school;
   by id1;
run;

data school;
   set school;
   StudentID= _n_;
   Absence= int(Absence*100+0.5) / 100;
   GPA= int(GPA*100+0.5) / 100;
run;

proc sort data=school;
   by id2;
run;

ods graphics on;
proc psmatch data=School region=allobs(psmin=0.05);
   class Music Gender;
   psmodel Music(Treated='Yes')= Gender Absence;
   match method=replace(k=1) distance=ps exact=Gender caliper=.
         nmatchmost=6;
   assess ps var=(Gender Absence);
   output out(obs=match)=outex6 matchid=_MatchID;
run;

proc sort data=OutEx6 out=OutEx6a;
   by descending _MatchID;
run;

proc print data=OutEx6a(obs=10);
   var StudentID Music Gender Absence _PS_ _MATCHWGT_ _MatchID;
run;
