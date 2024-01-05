/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LOGIEX20                                            */
/*   TITLE: Example 20 for PROC LOGISTIC                        */
/*    DESC: Using the Optimal ROC Criteria                      */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binary response data                                */
/*   PROCS: LOGISTIC                                            */
/*    DATA: MROZ data set                                       */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC LOGISTIC chapter        */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 20: Using the Optimal ROC Criteria
*****************************************************************/

/*
The data in Example 19 were originally published by Mroz (1987) and
downloaded from Woolridge (2002).  This data set is based on a
sample of 753 married white women. The dependent variable is a
discrete measure of labor force participation
(\Variable{InLaborForce}). Explanatory variables are the number of
children age 5 or younger (\Variable{KidsLt6}), the number of
children ages 6 to 18 (\Variable{KidsGe6}), the woman's age
(\Variable{Age}), the woman's years of schooling
(\Variable{Education}), wife's labor experience
(\Variable{Experience}), square of experience
(\Variable{SqExperience}), and the family income excluding the
wife's wage (\Variable{IncomeExcl}).
*/

title 'Example 20: Using the Optimal ROC Criteria ;

proc logistic data=Mroz plots(only)=(roc pr)
   rocoptions(method=binormal area crossvalidate id=prob
              optimal=(youden cost(tp=0 tn=0 fp=1 fn=3)));
   model InLaborForce2(event='0') = IncomeExcl Education Experience
                         SqExperience Age KidsLt6 KidsGe6 / outroc=outr;
   id InLaborForce;
   output out=out predprobs=x;
data _null_; 
   set outr; 
   if _optcost_=1 | _optyouden_=1; 
   put _optcost_ _optyouden_ _prob_; 
run;

data out;
   set out;
   if InLaborForce2=.;
   standard =(xp_0>0.50);
   youden=(xp_0>0.38970);
   cost  =(xp_0>0.22976);
data out;
   set out end=eof;
   retain FNstandard FPstandard FNyouden FPyouden FNcost FPcost 0;
   if (InLaborForce=1) then do; if (youden=1)   then FPyouden=FPyouden+1;
                                if (cost=1)     then FPcost=FPcost+1;
                                if (standard=1) then FPstandard=FPstandard+1; end;
   if (InLaborForce=0) then do; if (youden=0)   then FNyouden=FNyouden+1;
                                if (cost=0)     then FNcost=FNcost+1;
                                if (standard=0) then FNstandard=FNstandard+1; end;
   if (eof) then output;
proc print;
run;

