/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SEQTEX6                                             */
/*   TITLE: Documentation Example 6 for PROC SEQTEST            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: group sequential test                               */
/*   PROCS: SEQDESIGN, SEQTEST, LIFETEST                        */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SEQTEST, EXAMPLE 6                             */
/*    MISC:                                                     */
/****************************************************************/

ods graphics on;
proc seqdesign boundaryscale=score
               ;
   OneSidedWhitehead: design method=whitehead
                             nstages=4
                             boundarykey=alpha
                             alt=upper  stop=both
                             beta=0.20;
   samplesize model=twosamplesurvival
                    ( nullhazard=0.03466
                      hazard=0.01733
                      accrate=10);
run;

proc seqdesign boundaryscale=score
               ;
   OneSidedWhitehead: design method=whitehead
                             nstages=4
                             boundarykey=alpha
                             alt=upper
                             stop=both
                             beta=0.20;
   samplesize model=twosamplesurvival
                    ( nullhazard=0.03466
                      hazard=0.01733
                      accrate=10 acctime=20);
   ods output Boundary=Bnd_Surv;
run;

data weeks;
   TrtGp= 0;
   do jt=1 to 20;
      do j=1 to 5;
         Weeks= int(ranexp(527151)/0.035);
         output;
      end;
   end;
   TrtGp= 1;
   do jt=1 to 20;
      do j=1 to 5;
         Weeks= int(ranexp(527151)/0.017);
         output;
      end;
   end;
run;
proc sort data= weeks;
   by jt j TrtGp;
run;
data Surv_1;
   set weeks;
   if (jt <= 12);
   Event= 0;
   if (Weeks <= 12-jt) then Event= 1;
   else                     Weeks= 12-jt;
run;
data Surv_2;
   set weeks;
   Event= 0;
   if (jt <= 18);
   if (Weeks <= 18-jt) then Event= 1;
   else                     Weeks= 18-jt;
run;
data Surv_3;
   set weeks;
   Event= 0;
   if (Weeks <= 22-jt) then Event= 1;
   else                     Weeks= 22-jt;
run;
data Surv_4;
   set weeks;
   Event= 0;
   if (Weeks <= 27-jt) then Event= 1;
   else                     Weeks= 27-jt;
run;
proc print data=Surv_1(obs=10);
   var TrtGp Event Weeks;
   title 'First 10 Obs in the Trial Data';
run;

proc lifetest data=Surv_1;
   time Weeks*Event(0);
   test TrtGp;
   ods output logunichisq=Parms_Surv1;
run;

data Parms_Surv1;
   set Parms_Surv1(rename=(Statistic=Estimate));
   if Variable='TrtGp';
   _Scale_='Score';
   _Stage_= 1;
   keep Variable _Scale_ _Stage_ StdErr Estimate;
run;

proc print data=Parms_Surv1;
   title 'Statistics Computed at Stage 1';
run;

proc seqtest Boundary=Bnd_Surv
             Parms(Testvar=TrtGp)=Parms_Surv1
             infoadj=none
             boundaryscale=score
             ;
   ods output Test=Test_Surv1;
run;

proc lifetest data=Surv_1;
   time Weeks*Event(0);
   test TrtGp;
   ods output logunichisq=Parms_Surv1a;
run;

data Parms_Surv1a;
   set Parms_Surv1a(rename=(Statistic=TrtGp));
   keep _Scale_ _Stage_ _Info_ TrtGp;
   _Scale_='Score';
   _Stage_= 1;
   _Info_= StdErr * StdErr;
   if Variable='TrtGp';
run;

proc print data=Parms_Surv1a;
   title 'Statistics Computed at Stage 1';
run;

proc seqtest Boundary=Bnd_Surv
             Data(Testvar=TrtGp)=Parms_Surv1a
             infoadj=none
             boundaryscale=score
             ;
   ods output Test=Test_Surv1;
run;

proc lifetest data=Surv_2;
   time Weeks*Event(0);
   test TrtGp;
   ods output logunichisq=Parms_Surv2;
run;

data Parms_Surv2;
   set Parms_Surv2 (rename=(Statistic=Estimate));
   if Variable='TrtGp';
   _Scale_='Score';
   _Stage_= 2;
   keep Variable _Scale_ _Stage_ StdErr Estimate;
run;

proc print data=Parms_Surv2;
   title 'Statistics Computed at Stage 2';
run;

proc seqtest Boundary=Test_Surv1
             Parms(Testvar=TrtGp)=Parms_Surv2
             infoadj=none
             boundaryscale=score
             citype=lower
             ;
   ods output Test=Test_Surv2;
run;
