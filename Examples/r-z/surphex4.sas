/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SURPHEX4                                            */
/*   TITLE: Documentation Example 4 for PROC SURVEYPHREG        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: replicate weights, jackknife coefficients,          */
/*    KEYS: jackknife variance estimation,                      */
/*    KEYS: proportional hazards regression, censoring          */
/*   PROCS: SURVEYPHREG, SURVEYMEANS                            */
/*    DATA:                                                     */
/*                                                              */
/*                                                              */
/*     REF: PROC SURVEYPHREG, Example 4                         */
/*    MISC:                                                     */
/****************************************************************/
data LibrarySurvey;
   input Branch         2.
         SamplingWeight 7.2
         CheckOut       date10.
         CheckIn        date10.
         Age;
   datalines;
 1 103.60 08NOV2008 13NOV2008 18
 1 103.60 01OCT2008 07OCT2008 30
 1 103.60 05NOV2008 06NOV2008 73
 1 103.60 25OCT2008 26OCT2008 53
 1 103.60 09NOV2008 10NOV2008 55
 2 127.50 10DEC2008 15DEC2008 39
 2 127.50 19DEC2008         . 33
 2 127.50 26NOV2008 27NOV2008 41
 2 127.50 03NOV2008 07NOV2008 33
 3 128.75 28DEC2008 29DEC2008 41
 3 128.75 27OCT2008 28OCT2008 61
 3 128.75 09OCT2008 12OCT2008 35
 3 128.75 25DEC2008 26DEC2008 45
 4 111.89 13NOV2008 14NOV2008 49
 4 111.89 04OCT2008 05OCT2008 40
 4 111.89 19DEC2008 20DEC2008 19
 4 111.89 30NOV2008 01DEC2008 45
 4 111.89 20DEC2008 23DEC2008 43
 4 111.89 18DEC2008         . 20
 4 111.89 21DEC2008         . 36
 4 111.89 03DEC2008 04DEC2008 48
 4 111.89 29NOV2008 07DEC2008 27
 5 112.00 04OCT2008 05OCT2008 23
 5 112.00 14DEC2008 15DEC2008 56
 5 112.00 27NOV2008 28NOV2008 44
 5 112.00 10NOV2008 11NOV2008 38
 5 112.00 27NOV2008 28NOV2008 54
 5 112.00 28OCT2008 29OCT2008 57
 5 112.00 03OCT2008 04OCT2008 48
 5 112.00 01OCT2008 05OCT2008 27
 5 112.00 19OCT2008 22OCT2008 32
 6 112.33 08OCT2008 12OCT2008 14
 6 112.33 19OCT2008 25OCT2008 36
 6 112.33 13OCT2008 14OCT2008 54
 6 112.33 09DEC2008 10DEC2008 58
 6 112.33 13DEC2008 14DEC2008 41
 6 112.33 22DEC2008         . 31
 6 112.33 18DEC2008         . 25
 6 112.33 23NOV2008 26NOV2008 37
 6 112.33 01DEC2008 02DEC2008 55
 7 112.44 03OCT2008 04OCT2008 66
 7 112.44 10NOV2008 13NOV2008 33
 7 112.44 25NOV2008 27NOV2008 34
 7 112.44 23DEC2008 24DEC2008 44
 7 112.44 30NOV2008 04DEC2008 24
 7 112.44 02DEC2008 03DEC2008 47
 7 112.44 14NOV2008 17NOV2008 37
 7 112.44 28OCT2008 02NOV2008 34
 7 112.44 27NOV2008 03DEC2008 24
 8 118.41 20DEC2008 21DEC2008 57
 8 118.41 02NOV2008 03NOV2008 39
 8 118.41 03DEC2008         .  8
 8 118.41 14OCT2008 22OCT2008 36
 8 118.41 10NOV2008 11NOV2008 39
 8 118.41 02OCT2008 03OCT2008 38
 8 118.41 23NOV2008 24NOV2008 48
 8 118.41 21OCT2008 22OCT2008 54
 8 118.41 30NOV2008 01DEC2008 35
 8 118.41 06NOV2008 08NOV2008 35
 8 118.41 05DEC2008 06DEC2008 48
 8 118.41 01OCT2008 03OCT2008 42
 8 118.41 19NOV2008 23NOV2008 38
 8 118.41 17OCT2008 19OCT2008 45
 8 118.41 23DEC2008 24DEC2008 26
 8 118.41 28OCT2008 01NOV2008 30
 8 118.41 30OCT2008 01NOV2008 51
 9 118.29 01NOV2008 02NOV2008 62
 9 118.29 08DEC2008 14DEC2008 28
 9 118.29 10OCT2008 17OCT2008 26
 9 118.29 02OCT2008 06OCT2008 33
 9 118.29 06DEC2008 07DEC2008 40
 9 118.29 25NOV2008 02DEC2008 28
 9 118.29 21NOV2008 22NOV2008 53
 9 118.29 26OCT2008 27OCT2008 43
 9 118.29 08OCT2008 10OCT2008 28
 9 118.29 05DEC2008         . 12
 9 118.29 06OCT2008 10OCT2008 28
 9 118.29 15DEC2008 16DEC2008 38
 9 118.29 23DEC2008         . 28
 9 118.29 25NOV2008 26NOV2008 55
 9 118.29 21NOV2008 23NOV2008 49
 9 118.29 16OCT2008 17OCT2008 35
 9 118.29 22DEC2008         . 22
10 118.35 03DEC2008 07DEC2008 32
10 118.35 15DEC2008         . 15
10 118.35 01OCT2008 05OCT2008 28
10 118.35 18DEC2008 19DEC2008 44
10 118.35 29OCT2008 02NOV2008 38
10 118.35 12DEC2008 18DEC2008 13
10 118.35 07NOV2008 09NOV2008 51
10 118.35 20DEC2008 21DEC2008 59
10 118.35 21OCT2008 25OCT2008 23
10 118.35 15OCT2008 16OCT2008 48
10 118.35 23NOV2008 24NOV2008 54
10 118.35 18DEC2008 23DEC2008 27
10 118.35 03NOV2008 04NOV2008 54
10 118.35 12DEC2008 15DEC2008 38
10 118.35 14NOV2008 17NOV2008 29
10 118.35 11DEC2008 13DEC2008 35
10 118.35 21NOV2008 23NOV2008 46
;
data LibrarySurvey;
   set LibrarySurvey;
   Returned = (CheckIn ^= .);
   if (Returned) then
      lenBorrow = CheckIn                - CheckOut;
   else
   lenBorrow = input('31Dec2008',date9.) - CheckOut;
run;
data LibrarySurvey;
   set LibrarySurvey;
   randomorder = ranuni(12345);
run;
proc sort data = LibrarySurvey out = LibrarySurvey;
   by Branch randomorder;
run;
data LibrarySurvey;
   set LibrarySurvey;
   array nGroup{10} (2 2 2 4 4 4 4 8 8 8);
   GroupPSU = mod(_N_,nGroup{Branch});
   drop randomorder nGroup1 nGroup2 nGroup3 nGroup4
        nGroup5 nGroup6 nGroup7 nGroup8 nGroup9 nGroup10;
run;

proc surveymeans data = LibrarySurvey varmethod = jk
               (outweights = LibraryRepWeights outjkcoefs = LibraryJKCOEF);
   weight SamplingWeight;
   strata Branch;
   cluster GroupPSU;
   var Age;
run;
proc surveyphreg data = LibraryRepWeights varmethod = jk;
   weight SamplingWeight;
   repweights RepWt_: / jkcoefs = LibraryJKCOEF;
   model lenBorrow*Returned(0) = Age;
run;
