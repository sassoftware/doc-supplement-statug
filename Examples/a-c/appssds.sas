/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: APPSSDS                                             */
/*   TITLE: Example From Special SAS Data Sets Appendix         */
/* PRODUCT: SAS/STAT                                            */
/*  SYSTEM: ALL                                                 */
/*    KEYS: correlation, covariance                             */
/*   PROCS: REG                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

title 'Five Socioeconomic Variables';
title2 'Harman (1976), Modern Factor Analysis, Third Edition';

data SocEcon;
   input Pop School Employ Services House;
   datalines;
5700     12.8      2500      270       25000
1000     10.9      600       10        10000
3400     8.8       1000      10        9000
3800     13.6      1700      140       25000
4000     12.8      1600      140       25000
8200     8.3       2600      60        12000
1200     11.4      400       10        16000
9100     11.5      3300      60        14000
9900     12.5      3400      180       18000
9600     13.7      3600      390       25000
9600     9.6       3300      80        12000
9400     11.4      4000      100       13000
;

proc corr noprint out=corrcorr;
run;

proc print data=corrcorr;
run;

proc contents data=corrcorr;
run;

title 'Five Socioeconomic Variables';

data datacorr(type=corr);
   infile cards missover;
   _type_='corr';
   input _Name_ $ Pop School Employ Services House;
   datalines;
Pop        1.00000
School     0.00975   1.00000
Employ     0.97245   0.15428   1.00000
Services   0.43887   0.69141   0.51472   1.00000
House      0.02241   0.86307   0.12193   0.77765   1.00000
;

proc print data=datacorr;
run;

proc reg data=SocEcon outest=regest covout;
   full:   model house=pop school employ services / noprint;
   empser: model house=employ services / noprint;
quit;

proc print data=regest;
run;

proc reg data=SocEcon outsscp=regsscp;
   model house=pop school employ services / noprint;
quit;

proc print data=regsscp;
run;

