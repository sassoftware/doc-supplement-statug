/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: PHRGS1                                              */
/*   TITLE: Getting Started Example 1 for PROC PHREG            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Classical Analysis of the Cox regression model,     */
/*          ODS Graphics                                        */
/*   PROCS: PHREG                                               */
/*    DATA: Kalbfleish and Prentice (1980), The Statistical     */
/*          Analysis of Failure Time Data," 1980, p. 2.         */
/*     REF: SAS/STAT User's Guide,  PROC PHREG Chapter          */
/*    MISC:                                                     */
/****************************************************************/

data Rats;
   label Days  ='Days from Exposure to Death';
   input Days Status Group @@;
   datalines;
143 1 0   164 1 0   188 1 0   188 1 0
190 1 0   192 1 0   206 1 0   209 1 0
213 1 0   216 1 0   220 1 0   227 1 0
230 1 0   234 1 0   246 1 0   265 1 0
304 1 0   216 0 0   244 0 0   142 1 1
156 1 1   163 1 1   198 1 1   205 1 1
232 1 1   232 1 1   233 1 1   233 1 1
233 1 1   233 1 1   239 1 1   240 1 1
261 1 1   280 1 1   280 1 1   296 1 1
296 1 1   323 1 1   204 0 1   344 0 1
;

data Regimes;
   Group=0;
   output;
   Group=1;
   output;
run;

ods graphics on;
proc phreg data=Rats plot(overlay)=survival;
   model Days*Status(0)=Group;
   baseline covariates=regimes out=_null_;
run;

proc phreg data=Rats;
   model Days*Status(0)=Group X;
   X=Group*(log(Days) - 5.4);
run;
