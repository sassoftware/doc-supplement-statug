 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: CANROTAT                                            */
 /*   TITLE: Rotation of Canonical Variables                     */
 /* PRODUCT: SAS/STAT                                            */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: multivariate analysis,                              */
 /*   PROCS: CANCORR FACTOR CORR SCORE                           */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF: Cliff & Krus (1976), "Interpretation of Canonical   */
 /*          Analysis: Rotated vs. Unrotated Solutions,"         */
 /*          Psychometrika, 41, 35-42.                           */
 /*    MISC:                                                     */
 /*                                                              */
 /****************************************************************/

title 'Simultaneous Symmetric Varimax Rotation of Canonical Variables';
title2 'Cliff & Krus (1976)';

data fit;
   input weight waist pulse chins situps jumps;
   datalines;
191  36  50   5  162   60
189  37  52   2  110   60
193  38  58  12  101  101
162  35  62  12  105   37
189  35  46  13  155   58
182  36  56   4  101   42
211  38  56   8  101   38
167  34  60   6  125   40
176  31  74  15  200   40
154  33  56  17  251  250
169  34  50  17  120   38
166  33  52  13  210  115
154  34  64  14  215  105
247  46  50   1   50   50
193  36  46   6   70   31
202  37  62  12  210  120
176  37  54   4   60   25
157  32  52  11  230   80
156  33  54  15  225   73
138  33  68   2  110   43
;

proc cancorr data=fit outstat=stat
   vprefix=PHYS vname='Physiological Measurements'
   wprefix=EXER wname='Exercises';
   var weight waist pulse;
   with chins situps jumps;
run;

*** Extract both within-set structure matrices and change the
    prefixes from PHYS and EXER to BOTH so that both can be rotated
    at same time. Change _type_ to 'PATTERN', which is what proc
    factor expects;

data strphys(keep=_type_ _name_  weight waist pulse)
     strexer(keep=_type_ _name_  chins situps jumps);
   set stat; drop which;
   if _type_='STRUCTUR' then do;
      _type_='PATTERN';
      which=substr(_name_,1,4);
      substr(_name_,1,4)='BOTH';
      if which='PHYS' then output strphys;
                      else output strexer;
   end;
run;

***  Merge the within-set structure matrices back together and add
     to original outstat= data set;

data strboth;
   merge strphys strexer;
run;

data both(type=factor);
   set stat strboth;
run;

*** Rotate both within-set structure matrices. This gives the
    rotated structures but not the coefficients;

proc factor data=both method=pattern r=v outstat=fact;
run;

*** The rotated coefficients must be computed separately. Make
    separate data sets and change the prefixes back to PHYS, EXER;

data factphys(type=factor keep=_type_ _name_  weight waist pulse)
     factexer(type=factor keep=_type_ _name_  chins situps jumps);
   set fact;
   if substr(_name_,1,4)='BOTH' then do;
      substr(_name_,1,4)='PHYS'; output factphys;
      substr(_name_,1,4)='EXER'; output factexer;
      end;
   else output;
run;

*** Compute standardized scoring coefficients for PHYS variables;

proc factor data=factphys score outstat=factphys;
   var weight waist pulse;
run;

*** Compute canonical scores for PHYS variables;

proc score data=fit score=factphys out=fitphys;
   var weight waist pulse;
run;

*** Compute correlations between canonical scores and PHYS variables
    to verify computations. Compare with rotated factor pattern;

proc corr noprob;
   var phys:;
   with weight waist pulse;
run;

*** Compute correlations among PHYS canonical variables. Should
    be identity;

proc corr noprob;
   var phys:;
run;

*** Compute standardized scoring coefficients for EXER variables;

proc factor data=factexer score outstat=factexer;
   var chins situps jumps;
run;

*** Compute canonical scores for EXER variables;

proc score data=fit score=factexer out=fitexer;
   var chins situps jumps;
run;

*** Compute correlations between canonical scores and EXER variables
    to verify computations. Compare with rotated factor pattern;

proc corr noprob;
   var exer:;
   with chins situps jumps;
run;

*** Compute correlations among EXER canonical variables. Should
    be identity;

proc corr noprob;
   var exer:;
run;

*** Compute between-set correlations for canonical variables.
    Note that this correlation matrix is symmetric but NOT diagonal;

data fitboth;
   merge fitphys fitexer;
run;

proc corr noprob;
   var phys:;
   with exer:;
run;
