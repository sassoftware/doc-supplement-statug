
/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: VARCLUEX                                            */
/*   TITLE: Documentation Example for PROC VARCLUS              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: CLUSTER                                             */
/*   PROCS: VARCLUS TREE                                        */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data phys8(type=corr);
   title 'Eight Physical Measurements on 305 School Girls';
   title2 'Harman: Modern Factor Analysis, 3rd Ed, p22';
   label ArmSpan='Arm Span'             Forearm='Length of Forearm'
         LowerLeg='Length of Lower Leg' BitDiam='Bitrochanteric Diameter'
         Girth='Chest Girth'            Width='Chest Width';
   input _Name_ $ 1-8
         (Height ArmSpan Forearm LowerLeg Weight BitDiam
          Girth Width)(7.);
   _Type_='corr';
   datalines;
Height     1.0    .846   .805   .859   .473   .398   .301   .382
ArmSpan    .846   1.0    .881   .826   .376   .326   .277   .415
Forearm    .805   .881   1.0    .801   .380   .319   .237   .345
LowerLeg   .859   .826   .801   1.0    .436   .329   .327   .365
Weight     .473   .376   .380   .436   1.0    .762   .730   .629
BitDiam    .398   .326   .319   .329   .762   1.0    .583   .577
Girth      .301   .277   .237   .327   .730   .583   1.0    .539
Width      .382   .415   .345   .365   .629   .577   .539   1.0
;


proc varclus data=phys8;
run;

proc varclus data=phys8 centroid;
run;

ods graphics on;

proc varclus data=phys8 maxc=8 summary;
run;
