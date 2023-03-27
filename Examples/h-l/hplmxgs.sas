/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: HPLMXGS                                             */
/*   TITLE: Getting Started Example for PROC HPLMIXED           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Mixed Models, Analysis of Covariance                */
/*   PROCS: HPLMIXED                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC HPLMIXED, INTRODUCTORY EXAMPLE 1.              */
/*    MISC:                                                     */
/****************************************************************/

data SchoolSample;
   do SchoolID = 1 to 300;
      do nID = 1 to 25;
         Neighborhood = (SchoolID-1)*5 + nId;
         bInt   = 5*ranuni(1);
         bTime  = 5*ranuni(1);
         bTime2 =   ranuni(1);
         do sID = 1 to 2;
            do Time = 1 to 4;
               Math = bInt + bTime*Time + bTime2*Time*Time + rannor(2);
               output;
               end;
            end;
         end;
      end;
run;

proc hplmixed data=SchoolSample;
   class Neighborhood SchoolID;
   model Math = Time Time*Time / solution;
   random   int Time Time*Time / sub=Neighborhood(SchoolID) type=un;
run;


