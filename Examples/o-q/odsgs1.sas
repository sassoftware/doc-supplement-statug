/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ODSGS1                                              */
/*   TITLE: Getting Started Example for ODS                     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: ODS                                                 */
/*   PROCS: TEMPLATE, REG, GLM                                  */
/*    DATA:                                                     */
/*                                                              */
/*     REF: Using the Output Delivery System                    */
/*    MISC:                                                     */
/****************************************************************/

title 'Getting Started with ODS';

*
ods _all_ close;

proc reg data=sashelp.class;
   model height=weight;
   ods output ParameterEstimates=parms;
quit;

/*
ods pdf;
ods html;
*/

proc print noobs data=parms;
run;

ods select none;

proc reg data=sashelp.class;
   model height=weight;
   ods output ParameterEstimates=parms;
quit;

ods select all;

proc print noobs data=parms;
run;

ods trace on;
ods graphics on;
proc reg data=sashelp.class;
   model weight=height;
   model age=height;
quit;
ods trace off;

proc template;
   source Stat.REG.ANOVA;
run;

proc template;
   list Stat.REG;
   list ETS.ARIMA;
   list QC.Shewhart;
run;

proc glm data=sashelp.class;
   model height=weight;
quit;

/*
ods trace output;
proc glm data=sashelp.class;
   model height=weight;
quit;
ods trace off;
*/

proc template;
   source stat.glm.overallanova;
run;

proc template;
   source stat.glm.anova;
run;

proc template;
   source Stat.GLM.SS;
   source Stat.GLM.MS;
run;

proc template;
   source Common.ANOVA.SS;
   source Common.ANOVA.MS;
run;

proc template;
   edit Stat.GLM.SS;
      choose_format=max format_width=8;
   end;
   edit Stat.GLM.MS;
      choose_format=max format_width=8;
   end;
run;

proc glm data=sashelp.class;
   model height=weight;
quit;

proc template;
   delete Stat.GLM.SS / store=sasuser.templat;
   delete Stat.GLM.MS / store=sasuser.templat;
run;

ods path show;
libname mytpls '.';
ods path (prepend) mytpls.template(update);
ods path show;

proc template;
   edit Stat.GLM.SS;
      choose_format=max format_width=8;
   end;
   edit Stat.GLM.MS;
      choose_format=max format_width=8;
   end;
run;

proc template;
   delete Stat.GLM.SS / store=mytpls.template;
   delete Stat.GLM.MS / store=mytpls.template;
run;

ods path (prepend) work.templat(update);
ods path work.templat(update) sasuser.templat(update) sashelp.tmplmst(read);

ods path work.templat(update) sashelp.tmplmst(read);

ods path reset;

proc glm data=sashelp.class;
   ods output ParameterEstimates=Parms;
   class sex;
   model height=sex / solution;
quit;

