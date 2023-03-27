/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: seqtex7                                             */
/*   TITLE: Documentation Example 7 for PROC SEQTEST            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential test                               */
/*   PROCS: SEQDESIGN, SEQTEST, PHREG                           */
/****************************************************************/

ods graphics on;
proc seqdesign altref=0.69315;
   TwoSidedPowerFamily: design method=pow
                               nstages=4
                               alpha=0.075(lower=0.025)
                               beta=0.20;
   samplesize model=phreg( xvariance=0.25 xrsquare=0.10
                           hazard=0.02451 accrate=10);
run;

proc seqdesign altref=0.69315;
   TwoSidedPowerFamily: design method=pow
                               nstages=4
                               alpha=0.075(lower=0.025)
                               beta=0.20;
   samplesize model=phreg( xvariance=0.25 xrsquare=0.10
                           hazard=0.02451
                           accrate=10 acctime=20);
   ods output Boundary=Bnd_Time;
run;

data weeks;
   TrtGp= 0;
   do jt=1 to 20;
      do j=1 to 5;
         Weeks= int(ranexp(127159)/0.020);
         output;
      end;
   end;
   TrtGp= 1;
   do jt=1 to 20;
      do j=1 to 5;
         Weeks= int(ranexp(127159)/0.021);
         output;
      end;
   end;
run;
data weeks;
   set weeks;
   Wgt= 24 + TrtGp + 2*rannor(127159);
run;
proc sort data= weeks;
   by jt j TrtGp;
run;
data Time_1;
   set weeks;
   if (jt <= 14);
   Event= 0;
   if (Weeks <= 14-jt) then Event= 1;
   else                     Weeks= 13-jt;
run;
data Time_2;
   set weeks;
   if (jt <= 20);
   Event= 0;
   if (Weeks <= 20-jt) then Event= 1;
   else                     Weeks= 19-jt;
run;
data Time_3;
   set weeks;
   Event= 0;
   if (Weeks <= 25-jt) then Event= 1;
   else                     Weeks= 24-jt;
run;
data Time_4;
   set weeks;
   Event= 0;
   if (Weeks <= 31-jt) then Event= 1;
   else                     Weeks= 30-jt;
run;
proc print data=Time_1(obs=10);
   var TrtGp Event Wgt Weeks;
   title 'First 10 Obs in the Trial Data';
run;

proc phreg data=Time_1;
   model Weeks*Event(0)= TrtGp Wgt;
   ods output parameterestimates=Parms_Time1;
run;

data Parms_Time1;
   set Parms_Time1;
   if Parameter='TrtGp';
   _Scale_='MLE';
   _Stage_= 1;
   keep _Scale_ _Stage_ Parameter Estimate StdErr;
run;

proc print data=Parms_Time1;
   title 'Statistics Computed at Stage 1';
run;

proc seqtest Boundary=Bnd_Time
             Parms(Testvar=TrtGp)=Parms_Time1
             infoadj=prop
             order=lr
             ;
   ods output Test=Test_Time1;
run;

proc phreg data=Time_2;
   model Weeks*Event(0)= TrtGp Wgt;
   ods output parameterestimates= Parms_Time2;
run;

data Parms_Time2;
   set Parms_Time2;
   if Parameter='TrtGp';
   _Scale_='MLE';
   _Stage_= 2;
   keep _Scale_ _Stage_ Parameter Estimate StdErr;
run;

proc seqtest Boundary=Test_Time1
             Parms(Testvar=TrtGp)=Parms_Time2
             infoadj=prop
             order=lr
             ;
   ods output Test=Test_Time2;
run;

proc phreg data=Time_3;
   model Weeks*Event(0)= TrtGp Wgt;
   ods output parameterestimates= Parms_Time3;
run;

data Parms_Time3;
   set Parms_Time3;
   if Parameter='TrtGp';
   _Scale_='MLE';
   _Stage_= 3;
   keep _Scale_ _Stage_ Parameter Estimate StdErr;
run;

proc seqtest Boundary=Test_Time2
             Parms(Testvar=TrtGp)=Parms_Time3
             infoadj=prop
             order=lr
             ;
   ods output Test=Test_Time3;
run;

proc phreg data=Time_4;
   model Weeks*Event(0)= TrtGp Wgt;
   ods output parameterestimates= Parms_Time4;
run;

data Parms_Time4;
   set Parms_Time4;
   if Parameter='TrtGp';
   _Scale_='MLE';
   _Stage_= 4;
   keep _Scale_ _Stage_ Parameter Estimate StdErr;
run;

proc print data=Parms_Time4;
   title 'Statistics Computed at Stage 4';
run;

proc seqtest Boundary=Test_Time3
             Parms(Testvar=TrtGp)=Parms_Time4
             order=lr
             ;
run;

