/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: gmxex19                                             */
/*   TITLE: Documentation Example 19 for PROC GLIMMIX           */
/*          Quadrature Method for Multilevel Models             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Generalized linear mixed models                     */
/*          Multilevel models                                   */
/*          Quadrature method                                   */
/*   PROCS: GLIMMIX                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/

data test;
   do school = 1 to 10;
      schef = rannor(1234)*4;
      do class = 1 to 5;
         clsef = rannor(2345)*2;
         program = ranbin(12345,1,.5);
         do student = 1 to 10;
            eta = 3 + program + schef + clsef ;
            p = 1/(1+exp(-eta));
            grade = ranbin(23456,1,p);
            output;
         end;
      end;
   end;
run;

proc glimmix data=test method = quad(qpoints=3);
   class school class program;
   model grade = program/s dist=binomial link=logit solution;
   random int /subject = school;
   random int /subject = class(school);
run;

data test;
   do school = 1 to 10;
      schef = rannor(1234)*4;
      do class = 1 to 10;
         clsef = rannor(2345)*2;
         program = ranbin(12345,1,.5);
         do student = 1 to 10;
            eta = 3 + program + schef + clsef ;
            p = 1/(1+exp(-eta));
            grade = ranbin(23456,1,p);
            output;
         end;
      end;
   end;
run;


proc glimmix data=test method = quad(qpoints=3 fastquad);
   class school class program;
   model grade = program/s dist=binomial link=logit solution;
   random int /subject = school;
   random int /subject = class(school);
run;

