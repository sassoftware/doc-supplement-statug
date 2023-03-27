/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: hpgamgs1                                            */
/*   TITLE: Getting Started Example 1 for PROC GAMPL            */
/*    DESC: US County Vote Proportion study                     */
/*     REF: STATLIB                                             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS:                                                     */
/*   PROCS: GAMPL                                               */
/*                                                              */
/****************************************************************/

%let off0 = offsetmin=0 offsetmax=0
            linearopts=(thresholdmin=0 thresholdmax=0);
proc template;
   define statgraph surface;
      dynamic _title _z;
      begingraph / designwidth=defaultDesignHeight;
         entrytitle _title;
         layout overlay / xaxisopts=(&off0) yaxisopts=(&off0);
            contourplotparm z=_z y=Latitude x=Longitude / gridded=FALSE;
         endlayout;
      endgraph;
   end;
run;

proc sgrender data=sashelp.Vote1980 template=surface;
   dynamic _title = 'US County Vote Proportion in the 1980 Election'
          _z      = 'LogVoteRate';
run;

ods graphics on;

proc gampl data=sashelp.Vote1980 plots seed=12345;
   model LogVoteRate = spline(Pop   ) spline(Edu) spline(Houses)
                       spline(Income) spline(Longitude Latitude);
   id Longitude Latitude;
   output out=VotePred;
run;

proc sgrender data=VotePred template=surface;
   dynamic _title='Predicted US County Vote Proportion in the 1980 Election'
           _z    ='Pred';
run;

