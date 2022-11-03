 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: MR2010H                                             */
 /*   TITLE: Conjoint Analysis                                   */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: marketing research                                  */
 /*   PROCS: TRANSREG, OPTEX, FACTEX, PLAN, IML                  */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF: MR-2010H Conjoint Analysis                          */
 /*    MISC: This file contains all of the sample code for       */
 /*          the "Conjoint Analysis" report,                     */
 /*          the 10Oct2010 edition, for SAS 9.2.                 */
 /*                                                              */
 /*          You must install the following macros from          */
 /* http://support.sas.com/techsup/tnote/tnote_stat.html#market  */
 /*                                                              */
 /*          ChoicEff Efficient Choice Designs                   */
 /*          MktAllo  Process a Choice Allocation Study Data Set */
 /*          MktBal   Balanced Experimental Design               */
 /*          MktBIBD  Balanced Incomplete Block Design           */
 /*          MktBlock Block an Experimental Design               */
 /*          MktBSize Balanced Incomplete Block Design Sizes     */
 /*          MktDes   Efficient Experimental Designs             */
 /*          MktDups  Eliminate Duplicate Runs or Choice Sets    */
 /*          MktEval  Evaluate an Experimental Design            */
 /*          MktEx    Efficient Experimental Designs             */
 /*          MktKey   Aid Making the MktRoll KEY= Data Set       */
 /*          MktLab   Change Names, Levels in a Design           */
 /*          MktMDiff MaxDiff (Best-Worst) Choice Modeling       */
 /*          MktMerge Merge a Choice Design with Choice Data     */
 /*          MktOrth  List Orthogonal Designs MktEx Can Make     */
 /*          MktPPro  Optimal Partial Profile Designs            */
 /*          MktRoll  Roll Out a Design Into a Choice Design     */
 /*          MktRuns  Experimental Design Sizes                  */
 /*          PhChoice Customize PROC PHREG for Choice Models     */
 /*                                                              */
 /****************************************************************/

options ls=80 ps=60 nonumber nodate;

***************** Begin TRANSREG Output Customization *****************;

proc template;
   edit Stat.Transreg.ParentUtilities;
      column Label Utility StdErr tValue Probt Importance Variable;
      header title;
      define title; text 'Part-Worth Utilities'; space=1; end;
      define Variable; print=off; end;
      end;
   run;

* Delete edited template, restore original template;
proc template;
   delete Stat.Transreg.ParentUtilities;
   run;

proc template;
   source stat.transreg;
   run;

proc template;
   edit Stat.Transreg.ParentUtilities;
      column Label Utility StdErr tValue Probt Importance Variable;
      header title;
      define title; text 'Part-Worth Utilities'; space=1; end;
      define Variable; print=off; end;
      end;
   run;

********************** Begin Candy Example Code ***********************;

options ls=80 ps=60 nonumber nodate;
title;

title 'Preference for Chocolate Candies';

data choc;
   input Chocolate $ Center $ Nuts $& Rating;
   datalines;
Dark  Chewy  Nuts       7
Dark  Chewy  No Nuts    6
Dark  Soft   Nuts       6
Dark  Soft   No Nuts    4
Milk  Chewy  Nuts       9
Milk  Chewy  No Nuts    8
Milk  Soft   Nuts       9
Milk  Soft   No Nuts    7
;

ods exclude notes mvanova anova;
proc transreg utilities separators=', ' short;
   title2 'Metric Conjoint Analysis';
   model identity(rating) = class(chocolate center nuts / zero=sum);
   run;

ods graphics on;

ods exclude notes anova liberalanova conservanova
            mvanova liberalmvanova conservmvanova;
proc transreg utilities separators=', ' plots=transformations;
   title2 'Nonmetric Conjoint Analysis';
   model monotone(rating) = class(chocolate center nuts / zero=sum);
   output;
   run;

************* Begin Basic Frozen Diet Entrees Example Code ************;

options ls=80 ps=60 nonumber nodate;
title;

title 'Frozen Diet Entrees';

%mktruns(3 3 3 2)

%mktex(3 3 3 2, n=18)

%mktex(3 3 3 2, n=18, seed=151)

%mktlab(data=randomized, vars=Ingredient Fat Price Calories)

* Due to machine differences, you may not get the same design if you run
* the step above, so here is the design that was used in the book;
data randomized; input x1-x4 @@; datalines;
3 2 3 1 3 1 2 1 1 1 3 1 3 3 1 2 2 1 1 1 2 3 3 1 2 2 2 1 2 2 2 2 1 3 2 1
2 1 1 2 3 1 2 2 1 2 1 1 1 2 1 2 1 3 2 2 3 2 3 2 3 3 1 1 2 3 3 2 1 1 3 2
;
%mktlab(vars=Ingredient Fat Price Calories)

proc format;
   value if  1='Chicken'  2='Beef'     3='Turkey';
   value ff  1='8 Grams'  2='5 Grams'  3='2 Grams';
   value pf  1='$2.59'    2='$2.29'    3='$1.99';
   value cf  1='350'      2='250';
   run;

data sasuser.dietdes;
   set final;
   format ingredient if. fat ff. price pf. calories cf.;
   run;

proc print; run;

%mkteval(data=sasuser.dietdes)

%mktdups(linear, data=sasuser.dietdes)

title;
data _null_;
   file print;
   set sasuser.dietdes;
   put ///
       +3 ingredient 'Entree' @50 '(' _n_ +(-1) ')' /
       +3 'With ' fat 'of Fat and ' calories  'Calories' /
       +3 'Now for Only ' Price +(-1) '.'///;
   if mod(_n_, 6) = 0 then put _page_;
   run;

title 'Frozen Diet Entrees';

data results;
   input combo1-combo18;
   datalines;
17 6 8 7 10 5 4 16 15 1 11 2 9 14 12 13 3 18
;

proc transpose out=results(rename=(col1=combo)); run;

data results; set results; Rank = _n_; drop _name_; run;

proc sort; by combo; run;

data results(drop=combo);
   merge sasuser.dietdes results;
   run;

proc print; run;

ods exclude notes anova liberalanova conservanova
            mvanova liberalmvanova conservmvanova;
proc transreg utilities order=formatted separators=', ';
   model monotone(rank / reflect) =
         class(Ingredient Fat Price Calories / zero=sum);
   output out=utils p ireplace;
   run;

proc sort; by descending prank; run;

proc print label;
   var ingredient fat price calories rank trank prank;
   label trank = 'Reflected Rank'
         prank = 'Utilities';
   run;

*********** Begin Advanced Frozen Diet Entrees Example Code ***********;

options ls=80 ps=60 nonumber nodate;
title;

title 'Frozen Diet Entrees';

proc format;
   value if  1='Chicken'  2='Beef'     3='Turkey';
   value ff  1='8 Grams'  2='5 Grams'  3='2 Grams';
   value pf  1='$2.59'    2='$2.29'    3='$1.99';
   value cf  1='350'      2='250';
   run;

%mktex(3 3 3 2, n=18, seed=205)

%mktlab(data=randomized, vars=Ingredient Fat Price Calories)

%mkteval(data=final)

title 'Frozen Diet Entrees';

proc format;
   value if  1='Chicken'  2='Beef'     3='Turkey';
   value ff  1='8 Grams'  2='5 Grams'  3='2 Grams';
   value pf  1='$2.59'    2='$2.29'    3='$1.99';
   value cf  1='350'      2='250';
   run;

%mktex(3 3 3 2, n=18, seed=205)

%mktex(3 3 3 2,                     /* 3 three-level and a two-level factor */
       n=22,                        /* 22 runs                              */
       init=randomized,             /* initial design                       */
       holdouts=4,                  /* add four holdouts to init design     */
       options=nodups,              /* no duplicate rows in design          */
       seed=368)                    /* random number seed                   */

* Due to machine differences, you may not get the same design if you run
* the step above, so here is the design that was used in the book;
data randomized; input x1-x4 w @@; datalines;
2 3 1 2 . 2 2 1 2 1 3 3 3 1 1 3 3 3 2 1 3 1 1 1 1 1 3 1 1 1 1 3 1 2 1 1
1 2 1 1 2 2 1 1 1 3 2 2 2 1 2 2 3 1 . 2 3 2 2 1 3 1 1 2 1 2 1 3 2 1 3 2
1 1 . 1 2 3 1 1 1 1 2 2 1 1 2 2 2 . 2 3 2 1 1 3 2 2 1 1 1 2 3 2 1 2 1 3
1 1
;

proc print data=randomized; run;

%mkteval(data=randomized(where=(w=1)), factors=x:)
%mkteval(data=randomized(drop=w))

%mktlab(data=randomized, out=sasuser.dietdes,
        vars=Ingredient Fat Price Calories,
        statements=format Ingredient if. fat ff. price pf. calories cf.)

proc print; run;

title;
data _null_;
   file print;
   set sasuser.dietdes;
   put ///
       +3 ingredient 'Entree' @50 '(' _n_ +(-1) ')' /
       +3 'With ' fat 'of Fat and ' calories  'Calories' /
       +3 'Now for Only ' Price +(-1) '.'///;
   if mod(_n_, 6) = 0 then put _page_;
   run;

title 'Frozen Diet Entrees';

%let m = 22; /* number of combinations */

* Read the input data and convert to ranks;
data ranks(drop=i k c1-c&m);
   input c1-c&m;
   array c[&m];
   array r[&m];
   do i = 1 to &m;
      k = c[i];
      if 1 le k le &m then do;
         if r[k] ne . then
            put 'ERROR: For subject ' _n_ +(-1) ', combination ' k
                'is given more than once.';
         r[k] = i; /* Convert to ranks. */
         end;
      else put 'ERROR: For subject ' _n_ +(-1) ', combination ' k
                'is invalid.';
      end;

   do i = 1 to &m;
      if r[i] = . then
         put 'ERROR: For subject ' _n_ +(-1) ', combination ' i
             'is not given.';
      end;
   name = 'Subj' || put(_n_, z2.);
   datalines;
4 3 7 21 12 10 6 19 1 16 18 11 20 14 17 15 2 22 9 8 13 5
4 12 3 1 19 7 10 6 11 21 16 2 18 20 15 9 14 22 13 17 5 8
4 3 7 12 19 21 1 6 10 18 16 11 20 15 2 14 9 17 22 8 13 5
4 12 1 10 21 14 18 3 7 2 17 13 19 11 22 20 16 15 6 9 5 8
4 21 14 11 16 3 12 22 19 18 10 17 8 20 7 1 6 2 9 13 15 5
4 21 16 12 3 14 11 22 18 19 7 10 1 17 8 6 2 20 9 13 15 5
12 4 19 1 3 7 6 21 18 11 16 2 10 20 9 15 14 17 22 8 13 5
4 21 3 16 14 11 12 22 18 10 19 20 17 8 7 6 1 2 13 15 9 5
4 21 3 16 11 14 22 12 18 10 20 19 17 8 7 6 1 13 15 2 9 5
4 3 14 11 21 12 16 22 19 10 18 20 17 1 7 8 2 13 9 6 15 5
15 22 17 21 6 11 13 19 4 12 3 18 9 7 1 10 8 20 14 16 5 2
12 4 3 7 21 19 1 18 11 6 16 2 14 10 17 22 20 9 15 8 13 5
;

proc transpose data=ranks out=ranks2;
   id name;
   run;

data both;
   merge sasuser.dietdes ranks2;
   drop _name_;
   run;

proc print label;
   title2 'Data and Design Together';
   run;

proc format;
   value wf 1 = 'Active'
            . = 'Holdout'
            0 = 'Simulation';
   run;

%mktex(3 3 3 2, n=3*3*3*2)
%mktlab(data=design, vars=Ingredient Fat Price Calories)

data all;
   set both final(in=f);
   if f then w = 0;
   format w wf.;
   run;

proc print data=all(Obs=25 drop=subj04-subj12) label;
   title2 'Some of the Final Data Set';
   run;

ods exclude notes mvanova anova;
proc transreg data=all utilities short separators=', '
   method=morals outtest=utils;
   title2 'Conjoint Analysis';
   model identity(subj: / reflect) =
         class(Ingredient Fat Price Calories / zero=sum);
   weight w;
   output p ireplace out=results coefficients;
   run;

proc print data=results(drop=_depend_ t_depend_ intercept &_trgind) label;
   title2 'Predicted Utility';
   where w ne 0 and _depvar_ le 'Identity(Subj02)' and not (_type_ =: 'M');
   by _depvar_;
   label p_depend_ = 'Predicted Utility';
   run;

ods output KendallCorr=k PearsonCorr=p;
ods listing close;
proc corr nosimple noprob kendall pearson
   data=results(where=(w=.));
   title2 'Holdout Validation Results';
   var p_depend_;
   with t_depend_;
   by notsorted _depvar_;
   run;
ods listing;

data both(keep=subject pearson kendall);
   length Subject 8;
   merge p(rename=(p_depend_=Pearson))
         k(rename=(p_depend_=Kendall));
   subject = input(substr(_depvar_, 14, 2), best2.);
   run;

proc print; run;

data results2;
   set results;
   if not (index(_depvar_, '11'));
   run;

data utils2;
   set utils;
   if not (index(_depvar_, '11'));
   run;

proc sort data=results2(where=(w=0)) out=sims(drop=&_trgind);
   by _depvar_ descending p_depend_;
   run;

data sims; /* Pull out first 10 for each subject. */
   set sims;
   by _depvar_;
   retain n 0;
   if first._depvar_ then n = 0;
   n = n + 1;
   if n le 10;
   drop w _depend_ t_depend_ n _name_ _type_ intercept;
   run;

proc print data=sims label;
   by _depvar_ ;
   title2 'Simulations Sorted by Decreasing Predicted Utility';
   title3 'Just the Ten Most Preferred Combinations are Printed';
   label p_depend_ = 'Predicted Utility';
   run;

proc contents data=utils2 position;
   ods select position;
   title2 'Variables in the OUTTEST= Data Set';
   run;

proc print data=utils2 label;
   title2 'R-Squares';
   id _depvar_;
   var value;
   format value 4.2;
   where statistic = 'R-Square';
   label value = 'R-Square' _depvar_ = 'Subject';
   run;

data im;
   set utils2;
   if n(importance);   /* Exclude all missing, including specials.*/
   _depvar_ = scan(_depvar_, 2);   /* Discard transformation.     */
   label    = scan(label, 1, ','); /* Use up to comma for label.  */
   keep importance _depvar_ label;
   run;

proc transpose data=im out=im(drop=_name_ _label_);
   id label;
   by notsorted _depvar_;
   var importance;
   label _depvar_ = 'Subject';
   run;

proc print label;
   title2 'Importances';
   format _numeric_ 2.;
   id _depvar_;
   run;

proc means mean;
   title2 'Average Importances';
   run;

data im2;
   set im;
   label c1 = 'Ingredient' c2 = 'Fat' c3 = 'Price' c4 = 'Calories';
   c1 = put(ingredient, 2.) || substr('  ******', 1, ceil(ingredient / 15));
   c2 = put(fat       , 2.) || substr('  ******', 1, ceil(fat        / 15));
   c3 = put(price     , 2.) || substr('  ******', 1, ceil(price      / 15));
   c4 = put(calories  , 2.) || substr('  ******', 1, ceil(calories   / 15));
   run;

proc print label;
   title2 'Importances';
   var c1-c4;
   id _depvar_;
   run;

proc print data=results2 label;
   title2 'Part-Worth Utilities';
   where _type_ = 'M COEFFI';
   id _name_;
   var &_trgind;
   run;

proc fastclus data=results2 maxclusters=3 out=clusts;
   where _type_ = 'M COEFFI';
   id _name_;
   var &_trgind;
   run;

proc sort; by cluster; run;

proc print label;
   title2 'Part-Worth Utilities, Clustered';
   by cluster;
   id _name_;
   var &_trgind;
   run;

****************** Begin Spaghetti Sauce Example Code *****************;

options ls=80 ps=60 nonumber nodate;
title;

title 'Spaghetti Sauces';

%mktruns(3 3 2 2 5)

%mktruns(3 3 2 2 5, interact=1*5)

title 'Spaghetti Sauces';

proc format;
   value br 1='Pregu'       2='Sundance'  3='Tomato Garden';
   value me 1='Vegetarian'  2='Meat'      3='Italian Sausage';
   value mu 1='Mushrooms'   2='No Mention';
   value in 1='All Natural' 2='No Mention';
   value pr 1='1.99' 2='2.29' 3='2.49' 4='2.79' 5='2.99';
   run;

%macro resmac;
   Brand    = {'P' 'S' 'T'}[x1];
   Meat     = {'V' 'M' 'I'}[x2];
   Mushroom = {'M' ' '}[x3];
   Natural  = {'A' ' '}[x4];
   Price    = {1.99 2.29 2.49 2.79 2.99}[x5];
   bad      = (meat = 'I' & natural = 'A') +
              (price = 1.99 & (meat = 'M' | meat = 'I'));
   %mend;

%mktex(3 3 2 2 5,                   /* all of the factor levels             */
       interact=1*5,                /* x1*x5 interaction                    */
       n=30,                        /* 30 runs                              */
       seed=289,                    /* random number seed                   */
       restrictions=resmac)         /* name of restrictions macro           */

* Due to machine differences, you may not get the same design if you run
* the step above, so here is the design that was used in the book;
data randomized; input x1-x5 @@; datalines;
1 2 2 2 4 3 1 2 2 4 1 2 1 1 2 3 1 1 1 3 2 1 1 2 1 1 3 2 2 3 3 1 2 2 5 3
3 1 2 2 1 1 1 2 3 1 1 2 2 2 2 1 1 2 4 3 1 1 2 1 2 2 2 2 2 2 2 1 2 5 1 3
1 2 4 3 3 1 2 5 2 1 1 1 2 1 2 1 1 5 3 2 2 2 3 2 2 1 1 3 1 1 2 1 1 2 2 2
1 4 3 1 2 1 1 2 3 2 2 3 2 1 2 1 1 2 1 2 1 5 1 3 2 2 5 3 1 2 1 2 1 1 1 2
1 3 2 1 1 4
;

%mktlab(data=randomized, vars=Brand Meat Mushroom Ingredients Price,
        statements=format brand br. meat me. mushroom mu.
                   ingredients in. price pr.,
        out=sasuser.spag)

%mkteval(data=sasuser.spag)

proc print data=sasuser.spag; run;

options ls=80 ps=74 nonumber nodate;
title;

data _null_;
   set sasuser.spag;
   length lines $ 500 aline $ 60;
   file print linesleft=ll;

   * Format meat level, preserve 'Italian' capitalization;
   aline = lowcase(put(meat, me.));
   if aline =: 'ita' then substr(aline, 1, 1) = 'I';

   * Format meat differently for 'vegetarian';
   if meat > 1
      then lines = 'Try ' || trim(put(brand, br.)) ||
                   ' brand spaghetti sauce with ' || aline;
      else lines = 'Try ' || trim(put(brand, br.)) ||
                   ' brand ' || trim(aline) || ' spaghetti sauce ';

   * Add mushrooms, natural ingredients to text line;
   n = (put(ingredients, in.) =: 'All');
   m = (put(mushroom,    mu.) =: 'Mus');

   if n or m then do;
      lines = trim(lines) || ', now with';

      if m then do;
         lines = trim(lines) || ' ' || lowcase(put(mushroom, mu.));
         if n then lines = trim(lines) || ' and';
         end;
      if n then lines = trim(lines) || ' ' ||
                        lowcase(put(ingredients, in.)) || ' ingredients';
      end;

   * Add price;
   lines = trim(lines) ||
          '.  A 26 ounce jar serves four adults for only $' ||
          put(price, pr.) || '.';

   * Print cover page, with subject number, instructions, and rating scale;
   if _n_ = 1 then do;
      put ///// +41 'Subject: ________' ////
          +5 'Please rate your willingness to purchase the following' /
          +5 'products on a nine point scale.' ///
          +9 '1   Definitely Would Not Purchase This Product' ///
          +9 '2'  ///
          +9 '3   Probably Would Not Purchase This Product' ///
          +9 '4'  ///
          +9 '5   May or May Not Purchase This Product' ///
          +9 '6'  ///
          +9 '7   Probably Would Purchase This Product' ///
          +9 '8'  ///
          +9 '9   Definitely Would Purchase This Product' /////
          +5 'Please rate every product and be sure to rate' /
          +5 'each product only once.' //////
          +5 'Thank you for your participation!';
      put _page_;
      end;

   if ll < 8 then put _page_;

   * Break up description, print on several lines;

   start = 1;
   do l = 1 to 10 until(aline = ' ');

      * Find a good place to split, blank or punctuation;
      stop = start + 60;
      do i = stop to start by -1 while(substr(lines, i, 1) ne ' '); end;
      do j = i to max(start, i - 8) by -1;
         if substr(lines, j, 1) in ('.' ',') then do; i = j; j = 0; end;
         end;

      stop = i; len = stop + 1 - start;
      aline = substr(lines, start, len);
      start = stop + 1;
      if l = 1 then put +5 _n_ 2. ') ' aline;
      else          put +9 aline;
      end;

   * Print rating scale;
   put +9 'Definitely                                      Definitely ' /
       +9 'Would Not   1   2   3   4   5   6   7   8   9   Would      ' /
       +9 'Purchase                                        Purchase   ' //;
   run;

options ls=80 ps=60 nonumber nodate;


data rawdata;
   missing _;
   input subj @5 (rate1-rate30) (1.);
   name = compress('Sub' || put(subj, z3.));
   if nmiss(of rate:) = 0;
   datalines;
  1 319591129691132168146121171191
  2 749173216928911175549891841791
  3 449491116819413186158171961791
  4 113671192128346342124175311248
  5 129691338588961195396561941794
  6 748155415915911162519464963651
  7 161781515449111141118191941791
  8 868796159978718194399663711697
  9 111391139899112191116171841981
 10 314128191112638913451328116114
 11 628681215895731479459245161191
 12 859364518935921186559992741891
 13 548481115718213165246192941491
 14 1139812951994_9466149198915699
 15 128591437575761195378461931774
 16 636144515915821131519163765441
 17 171891624549111141116191951891
 18 979797149879917191489764711897
 19 2214922399981121.1116161941991
 20 21612819111253771.441316117113
 21 539591559692212146136111191272
 22 949175527938911196569995983893
 23 149382117719311184126131951891
 24 111231194117142352135183111148
 25 139791549699871197597751951894
 26 417341314925911162419563843441
 27 151791525559111161119191951791
 28 968595179978718194399974811599
 29 131191229989111191117171831991
 30 317139191112559915561.39117113
 31 419591419341121236112121151151
 32 329154117917911164539692452893
 33 217154135628421166237142981791
 34 114561191246314133112154111271
 35 129691459689961197499591961996
 36 829256918919911181719597952761
 37 161771434459111131117191831771
 38 778594159977816182289573711496
 39 111291129788111191114151741981
 40 213127191111528912331315115112
 41 769692159491491387579111191193
 42 939162116917911193749891773591
 43 718393116619321166119171981591
 44 121773194167287561317188612556
 45 119691437699991195497671951696
 46 637165314912911153319354741551
 47 1617914144191111311181918317_1
 48 978696159966719192399663911497
 49 222491149799114191116181841991
 50 413119191113639914461339116315
 51 118591558191111176119121171571
 52 849162217918711133339691521891
 53 639591117719312156286161961892
 54 115891193579459593125198412798
 55 117791218587771186474471841674
 56 969155516919911183719595967454
 57 161681515439111141118191941691
 58 86.598167978818194599674911597
 59 221391139788112191116171721981
 60 413149191113658914482249116115
 61 118391159391152168156121441591
 62 749154117917811177649681941591
 63 668583138728412189278291991793
 64 111982395219898874163189811299
 65 118791438469951196295551941694
 66 589165512814511172439553873771
 67 151671415539111141119191931691
 68 878796169969618194389664711498
 69 221291139987112191116172741981
 70 315129191114647923463428216425
 71 116561126392423436266112151472
 72 557146117917811156349892842891
 73 429481115719611176148133961991
 74 112471191149564151353197311538
 75 116691119587861194375351821772
 76 97817451891694119.719494974672
 77 161671716739111141119191931791
 78 859795158968517185589863721795
 79 321491259797113191126161651991
 80 313126191111435714441227116112
 81 717491137792122566155511191182
 82 659143116927711172358591842691
 83 447682155729721176369282961993
 84 155661193139294451141147722677
 85 128691347698991197496671951893
 86 569194215913911154519254694661
 87 161791525349111141118191841791
 88 668596159857716192199872511497
 89 111291139777113191117171751971
 90 213117191112625911141227115112
 91 457593419984197258675335199251
 92 235211115916544163738962543693
 93 219678111446351185113122161988
 94 327271171234936122133257214939
 95 138481418565711494364471871444
 96 935563423519262282519395986964
 97 151991425649611371318291941981
 98 76637713997561419469975.731499
 99 211391379998114391129284951991
100 212219171111537912111119119532
;

proc transpose data=rawdata(drop=subj) out=temp(drop=_name_);
    id name;
    run;

data inputdata; merge sasuser.spag temp; run;

ods exclude notes mvanova anova;
proc transreg data=inputdata utilities short separators='' ', '
   lprefix=0 outtest=utils method=morals;
   title2 'Conjoint Analysis';
   model identity(sub:) =
         class(brand | price meat mushroom ingredients / zero=sum);
   output p ireplace out=results1 coefficients;
   run;

data model;
   set utils;
   if statistic in ('R-Square', 'Adj R-Sq', 'Model');
   Subj = scan(_depvar_, 2);
   if statistic = 'Model' then do;
      value = numdf;
      statistic = 'Num DF';
      output;
      value = dendf;
      statistic = 'Den DF';
      output;
      value = dendf + numdf + 1;
      statistic = 'N';
      end;
   output;
   keep statistic value subj;
   run;

proc transpose data=model out=summ;
   by subj;
   idlabel statistic;
   id statistic;
   run;

data summ2(drop=list);
   length list $ 1000;
   retain list;
   set summ end=eof;
   if adj_r_sq < 0.3 then do;
      Small = '*';
      list = trim(list) || ' ' || subj;
      end;
   if eof then call symput('droplist', trim(list));
   run;

%put &droplist;

proc print label data=summ2(drop=_name_ _label_); run;

proc transreg data=inputdata(drop=&droplist) utilities short noprint
   separators='' ', ' lprefix=0 outtest=utils method=morals;
   title2 'Conjoint Analysis';
   model identity(sub:) =
         class(brand | price meat mushroom ingredients / zero=sum);
   output p ireplace out=results2 coefficients;
   run;

   /* Uncomment this code if you want it to run

%let min = 1;
%let max = 9;
%let by  = 1;
%let inter = 20;
%let list = &min to &max by &by;
data a;
   do u = &list;
      logit = exp(u);
      btl   = u;
      sumb  + btl;
      suml  + logit;
      end;

   do u = &list / &inter;
      logit = exp(u);
      btl = u;
      max = abs(u - (&max)) < (0.5 * (&by / &inter));
      btl = btl / sumb;
      logit = logit / suml;
      output;
      end;
   label u = 'Probability of Choice';
   run;

proc sgplot data=a;
   title 'Simulator Comparisons';
   series x=u y=logit / curvelabel='Logit' lineattrs=graphdata1;
   series x=u y=btl   / curvelabel='BTL' lineattrs=graphdata2;
   series x=u y=max   / curvelabel='Maximum Utility' lineattrs=graphdata3;
   yaxis label='Utility';
   run;

   */

                        /*---------------------------------------*/
                        /* Simulate Market Share                 */
                        /*---------------------------------------*/
%macro sim(data=_last_, /* SAS data set with utilities.          */
           idvars=,     /* Additional variables to display with  */
                        /* market share results.                 */
           weights=,    /* By default, each subject contributes  */
                        /* equally to the market share           */
                        /* computations.  To differentially      */
                        /* weight the subjects, specify a vector */
                        /* of weights, one per subject.          */
                        /* Separate the weights by blanks.       */
           out=shares,  /* Output data set name.                 */
           method=max   /* max   - maximum utility model.        */
                        /* btl   - Bradley-Terry-Luce model.     */
                        /* logit - logit model.                  */
                        /* WARNING: The Bradley-Terry-Luce model */
                        /* and the logit model results are not   */
                        /* invariant under linear                */
                        /* transformations of the utilities.     */
          );            /*---------------------------------------*/

options nonotes;

%if &method = btl or &method = logit %then
   %put WARNING: The Bradley-Terry-Luce model and the logit model
results are not invariant under linear transformations of the
utilities.;
%else %if &method ne max %then %do;
   %put WARNING: Invalid method &method..  Assuming method=max.;
   %let method = max;
   %end;

* Eliminate coefficient observations, if any;
data temp1;
   set &data(where=(_type_ = 'SCORE' or _type_ = ' '));
   run;

* Determine number of runs and subjects.;
proc sql;
   create table temp2 as select nruns,
      count(nruns) as nsubs, count(distinct nruns) as chk
      from (select count(_depvar_) as nruns
      from temp1 where _type_ in ('SCORE', ' ') group by _depvar_);
   quit;

data _null_;
   set temp2;
   call symput('nruns', compress(put(nruns, 5.0)));
   call symput('nsubs', compress(put(nsubs, 5.0)));
   if chk > 1 then do;
      put 'ERROR: Corrupt input data set.';
      call symput('okay', 'no');
      end;
   else call symput('okay', 'yes');
   run;

%if &okay ne yes %then %do;
   proc print;
     title2 'Number of runs should be constant across subjects';
     run;
   %goto endit;
   %end;

%else %put NOTE: &nruns runs and &nsubs subjects.;

%let w = %scan(&weights, %eval(&nsubs + 1), %str( ));
%if %length(&w) > 0 %then %do;
   %put ERROR: Too many weights.;
   %goto endit;
   %end;

* Form nruns by nsubs data set of utilities;
data temp2;
   keep _u1 - _u&nsubs &idvars;
   array u[&nsubs] _u1 - _u&nsubs;

   do j = 1 to &nruns;

      * Read ID variables;
      set temp1(keep=&idvars) point = j;

      * Read utilities;
      k = j;
      do i = 1 to &nsubs;
         set temp1(keep=p_depend_) point = k;
         u[i] = p_depend_;
         %if &method = logit %then u[i] = exp(u[i]);;
         k = k + &nruns;
         end;

      output;
      end;

   stop;
   run;

* Set up for maximum utility model;
%if &method = max %then %do;

   * Compute maximum utility for each subject;
   proc means data=temp2 noprint;
      var _u1-_u&nsubs;
      output out=temp1 max=_sum1 - _sum&nsubs;
      run;

   * Flag maximum utility;
   data temp2(keep=_u1 - _u&nsubs &idvars);
      if _n_ = 1 then set temp1(drop=_type_ _freq_);
      array u[&nsubs] _u1 - _u&nsubs;
      array m[&nsubs] _sum1 - _sum&nsubs;
      set temp2;
      do i = 1 to &nsubs;
         u[i] = ((u[i] - m[i]) > -1e-8); /* < 1e-8 is considered 0 */
         end;
      run;

   %end;

* Compute sum for each subject;
proc means data=temp2 noprint;
   var _u1-_u&nsubs;
   output out=temp1 sum=_sum1 - _sum&nsubs;
   run;

* Compute expected market share;
data &out(keep=share &idvars);
   if _n_ = 1 then set temp1(drop=_type_ _freq_);
   array u[&nsubs] _u1 - _u&nsubs;
   array m[&nsubs] _sum1 - _sum&nsubs;
   set temp2;

   * Compute final probabilities;
   do i = 1 to &nsubs;
      u[i] = u[i] / m[i];
      end;

   * Compute expected market share;
   %if %length(&weights) = 0 %then %do;
      Share = mean(of _u1 - _u&nsubs);
      %end;

   %else %do;
      Share = 0;
      wsum  = 0;
      %do i = 1 %to &nsubs;
         %let w = %scan(&weights, &i, %str( ));
         %if %length(&w) = 0 %then %let w = .;
         if &w < 0 then do;
            if _n_ > 1 then stop;
            put "ERROR: Invalid weight &w..";
            call symput('okay', 'no');
            end;
         share = share + &w * _u&i;
         wsum  = wsum  + &w;
         %end;
      share = share / wsum;
      %end;
   run;

options notes;

%if &okay ne yes %then %goto endit;

proc sort;
   by descending share &idvars;
   run;

proc print label noobs;
   title2 'Expected Market Share';
   title3 %if       &method = max %then "Maximum Utility Model";
          %else %if &method = btl %then "Bradley-Terry-Luce Model";
          %else                         "Logit Model";;
   run;

%endit:

%mend;

title 'Spaghetti Sauces';

%sim(data=results2, out=maxutils, method=max,
     idvars=price brand meat mushroom ingredients);

title 'Spaghetti Sauces';

%sim(data=results2, out=btl, method=btl,
     idvars=price brand meat mushroom ingredients);

%sim(data=results2, out=logit, method=logit,
     idvars=price brand meat mushroom ingredients);

title 'Spaghetti Sauces';

proc format;
   invalue inbrand 'Preg'=1 'Sun' =2 'Tom' =3;
   invalue inmeat  'Veg' =1 'Meat'=2 'Ital'=3;
   invalue inmush  'Mush'=1 'No'  =2;
   invalue iningre 'Nat' =1 'No'  =2;
   invalue inprice '1.99'=1 '2.29'=2 '2.49'=3 '2.79'=4 '2.99'=5;
   run;

data simulat;
   input brand       : inbrand.
         meat        : inmeat.
         mushroom    : inmush.
         ingredients : iningre.
         price       : inprice.;
   datalines;
Preg  Veg   Mush  Nat  1.99
Sun   Veg   Mush  Nat  1.99
Tom   Veg   Mush  Nat  1.99
Preg  Meat  Mush  Nat  2.49
Sun   Meat  Mush  Nat  2.49
Tom   Meat  Mush  Nat  2.49
Preg  Ital  Mush  Nat  2.79
Sun   Ital  Mush  Nat  2.79
Tom   Ital  Mush  Nat  2.79
;

data inputdata2(drop=&droplist);
   set inputdata(in=w) simulat;
   Weight = w;
   run;

proc print;
   title2 'Simulation Observations Have a Weight of Zero';
   id weight;
   var brand -- price;
   run;

ods exclude notes mvanova anova;
proc transreg data=inputdata2 utilities short noprint
   separators=', ' lprefix=0 method=morals outtest=utils;
   title2 'Conjoint Analysis';
   model identity(sub:) =
         class(brand | price meat mushroom ingredients / zero=sum);
   output p ireplace out=results3 coefficients;
   weight weight;
   run;

data model;
   set utils;
   if statistic in ('R-Square', 'Adj R-Sq', 'Model');
   Subj = scan(_depvar_, 2);
   if statistic = 'Model' then do;
      value = numdf;
      statistic = 'Num DF';
      output;
      value = dendf;
      statistic = 'Den DF';
      output;
      value = dendf + numdf + 1;
      statistic = 'N';
      end;
   output;
   keep statistic value subj;
   run;

proc transpose data=model out=summ;
   by subj;
   idlabel statistic;
   id statistic;
   run;

proc print label data=summ(drop=_name_ _label_); run;

data results4;
   set results3;
   where weight = 0;
   run;

%sim(data=results4, out=shares2, method=max,
     idvars=price brand meat mushroom ingredients);

data simulat2;
   input brand       : inbrand.
         meat        : inmeat.
         mushroom    : inmush.
         ingredients : iningre.
         price       : inprice.;
   datalines;
Preg Meat Mush Nat 2.29
Sun  Meat Mush Nat 2.29
Tom  Meat Mush Nat 2.29
Preg Ital Mush Nat 2.49
Sun  Ital Mush Nat 2.49
Tom  Ital Mush Nat 2.49
;

data inputdata3(drop=&droplist);
   set inputdata(in=w) simulat simulat2;
   weight = w;
   run;

ods exclude notes mvanova anova;
proc transreg data=inputdata3 utilities short noprint
   separators=', ' lprefix=0 method=morals outtest=utils;
   title2 'Conjoint Analysis';
   model identity(sub:) =
         class(brand | price meat mushroom ingredients / zero=sum);
   output p ireplace out=results5 coefficients;
   weight weight;
   run;

data model;
   set utils;
   if statistic in ('R-Square', 'Adj R-Sq', 'Model');
   Subj = scan(_depvar_, 2);
   if statistic = 'Model' then do;
      value = numdf;
      statistic = 'Num DF';
      output;
      value = dendf;
      statistic = 'Den DF';
      output;
      value = dendf + numdf + 1;
      statistic = 'N';
      end;
   output;
   keep statistic value subj;
   run;

proc transpose data=model out=summ;
   by subj;
   idlabel statistic;
   id statistic;
   run;

proc print label data=summ(drop=_name_ _label_); run;

data results6;
   set results5;
   where weight = 0;
   run;

%sim(data=results6, out=shares3, method=max,
     idvars=price brand meat mushroom ingredients);

title 'Spaghetti Sauces';

proc sort data=shares2;
   by price brand meat mushroom ingredients;
   run;

proc sort data=shares3;
   by price brand meat mushroom ingredients;
   run;

data both;
   merge shares2(rename=(share=OldShare)) shares3;
   by price brand meat mushroom ingredients;
   if oldshare = . then Change = 0;
   else change = oldshare;
   change = share - change;
   run;

proc sort;
   by descending share price brand meat mushroom ingredients;
   run;

options missing=' ';
proc print noobs;
   title2 'Expected Market Share and Change';
   var price brand meat mushroom ingredients
       oldshare share change;
   format oldshare -- change 6.3;
   run;
options missing=.;

********************** Begin Syntax Sample Code ***********************;

options ls=80 ps=60 nonumber nodate;
title;

proc format;
   value wf 1  = 'Active'
            .  = 'Holdout'
            0  = 'Simulation';
   run;

   /* * Uncomment this code if you want it to run;

data x;
   do x = 0.1 to 14 by 0.25;
      y = log(x) + sin(x) + 0.3 * cos(x * 5);
      output;
      end;
   run;

proc transreg;
   model ide(y / name=(mon)) = monotone(x);
   output p;
   id y;
   run;

proc transreg;
   model ide(y / name=(spl)) = spl(x / nkn=5);
   output p;
   id y pmon;
   run;

proc transreg;
   model ide(y / name=(msp)) = mspl(x / nkn=5);
   output p;
   id y pmon pspl;
   run;

proc transreg;
   model ide(y / name=(ide)) = ide(x);
   output p;
   id y pmon pspl pmsp;
   run;

data; set;
   pspl + 6; spy = y + 6;
   pmsp + 4; msy = y + 4;
   pmon + 2; moy = y + 2;
   run;

proc template;
   define statgraph plot;
      begingraph;
         entrytitle  'Functions Available in PROC TRANSREG';
         layout overlay / xaxisopts=(display=none)
                          yaxisopts=(display=none);
            seriesplot   x=x y=pspl  / lineattrs=graphdata4
                                       curvelabelattrs=graphdata4
                                       curvelabel='Smooth Spline Function';
            seriesplot   x=x y=pmsp  / lineattrs=graphdata3
                                       curvelabelattrs=graphdata3
                                       curvelabel='Smooth Monotone Spline';
            seriesplot   x=x y=pmon  / lineattrs=graphdata2
                                       curvelabelattrs=graphdata2
                                       curvelabel='Monotone Step';
            seriesplot   x=x y=pide  / lineattrs=graphdata1
                                       curvelabelattrs=graphdata1
                                       curvelabel='Line';
            scatterplot   x=x y=spy / markerattrs=graphdata4;
            scatterplot   x=x y=msy / markerattrs=graphdata3;
            scatterplot   x=x y=moy / markerattrs=graphdata2;
            scatterplot   x=x y=y   / markerattrs=graphdata1;
            endlayout;
        endgraph;
      end;
   run;

%modstyle(parent=statistical, name=mystat)
ods listing style=mystat gpath='png';
ods graphics / reset=index imagename="curve1";

proc sgrender template=plot; run;

   */

* Create data set for use later.;
data a;
   array v[5] x1-x5;
   array rating[100];
   array ranking[100];
   w = 1;
   do i = 1 to 25;
      do j = 1 to 100;
         rating[j]  = ceil(9 * uniform(7));
         ranking[j] = ceil(25 * uniform(7));
         end;
      price = ceil(3 * uniform(7));
      do j = 1 to 5;
         v[j] = floor(abs(normal(7)));
         end;
      output;
      end;
   run;

ods listing close;

ods exclude notes mvanova anova;
proc transreg data=a utilities short method=morals;
   model identity(rating1-rating100) = class(x1-x5 / zero=sum);
   output p ireplace;
   weight w;
   run;

ods exclude notes anova liberalanova conservanova
            mvanova liberalmvanova conservmvanova;
proc transreg data=a utilities short maxiter=500 method=morals;
   model monotone(ranking1-ranking100 / reflect) = class(x1-x5 / zero=sum);
   output p ireplace;
   weight w;
   run;

ods exclude notes anova liberalanova conservanova
            mvanova liberalmvanova conservmvanova;
proc transreg data=a utilities short maxiter=500 method=morals;
   model mspline(ranking1-ranking100 / reflect) =
         class(x1-x5 / zero=sum);
   output p ireplace;
   weight w;
   run;

ods exclude notes anova liberalanova conservanova
            mvanova liberalmvanova conservmvanova;
proc transreg data=a utilities short maxiter=500 method=morals;
   model mspline(ranking1-ranking100 / reflect nknots=3) =
         class(x1-x5 / zero=sum);
   output p ireplace;
   weight w;
   run;

ods exclude notes anova liberalanova conservanova
            mvanova liberalmvanova conservmvanova
            liberalutilities liberalfitstatistics;
proc transreg data=a utilities short maxiter=500 method=morals;
   model identity(rating1-rating100) = class(x1-x3 / zero=sum)
         identity(x4) monotone(x5);
   output p ireplace;
   weight w;
   run;

ods exclude notes anova liberalanova conservanova
            mvanova liberalmvanova conservmvanova
            liberalutilities liberalfitstatistics;
proc transreg data=a utilities short maxiter=500 method=morals;
   model identity(rating1-rating100) = monotone(x1-x5) mspline(price);
   output p ireplace;
   weight w;
   run;

ods exclude notes anova liberalanova conservanova
            mvanova liberalmvanova conservmvanova
            liberalutilities liberalfitstatistics;
proc transreg data=a utilities short maxiter=500 method=morals;
   model identity(rating1-rating100) =
         class(x1-x5 / zero=sum)
         mspline(price / knots=2 2 2 3 3 3);
   output p ireplace;
   weight w;
   run;

ods listing;
