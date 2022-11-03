
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SVMEX5                                              */
/*   TITLE: Documentation Example 5 for PROC SURVEYMEANS        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: survey sampling, categorical data analysis          */
/*    KEYS: stratification, clustering, replication             */
/*    KEYS: unequal weighting, descriptive statistics           */
/*   PROCS: SURVEYMEANS                                         */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SURVEYMEANS, Example 5                         */
/*                                                              */
/*    MISC: Variance Estimation Using Replication Methods       */
/*                                                              */
/****************************************************************/

proc format;
   value $line
      F='F-Market & Wharves'
      J='J-Church'
      K='K-Ingleside'
      L='L-Taraval'
      M='M-Ocean View'
      N='N-Judah';
run;

/* Generate hypothetical data set MUNIsurvey                    */
data p;
   input p @@ ;
   weight=int(120/12+120/9+420/10+120/9+360/15)/2;
   datalines;
0.06 0.053 0.04 0.05 0.10 0.09 0.13 0.12 0.02 0.03 0.04
0.05 0.05 0.055 0.01 0.04 0.05 0.001 0.004 0.005 0.002
;

data f1;
   line='F'; vehicle=1;
   do passenger=1 to 65;
      waittime=rantbl(200,0.06,0.053,0.04,0.05,0.10,0.09, 0.13,
                      0.12,0.02,0.03,0.04,0.05,0.05,0.055,0.01,
                      0.04,0.05,0.001,0.004,0.005,0.002)-1;
      output;
   end;
run;

data f2;
   line='F'; vehicle=2;
   do passenger=1 to 102;
      waittime=rantbl(103,0.06,0.053,0.04,0.05,0.10,0.09,0.13,
                      0.12,0.02,0.03,0.04,0.05,0.05,0.055,0.01,
                      0.04,0.05,0.001,0.004,0.005,0.002)-1;
      output;
   end;
run;

data f;
   set f1 f2;
   weight=int(70/15+120/6+420/8+120/7+360/15)/2;
run;

data j1;
   line='J'; vehicle=1;
      do passenger=1 to 101;
         waittime=rantbl(2,0.06,0.003,0.04,0.05,0.10,0.09,0.13,
                         0.12,0.12,0.03,0.04,0.05,0.05,0.055,0.03,
                         0.04,0.05,0.001,0.004,0.025,0.002)-1;
         output;
      end;
run;

data j2;
   line='J'; vehicle=2;
   do passenger=1 to 142;
      waittime=rantbl(7,0.06,0.053,0.04,0.09,0.13,0.05,0.10,0.12,
                      0.02,0.03,0.04,0.05,0.05,0.004,0.005,0.002,
                      0.055,0.01,0.04,0.05,0.001)-1;
      output;
   end;
run;

data j;
   set j1 j2;
   weight=int(120/15+120/9+420/10+120/9+360/15)/2;
run;

data k1;
   line='K'; vehicle=1;
   do passenger=1 to 145;
      waittime=rantbl(111,0.06,0.003,0.04,0.05,0.10,0.09,0.13,0.12,
                      0.12,0.03,0.04,0.05,0.05,0.055,0.03,0.04,0.05,
                      0.001,0.004,0.025,0.002)-1;
      output;
   end;
run;

data k2;
   line='K'; vehicle=2;
   do passenger=1 to 180;
      waittime=rantbl(71,0.06,0.053,0.04,0.09,0.13,0.05,0.10,0.12,
                      0.02,0.03,0.04,0.05,0.05,0.004,0.005,0.002,
                      0.055,0.01,0.04,0.05,0.001)-1;
      output;
   end;
run;

data k;
   set k1 k2;
   weight=int(120/15+120/9+420/10+120/9+360/15)/2;
run;

data L1;
   line='L'; vehicle=1;
   do passenger=1 to 135;
      waittime=rantbl(1110,0.06,0.003,0.05,0.05,0.04,0.05,0.10,0.09,
                      0.13,0.12,0.12,0.03,0.04,0.055,0.03,0.04,0.05,
                      0.001,0.004,0.025,0.002)-1;
      output;
   end;
run;

data L2;
   line='L'; vehicle=2;
   do passenger=1 to 185;
      waittime=rantbl(18,0.02,0.03,0.04,0.055,0.09,0.053,0.04,0.09,
                      0.13,0.05,0.10,0.12,0.04,0.05,0.05,0.004,0.005,
                      0.002,0.025,0.01,0.001)-1;
      output;
   end;
run;

data l; set L1 L2;
   weight=int(120/8+120/10+420/8+120/9+360/15+300/30)/2;
run;

data m1;
   line='M'; vehicle=1;
   do passenger=1 to 139;
      waittime=rantbl(1150,0.06,0.03,0.05,0.05,0.14,0.05,0.10,0.09,0.03,
                      0.12,0.12,0.03,0.04,0.015,0.03,0.02,0.05,0.001,
                      0.004,0.025,0.002)-1;
      output;
   end;
run;

data m2;
   line='M'; vehicle=2;
   do passenger=1 to 203;
      waittime=rantbl(1008,0.03,0.03,0.05,0.055,0.29,0.053,0.04,0.09,
                      0.13,0.05,0.10,0.12,0.04,0.05,0.02,0.004,0.005,
                      0.002,0.015,0.01,0.001)-1;
      output;
   end;
run;

data m;
   set m1 m2;
   weight=int(70/15+120/9+420/10+120/9+360/15)/2;
run;

data n1;
   line='N'; vehicle=1;
   do passenger=1 to 306;
      waittime=rantbl(1150,0.06,0.04,0.06,0.05,0.14,0.05,0.08,0.09,
                      0.03,0.12,0.12,0.03,0.04,0.015,0.03,0.02,0.05,
                      0.001,0.004,0.025,0.002)-1;
      output;
   end;
run;

data n2;
   line='N'; vehicle=2;
   do passenger=1 to 234;
      waittime=rantbl(1008,0.03,0.05,0.05,0.05,0.07,0.053,0.04,0.03,
                      0.23,0.05,0.10,0.08,0.04,0.05,0.02,0.004,0.005,
                      0.012,0.015,0.02,0.001)-1;
      output;
   end;
run;

data n;
   set n1 n2;
   weight=int(120/12+120/7+420/10+120/7+360/12+300/30);
run;

data MUNIsurvey;
   set f j k l m n;
   format line $line.;
run;


title 'MUNI Subway Passenger Waiting Time Survey Data';
proc print data=MUNIsurvey (obs=10);
run;

title 'MUNI Passenger Waiting Time Analysis Using BRR';
proc surveymeans data=MUNIsurvey mean varmethod=brr mean clm;
   strata line;
   cluster vehicle;
   var waittime;
   weight weight;
run;

title 'MUNI Passenger Waiting Time Analysis Using Jackknife';
proc surveymeans data=MUNIsurvey mean varmethod=jackknife mean clm;
   strata line;
   cluster vehicle;
   var waittime;
   weight weight;
run;
