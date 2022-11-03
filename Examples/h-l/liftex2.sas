/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: LIFTEX2                                             */
/*   TITLE: Documentation Example 2 for PROC LIFETEST           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: number of subjects at risk, multiple comparisons    */
/*   PROCS: LIFETEST                                            */
/*    DATA: Included in Appendix D of J.P. Klein and M.L.       */
/*          Moeschberger (1997).                                */
/*                                                              */
/*     REF: SAS/STAT User's Guide, PROC LIFETEST Chapter        */
/*    MISC:                                                     */
/****************************************************************/

proc print data=Sashelp.BMT(obs=10);
run;

ods graphics on;

proc lifetest data=sashelp.BMT plots=survival(atrisk=0 to 2500 by 500);
   time T * Status(0);
   strata Group / test=logrank adjust=sidak;
run;

proc lifetest data=sashelp.BMT notable plots=none;
   time T * Status(0);
   strata Group / test=logrank adjust=sidak diff=control('AML-Low Risk');
run;

proc format;
   invalue $bmtifmt 'ALL' = 1 'AML-Low Risk' = 2 'AML-High Risk' = 3;
   value bmtfmt 1 = 'ALL'  2 = 'AML-Low Risk' 3 = 'AML-High Risk';
run;

data Bmt2;
   set sashelp.BMT(rename=(Group=G));
   Group = input(input(G, $bmtifmt.), 1.);
   label Group = 'Disease Group';
   format Group bmtfmt.;
   run;

proc LIFETEST data=Bmt2 plots=s(atrisk(outside maxlen=13)=0 to 2500 by 500);
   time T*Status(0);
   strata Group / order=internal;
run;

proc lifetest data=Bmt2 plots=survival(cl cb=hw strata=panel);
   time T * Status(0);
   strata Group/order=internal;
run;

ods graphics off;
