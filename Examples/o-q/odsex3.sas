/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ODSEX3                                              */
/*   TITLE: Documentation Example 3 for ODS                     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: ODS                                                 */
/*   PROCS: MIXED, TEMPLATE, SGRENDER                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF: Using the Output Delivery System                    */
/*    MISC:                                                     */
/****************************************************************/

title 'Oven Measurements';

data hh;
   input a b y @@;
   datalines;
1 1 237   1 1 254    1 1 246
1 2 178   1 2 179
2 1 208   2 1 178    2 1 187
2 2 146   2 2 145    2 2 141
3 1 186   3 1 183
3 2 142   3 2 125    3 2 136
;

/*
ods _all_ close;
ods html body='mixed.htm' contents='mixedc.htm' frame='mixedf.htm'
         style=HTMLBlue;

ods exclude ParmSearch(persist);
ods show;
*/

proc mixed data=hh;
   class a b;
   model y = a;
   random b a*b;
   parms (17 to 20 by 0.1) (.3 to .4 by .005) (1.0);
   ods output ParmSearch=parms;
run;

ods show;

proc template;
   define statgraph surface;
      begingraph;
         layout overlay3d;
            surfaceplotparm x=CovP1 y=CovP2 z=ResLogLike;
         endlayout;
      endgraph;
   end;
run;

proc sgrender data=parms template=surface;
run;

*
ods html close;

