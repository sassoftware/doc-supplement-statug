/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ODSGR12                                             */
/*   TITLE: Modifying Other Graph Elements in Styles            */
/* PRODUCT: SAS                                                 */
/*  SYSTEM: ALL                                                 */
/*    KEYS: ODS Graphics, modifying line thickness              */
/*   PROCS:                                                     */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data stack;
   input  x1 x2 x3 y @@;
   datalines;
80  27  89  42    80  27  88  37    75  25  90  37
62  24  87  28    62  22  87  18    62  23  87  18
62  24  93  19    62  24  93  20    58  23  87  15
58  18  80  14    58  18  89  14    58  17  88  13
58  18  82  11    58  19  93  12    50  18  89   8
50  18  86   7    50  19  72   8    50  19  79   8
50  20  80   9    56  20  82  15    70  20  91  15
;


/* Modifying line thickness in NewStyle */
proc template;
   define style Styles.NewStyle;
   parent = Styles.Default;
   replace GraphFonts
      "Fonts used in graph styles" /
      'GraphDataFont'     = ("Times New Roman",8pt,Italic)
      'GraphValueFont'    = ("Times New Roman",10pt,Italic)
      'GraphLabelFont'    = ("Times New Roman",12pt,Italic)
      'GraphFootnoteFont' = ("Times New Roman",12pt,Italic)
      'GraphTitleFont'    = ("Times New Roman",14pt,Italic Bold);
   replace StatGraphFitLine /
      linethickness = 4px;
end;
run;


/*-----------------------------------------------------*/
/* Displaying Q-Q plot with NewStyle                   */
/* (run odsgr10.sas to match Figures in documentation) */
/*                                                     */
/* On z/OS, replace the ODS HTML statement with:       */
/*                                                     */
/*    ods html path="." style = NewStyle;              */
/*-----------------------------------------------------*/
ods html style = NewStyle;
ods graphics on;

ods select ResidualQQPlot;

proc robustreg plot = resqqplot data = stack;
   model y = x1 x2 x3;
run;

ods graphics off;
ods html close;
