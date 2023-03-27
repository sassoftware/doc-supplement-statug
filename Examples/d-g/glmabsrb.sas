/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: GLMABSRB                                            */
/*   TITLE: Details Example 3 for PROC GLM                      */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Absorption in ANOVA                                 */
/*   PROCS: GLM                                                 */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC GLM, DETAILS EXAMPLE 3.                        */
/*    MISC:                                                     */
/****************************************************************/


/* Savings in Computing by Using the ABSORB Statement ----------*/

data a;
   do herd=1 to 40;
      do cow=1 to 30;
         do treatment=1 to 3;
            do rep=1 to 2;
               y = herd/5 + cow/10 + treatment + rannor(1);
               output;
            end;
         end;
      end;
   end;
run;

proc glm data=a;
   absorb herd cow;
   class treatment;
   model y = treatment;
run;

