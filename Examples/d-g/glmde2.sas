/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: GLMDE2                                              */
/*   TITLE: Details Example 2 for PROC GLM                      */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Effect size                                         */
/*   PROCS: GLM                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC GLM, DETAILS EXAMPLE 2.                        */
/*    MISC:                                                     */
/****************************************************************/


/* Effect Size Measures for F Tests in GLM ---------------------*/

data Test;
   do Task = 1 to 7;
      do Gender = 'M','F';
         do i = 1 to 4;
            input Response @@;
            output;
         end;
      end;
   end;
   datalines;
7.1 2.8 3.9 3.7     6.5 6.5 6.5 6.6
7.1 5.5 4.8 2.6     3.6 5.4 5.6 4.5
7.2 4.6 4.9 4.6     3.3 5.4 2.8 1.5
5.6 6.2 5.4 6.5     5.6 2.7 3.8 2.3
2.2 5.4 5.6 8.4     1.2 2.0 4.3 4.6
9.1 4.5 7.6 4.9     4.3 7.7 6.5 7.7
4.5 3.8 5.9 6.1     1.7 2.5 4.3 2.7
;

proc glm data=Test;
   class Gender Task;
   model Response = Gender|Task / ss1;
run;

/* Same Analysis with EFFECTSIZE Option and ALPHA=0.1 ----------*/

proc glm data=Test;
   class Gender Task;
   model Response = Gender|Task / ss1 effectsize alpha=0.1;
run;

