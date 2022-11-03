/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: probitex                                            */
/*   TITLE: Documentation Examples for PROC PROBIT              */
/*                                                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*                                                              */
/*   PROCS: PROBIT                                              */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data a;
   infile cards eof=eof;
   input Dose N Response @@;
   Observed= Response/N;
   output;
   return;
eof: do Dose=0.5 to 7.5 by 0.25;
        output;
     end;
   datalines;
1 10 1  2 12 2  3 10 4  4 10 5
5 12 8  6 10 8  7 10 10
;

ods graphics on;

proc probit log10;
   model Response/N=Dose / lackfit inversecl itprint;
   output out=B p=Prob std=std xbeta=xbeta;
run;

proc probit log10 plot=predpplot;
   model Response/N=Dose / d=logistic inversecl;
   output out=B p=Prob std=std xbeta=xbeta;
run;

data multi;
   input Prep $ Dose Symptoms $ N;
   LDose=log10(Dose);
   if Prep='test' then PrepDose=LDose;
   else PrepDose=0;
   datalines;
stand     10      None       33
stand     10      Mild        7
stand     10      Severe     10
stand     20      None       17
stand     20      Mild       13
stand     20      Severe     17
stand     30      None       14
stand     30      Mild        3
stand     30      Severe     28
stand     40      None        9
stand     40      Mild        8
stand     40      Severe     32
test      10      None       44
test      10      Mild        6
test      10      Severe      0
test      20      None       32
test      20      Mild       10
test      20      Severe     12
test      30      None       23
test      30      Mild        7
test      30      Severe     21
test      40      None       16
test      40      Mild        6
test      40      Severe     19
;

proc probit data=multi;
   class Prep;
   nonpara: model Symptoms(order=data)=Prep LDose PrepDose / lackfit;
   weight N;
run;

proc probit data=multi;
   class Prep;
   parallel: model Symptoms(order=data)=Prep LDose / lackfit;
   weight N;
run;

proc probit data=multi
            plots=(predpplot(level=("None" "Mild" "Severe"))
                   cdfplot(level=("None" "Mild" "Severe")));
   class Prep;
   parallel: model Symptoms(order=data)=Prep LDose / lackfit;
   weight N;
run;

data xrow;
   input Prep $ Dose Symptoms $ N;
   LDose=log10(Dose);
   datalines;
stand     40      Severe     32
run;

proc probit data=multi xdata=xrow
            plots=(predpplot(level=("None" "Mild" "Severe"))
                   cdfplot(level=("None" "Mild" "Severe")));
   class Prep;
   parallel: model Symptoms(order=data)=Prep LDose / lackfit;
   weight N;
run;

data news;
   input sex $ age subs @@;
   datalines;
Female     35    0   Male       44    0
Male       45    1   Female     47    1
Female     51    0   Female     47    0
Male       54    1   Male       47    1
Female     35    0   Female     34    0
Female     48    0   Female     56    1
Male       46    1   Female     59    1
Female     46    1   Male       59    1
Male       38    1   Female     39    0
Male       49    1   Male       42    1
Male       50    1   Female     45    0
Female     47    0   Female     30    1
Female     39    0   Female     51    0
Female     45    0   Female     43    1
Male       39    1   Male       31    0
Female     39    0   Male       34    0
Female     52    1   Female     46    0
Male       58    1   Female     50    1
Female     32    0   Female     52    1
Female     35    0   Female     51    0
;

proc format;
   value subscrib 1 = 'accept' 0 = 'reject';
run;

proc probit data=news;
   class sex;
   model subs(event="accept")=sex age / d=logistic itprint;
   format subs subscrib.;
   store out=LogitModel;
run;

data test;
   input sex $ age;
   datalines;
Female     35
;

proc plm restore=LogitModel;
   score data=test out=testout predicted / ilink;
run;

proc print data=testout;
run;

data epidemic;
   input treat$ dose n r sex @@;
   label dose = Dose;
   datalines;
A  2.17 142 142  0   A   .57 132  47  1  A  1.68 128 105  1   A  1.08 126 100  0
A  1.79 125 118  0   B  1.66 117 115  1  B  1.49 127 114  0   B  1.17  51  44  1
B  2.00 127 126  0   B   .80 129 100  1
;

data xval;
   input treat $ dose sex;
   datalines;
B  2.  1
;

proc probit optc lackfit covout data=epidemic
            outest = out1 xdata = xval
            Plots=(predpplot ippplot lpredplot);
   class treat sex;
   model r/n = dose treat sex sex*treat/corrb covb inversecl;
   output out = out2 p =p;
run;

proc print data=out1;
run;

proc probit data=epidemic;
   class treat sex;
   model r/n = dose treat sex treat*sex;
   slice treat*sex / diff;
   effectplot;
run;
