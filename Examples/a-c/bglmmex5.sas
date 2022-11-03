/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: bglmmex5                                            */
/*   TITLE: Example 5 for PROC BGLIMM                           */
/*    DESC: Multinomial Distribution with Cumulative Links      */
/*     REF: STATLIB                                             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Multinomial, Cumulative Links                       */
/*   PROCS: BGLIMM                                              */
/*    DATA: Shoulder pain data                                  */
/*                                                              */
/*     REF:                                                     */
/****************************************************************/

data Shoulder_pain;
   input Trt$ Gender$ Age T1 T2 T3 T4 T5 T6 @@;
   ID = _n_;
   datalines;
y  f  64  1  1  1  1  1  1
y  m  41  3  2  1  1  1  1
y  f  77  3  2  2  2  1  1
y  f  54  1  1  1  1  1  1
y  f  66  1  1  1  1  1  1
y  m  56  1  2  1  1  1  1
y  m  81  1  3  2  1  1  1
y  f  24  2  2  1  1  1  1
y  f  56  1  1  1  1  1  1
y  f  29  3  1  1  1  1  1
y  m  65  1  1  1  1  1  1
y  f  68  2  1  1  1  1  2
y  m  77  1  2  2  2  2  2
y  m  35  3  1  1  1  3  3
y  m  66  2  1  1  1  1  1
y  f  70  1  1  1  1  1  1
y  m  79  1  1  1  1  1  1
y  f  65  2  1  1  1  1  1
y  f  61  4  4  2  4  2  2
y  f  67  4  4  4  2  1  1
y  f  32  1  1  1  2  1  1
y  f  33  1  1  1  2  1  2
n  f  20  5  2  3  5  5  4
n  f  50  1  5  3  4  5  3
n  f  40  4  4  4  4  1  1
n  m  54  4  4  4  4  4  3
n  m  34  2  3  4  3  3  2
n  f  34  3  4  3  3  3  2
n  m  56  3  3  4  4  4  3
n  f  82  1  1  1  1  1  1
n  m  56  1  1  1  1  1  1
n  m  52  1  5  5  5  4  3
n  f  65  1  3  2  2  1  1
n  f  53  2  2  3  4  2  2
n  f  40  2  2  1  3  3  2
n  f  58  1  1  1  1  1  1
n  m  63  1  1  1  1  1  1
n  f  41  5  5  5  4  3  3
n  m  72  3  3  3  3  1  1
n  f  60  5  4  4  4  2  2
n  m  61  1  3  3  3  2  1
;

data ShoulderData;
   set Shoulder_pain;
   array tt T1-T6;
   do over tt;
      Y    = tt;
      Time = _i_;
      output;
   end;
run;

proc format;
   value $abc 'y' = 'Active'
              'n' = 'Placebo';
   value $xyz 'f' = 'Female'
              'm' = 'Male';
run;

proc print data=ShoulderData(obs=18);
   var ID Trt Gender Age Time y;
   format Trt $abc. Gender $xyz.;
run;

proc bglimm data=ShoulderData seed=8875 nmc=10000 thin=2 dic;
   class ID Trt Gender;
   model y  = Trt Gender Age Time / dist=multinomial link=clogit;
   format Trt $abc. Gender $xyz. ;
run;

proc bglimm data=ShoulderData seed=8875 nmc=10000 thin=2 dic;
   class ID Trt Gender;
   model y  = Trt Gender Age Time / dist=multinomial link=clogit;
   random int / sub=ID s=(1 to 3);
   format Trt $abc. Gender $xyz. ;
run;

proc bglimm data=ShoulderData seed=8875 nmc=10000 thin=2 dic;
   class ID Trt Gender;
   model y  = Trt Gender Age Time / dist=multinomial link=clogit;
   random int / sub=ID s=(1 to 3);
   format Trt $abc. Gender $xyz. ;
   estimate 'Active vs Placebo' Trt 1 -1  / exp;
run;
