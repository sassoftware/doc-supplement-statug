/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: adptex1                                             */
/*   TITLE: Example 1 for PROC ADAPTIVEREG                      */
/*    DESC: Simulated Data                                      */
/*     REF: Gu, Bates, Chen and Wahba (1990)                    */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: ADAPTIVEREG                                         */
/*                                                              */
/****************************************************************/

data artificial;
   drop i;
   array X{10};
   do i=1 to 400;
      do j=1 to 10;
         X{j} = ranuni(1);
      end;
      Y = 40*exp(8*((X1-0.5)**2+(X2-0.5)**2))/
            (exp(8*((X1-0.2)**2+(X2-0.7)**2))+
             exp(8*((X1-0.7)**2+(X2-0.2)**2)))+rannor(1);
      output;
   end;
run;

ods graphics on;

proc adaptivereg data=artificial plots=fit;
   model y=x1-x10;
run;

data score;
   do X1=0 to 1 by 0.01;
      do X2=0 to 1 by 0.01;
         Y=40*exp(8*((X1-0.5)**2+(X2-0.5)**2))/
             (exp(8*((X1-0.2)**2+(X2-0.7)**2))+
              exp(8*((X1-0.7)**2+(X2-0.2)**2)));
         output;
      end;
   end;
run;

proc adaptivereg data=artificial;
   model y=x1-x10;
   score data=score out=scoreout;
run;

%let off0 = offsetmin=0 offsetmax=0;
%let off0 = xaxisopts=(&off0) yaxisopts=(&off0);
%let eopt = location=outside valign=top textattrs=graphlabeltext;
proc template;
   define statgraph surfaces;
      begingraph / designheight=360px;
         layout lattice/columns=2;
            layout overlay / &off0;
               entry "True Model" / &eopt;
               contourplotparm z=y y=x2 x=x1;
            endlayout;
            layout overlay / &off0;
               entry "Fitted Model" / &eopt;
               contourplotparm z=pred y=x2 x=x1;
            endlayout;
         endlayout;
      endgraph;
   end;
run;

proc sgrender data=scoreout template=surfaces;
run;

data artificial;
   drop i;
   array x{10};
   do i=1 to 400;
      do j=1 to 10;
         x{j} = ranuni(12345);
      end;
      y = 40*exp(8*((x1-0.5)**2+(x2-0.5)**2))/
            (exp(8*((x1-0.2)**2+(x2-0.7)**2))+
             exp(8*((x1-0.7)**2+(x2-0.2)**2)))+rannor(1);
      output;
   end;
run;

proc adaptivereg data=artificial;
   model y=x1-x10;
run;

