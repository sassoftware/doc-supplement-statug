
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: GENMEX6                                             */
/*   TITLE: Example 6 for PROC GENMOD                           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: generalized linear models, GEEs, ALR algorithm      */
/*   PROCS: GENMOD                                              */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC GENMOD, EXAMPLE 6                              */
/*    MISC:                                                     */
/****************************************************************/


data resp;
   input center id treatment $ sex $ age baseline visit1-visit4;
   datalines;
1  1 P M 46 0 0 0 0 0
1  2 P M 28 0 0 0 0 0
1  3 A M 23 1 1 1 1 1
1  4 P M 44 1 1 1 1 0
1  5 P F 13 1 1 1 1 1
1  6 A M 34 0 0 0 0 0
1  7 P M 43 0 1 0 1 1
1  8 A M 28 0 0 0 0 0
1  9 A M 31 1 1 1 1 1
1 10 P M 37 1 0 1 1 0
1 11 A M 30 1 1 1 1 1
1 12 A M 14 0 1 1 1 0
1 13 P M 23 1 1 0 0 0
1 14 P M 30 0 0 0 0 0
1 15 P M 20 1 1 1 1 1
1 16 A M 22 0 0 0 0 1
1 17 P M 25 0 0 0 0 0
1 18 A F 47 0 0 1 1 1
1 19 P F 31 0 0 0 0 0
1 20 A M 20 1 1 0 1 0
1 21 A M 26 0 1 0 1 0
1 22 A M 46 1 1 1 1 1
1 23 A M 32 1 1 1 1 1
1 24 A M 48 0 1 0 0 0
1 25 P F 35 0 0 0 0 0
1 26 A M 26 0 0 0 0 0
1 27 P M 23 1 1 0 1 1
1 28 P F 36 0 1 1 0 0
1 29 P M 19 0 1 1 0 0
1 30 A M 28 0 0 0 0 0
1 31 P M 37 0 0 0 0 0
1 32 A M 23 0 1 1 1 1
1 33 A M 30 1 1 1 1 0
1 34 P M 15 0 0 1 1 0
1 35 A M 26 0 0 0 1 0
1 36 P F 45 0 0 0 0 0
1 37 A M 31 0 0 1 0 0
1 38 A M 50 0 0 0 0 0
1 39 P M 28 0 0 0 0 0
1 40 P M 26 0 0 0 0 0
1 41 P M 14 0 0 0 0 1
1 42 A M 31 0 0 1 0 0
1 43 P M 13 1 1 1 1 1
1 44 P M 27 0 0 0 0 0
1 45 P M 26 0 1 0 1 1
1 46 P M 49 0 0 0 0 0
1 47 P M 63 0 0 0 0 0
1 48 A M 57 1 1 1 1 1
1 49 P M 27 1 1 1 1 1
1 50 A M 22 0 0 1 1 1
1 51 A M 15 0 0 1 1 1
1 52 P M 43 0 0 0 1 0
1 53 A F 32 0 0 0 1 0
1 54 A M 11 1 1 1 1 0
1 55 P M 24 1 1 1 1 1
1 56 A M 25 0 1 1 0 1
2  1 P F 39 0 0 0 0 0
2  2 A M 25 0 0 1 1 1
2  3 A M 58 1 1 1 1 1
2  4 P F 51 1 1 0 1 1
2  5 P F 32 1 0 0 1 1
2  6 P M 45 1 1 0 0 0
2  7 P F 44 1 1 1 1 1
2  8 P F 48 0 0 0 0 0
2  9 A M 26 0 1 1 1 1
2 10 A M 14 0 1 1 1 1
2 11 P F 48 0 0 0 0 0
2 12 A M 13 1 1 1 1 1
2 13 P M 20 0 1 1 1 1
2 14 A M 37 1 1 0 0 1
2 15 A M 25 1 1 1 1 1
2 16 A M 20 0 0 0 0 0
2 17 P F 58 0 1 0 0 0
2 18 P M 38 1 1 0 0 0
2 19 A M 55 1 1 1 1 1
2 20 A M 24 1 1 1 1 1
2 21 P F 36 1 1 0 0 1
2 22 P M 36 0 1 1 1 1
2 23 A F 60 1 1 1 1 1
2 24 P M 15 1 0 0 1 1
2 25 A M 25 1 1 1 1 0
2 26 A M 35 1 1 1 1 1
2 27 A M 19 1 1 0 1 1
2 28 P F 31 1 1 1 1 1
2 29 A M 21 1 1 1 1 1
2 30 A F 37 0 1 1 1 1
2 31 P M 52 0 1 1 1 1
2 32 A M 55 0 0 1 1 0
2 33 P M 19 1 0 0 1 1
2 34 P M 20 1 0 1 1 1
2 35 P M 42 1 0 0 0 0
2 36 A M 41 1 1 1 1 1
2 37 A M 52 0 0 0 0 0
2 38 P F 47 0 1 1 0 1
2 39 P M 11 1 1 1 1 1
2 40 P M 14 0 0 0 1 0
2 41 P M 15 1 1 1 1 1
2 42 P M 66 1 1 1 1 1
2 43 A M 34 0 1 1 0 1
2 44 P M 43 0 0 0 0 0
2 45 P M 33 1 1 1 0 1
2 46 P M 48 1 1 0 0 0
2 47 A M 20 0 1 1 1 1
2 48 P F 39 1 0 1 0 0
2 49 A M 28 0 1 0 0 0
2 50 P F 38 0 0 0 0 0
2 51 A M 43 1 1 1 1 0
2 52 A F 39 0 1 1 1 1
2 53 A M 68 0 1 1 1 1
2 54 A F 63 1 1 1 1 1
2 55 A M 31 1 1 1 1 1
;
data resp;
   set resp;
   visit=1;  outcome=visit1;  output;
   visit=2;  outcome=visit2;  output;
   visit=3;  outcome=visit3;  output;
   visit=4;  outcome=visit4;  output;
run;

proc genmod data=resp;
   class id treatment(ref="P") center(ref="1") sex(ref="M")
      baseline(ref="0");
   model outcome(event='1')=treatment center sex age baseline / dist=bin;
   repeated  subject=id(center) / logor=fullclust;
run;

data zin;
   keep id center z1-z6 y1 y2;
   array zin(6) z1-z6;
   set resp;
   by center id;
   if first.id
      then do;
      t = 0;
      do m = 1 to 4;
         do n = m+1 to 4;
            do j = 1 to 6;
               zin(j) = 0;
            end;
            y1 = m;
            y2 = n;
            t + 1;
            zin(t) = 1;
            output;
         end;
      end;
   end;
run;

proc print data=zin (obs=12);
run;

proc genmod data=resp;
   class id treatment(ref="P") center(ref="1") sex(ref="M")
      baseline(ref="0");
   model outcome(event='1')=treatment center sex age baseline / dist=bin;
   repeated  subject=id(center) / logor=zfull
                                  zdata=zin
                                  zrow =(z1-z6)
                                  ypair=(y1 y2);
run;

