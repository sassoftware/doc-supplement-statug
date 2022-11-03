 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: MR2010F                                             */
 /*   TITLE: Discrete Choice 3                                   */
 /* PRODUCT: STAT                                                */
 /*  SYSTEM: ALL                                                 */
 /*    KEYS: marketing research                                  */
 /*   PROCS: PHREG, TRANSREG, OPTEX, FACTEX, PLAN, IML           */
 /*    DATA:                                                     */
 /*                                                              */
  /*     REF: MR-2010F Discrete Choice                            */
 /*    MISC: This file contains SAS code for the "Discrete       */
 /*          Choice" report, the 01Oct2010 edition, for SAS 9.2. */
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

************* Begin PHREG Output Customization **************;
options ls=80 ps=60 nonumber nodate;

%phchoice(on)

**************** Begin Vacation Example Code ****************;

title 'Vacation Example';

%mktruns(3 ** 15)

%mktorth(range=n=36)

proc sort data=mktdeslev out=list(drop=x:);
   by descending x3;
   where x3;
   run;

proc print; run;

%let m   = 6;                    /* m alts including constant        */
%let mm1 = %eval(&m - 1);        /* m - 1                            */
%let n   = 18;                   /* number of choice sets per person */
%let blocks = 2;                 /* number of blocks                 */

%mktex(3 ** 15 2, n=&n * &blocks, seed=151)

* Due to machine differences, you might not get the same design if you run
* the step above, so here is the design that is used in the book;
data randomized; input x1-x16 @@; datalines;
1 1 3 3 1 3 3 1 2 1 2 1 3 3 3 2 3 1 3 2 2 3 3 2 1 2 1 2 2 2 2 2 3 3 1 2
1 2 1 1 1 1 2 2 3 1 1 2 1 3 3 1 1 1 1 2 2 2 3 2 1 3 1 1 3 2 3 1 1 1 3 3
1 3 2 3 1 2 2 2 1 2 1 2 3 1 3 1 1 2 3 1 2 2 3 1 2 3 3 3 2 3 1 3 3 3 2 2
2 2 3 1 3 3 2 3 1 3 2 3 1 2 3 1 3 2 1 1 3 2 1 3 3 3 1 2 2 2 2 3 1 1 3 1
3 1 3 2 3 2 1 3 2 3 3 1 2 3 1 2 1 2 2 3 2 1 2 2 1 1 2 2 2 3 1 2 2 1 2 2
3 3 2 1 1 3 2 3 1 3 1 1 1 1 1 1 3 2 3 2 3 3 2 2 3 2 1 1 2 2 3 2 1 2 2 2
3 2 2 1 3 3 2 1 2 1 1 3 1 1 1 2 1 3 1 1 1 1 3 2 3 2 3 1 3 3 2 1 3 1 3 2
1 1 3 2 3 1 2 1 2 1 1 1 3 2 2 1 2 1 2 1 2 3 1 1 3 1 2 3 2 1 2 1 2 2 2 2
3 3 2 3 3 1 3 1 2 3 1 2 3 3 2 1 1 3 2 2 3 3 1 2 3 1 1 1 1 2 2 2 3 2 1 3
2 2 3 3 3 1 1 1 1 3 1 1 2 2 2 1 3 2 1 3 1 2 1 2 3 3 3 2 2 2 3 2 2 1 1 1
2 1 1 3 3 2 1 1 2 3 1 1 1 3 3 1 3 2 1 3 2 3 1 2 2 2 2 1 2 3 3 2 2 3 3 1
3 1 1 2 1 2 2 3 1 2 1 1 3 3 3 3 2 2 2 2 1 1 3 3 3 1 2 3 3 2 1 3 3 1 1 2
3 3 1 2 2 1 2 2 3 3 3 3 3 3 3 2 3 1 2 1 1 2 2 2 2 1 1 3 2 2 3 1 1 3 3 1
2 2 2 1 1 3 1 1 1 1 3 1 1 2 1 2 1 3 2 3 2 3 1 2 2 1 2 1 1 3 2 2 2 2 3 3
2 2 2 3 1 1 3 2 2 1 2 2 1 1 3 3 3 1 3 2 1 1 3 1 2 1 1 3 2 2 2 1 2 2 3 2
1 2 2 2 1 1 1 1 2 3 1 3 1 1 3 3 3 3 2 1 2 3 3 3 3 2 3 2 1 1 3 3 2 1 2 1
;

data design; input x1-x16 @@; datalines;
1 1 1 1 1 1 1 1 1 1 1 1 1 2 3 1 1 1 1 1 2 2 3 3 2 2 3 3 1 1 2 1 1 1 2 2
1 1 2 2 3 3 3 3 1 2 3 2 1 1 2 2 3 3 3 3 1 1 2 2 1 3 1 2 1 2 1 3 1 3 2 3
3 2 1 2 2 3 1 1 1 2 1 3 3 1 3 2 2 3 2 1 2 1 2 1 1 2 3 1 2 3 1 2 3 1 2 3
2 1 3 2 1 2 3 1 3 2 2 1 1 3 3 2 2 2 2 2 1 3 2 3 2 3 2 1 2 1 3 1 3 2 1 1
1 3 2 3 3 2 1 2 1 2 1 3 3 3 3 1 1 3 3 2 1 2 3 1 3 2 2 1 3 3 2 2 1 3 3 2
2 1 1 3 2 3 1 2 3 1 1 2 2 1 1 3 2 3 1 2 1 3 3 2 3 3 2 2 2 1 1 3 3 2 2 1
3 1 2 3 3 1 1 2 2 1 3 1 1 3 2 3 2 3 2 1 3 3 3 1 2 1 3 1 3 1 3 2 3 2 1 2
3 2 1 1 2 2 2 2 2 2 2 2 2 2 2 2 1 2 3 1 2 2 2 2 3 3 1 1 3 3 1 1 1 1 2 1
2 2 3 3 1 1 1 1 2 2 3 3 1 3 1 2 2 2 3 3 2 2 3 3 1 1 1 1 1 2 3 2 2 3 1 2
1 3 3 2 2 1 1 3 2 2 2 2 2 3 1 2 3 1 2 3 1 2 3 1 2 1 3 2 2 3 2 1 1 2 1 3
3 1 3 2 2 1 2 1 2 3 2 1 2 1 3 1 1 3 2 3 2 3 1 1 3 1 2 3 1 2 3 1 2 3 1 2
2 1 3 2 3 1 2 3 2 1 1 3 3 2 2 1 2 2 2 2 3 1 3 2 2 3 2 1 1 2 1 3 2 1 2 1
3 1 3 2 3 2 1 2 2 1 3 1 2 3 1 1 3 2 1 2 1 2 1 3 1 3 2 3 3 2 1 1 3 2 1 2
2 1 3 1 3 1 3 2 3 3 3 1 3 2 2 1 1 3 3 2 1 2 3 1 3 1 1 2 3 2 2 1 3 1 2 3
2 1 1 3 3 3 2 2 3 3 1 1 2 2 2 2 3 3 1 1 1 3 1 2 3 3 1 1 3 3 1 1 2 2 2 2
1 2 3 2 3 3 3 3 1 1 2 2 1 1 2 2 1 1 2 1 3 3 3 3 3 3 3 3 3 3 3 3 1 2 3 1
;

%mkteval(data=randomized)

%mktex(3 ** 15,                     /* all attrs of all alternatives        */
       n=&n * &blocks,              /* total number of choice sets          */
       init=randomized(drop=x16),   /* initial design                       */
       options=check,               /* check initial design efficiency      */
       examine=i v)                 /* show information & variance matrices */

%mktlab(data=randomized, vars=x1-x5 x11-x15 x6 x9 x7 x8 x10 Block,
        out=sasuser.VacationLinDesBlckd)

proc sort data=sasuser.VacationLinDesBlckd; by block; run;

%mkteval(blocks=block)

%mktkey(5 3 t)

title 'Vacation Example';

data key;
   input Place $ 1-10 (Lodge Scene Price) ($);
   datalines;
Hawaii      x1    x6     x11
Alaska      x2    x7     x12
Mexico      x3    x8     x13
California  x4    x9     x14
Maine       x5    x10    x15
Home        .     .      .
;

%mktroll(design=sasuser.VacationLinDesBlckd, key=key, alt=place,
         out=sasuser.VacationChDes)

proc print data=sasuser.VacationLinDesBlckd(obs=2);
   id Block;
   var x1-x15;
   run;

proc print data=sasuser.VacationChDes(obs=12);
   id set; by set;
   run;

proc format;
   value price 1 = ' 999'      2 = '1249'
               3 = '1499'      0 = '   0';
   value scene 1 = 'Mountains' 2 = 'Lake'
               3 = 'Beach'     0 = 'Home';
   value lodge 1 = 'Cabin'     2 = 'Bed & Breakfast'
               3 = 'Hotel'     0 = 'Home';
   run;

data sasuser.VacationChDes;
   set sasuser.VacationChDes;
   if place = 'Home' then do; lodge = 0; scene = 0; price = 0; end;
   price = input(put(price, price.), 5.);
   format scene scene. lodge lodge.;
   run;

proc print data=sasuser.VacationChDes(obs=12);
   id set; by set;
   run;

title2 'Evaluate the Choice Design';

%choiceff(data=sasuser.VacationChDes,/* candidate set of choice sets        */
          init=sasuser.VacationChDes(keep=set), /* select these sets        */
          intiter=0,                /* evaluate without internal iterations */
                                    /* alternative-specific effects model   */
                                    /* zero=none - use all levels of place  */
                                    /* order=data - do not sort levels      */
          model=class(place / zero=none order=data)
                                    /* place * price ... - interactions or  */
                                    /*    alternative-specific effects      */
                class(place * price place * scene place * lodge /
                      zero=none     /* zero=none - use all levels of place  */
                      order=formatted) / /* order=formatted - sort levels   */
                lprefix=0           /* lpr=0 labels created from just levels*/
                cprefix=0           /* cpr=0 names created from just levels */
                separators=' ' ', ',/* use comma sep to build interact terms*/

          nsets=36,                 /* number of choice sets                */
          nalts=6,                  /* number of alternatives               */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

proc reg data=tmp_cand;
   model Alaska_1499 = Alaska Alaska_999 Alaska_1249 / noint;
   run; quit;

proc freq data=tmp_cand;
   tables Alaska_0;
   run;

title2 'Evaluate the Choice Design';
%choiceff(data=sasuser.VacationChDes,/* candidate set of choice sets        */
          init=sasuser.VacationChDes(keep=set), /* select these sets        */
          intiter=0,                /* evaluate without internal iterations */
                                    /* alternative-specific effects model   */
                                    /* ref level for place is 'Home'        */
                                    /* order=data - do not sort levels      */
          model=class(place / zero='Home' order=data)
                                    /* ref level for place is 'Home'        */
                                    /* ref level for price is 0             */
                                    /* ref level for scene is 'Home'        */
                                    /* ref level for lodge is 'Home'        */
                                    /* order=formatted - sort levels        */
                class(place * price place * scene place * lodge /
                      zero='Home' '0' 'Home' 'Home' order=formatted) /
                lprefix=0           /* lpr=0 labels created from just levels*/
                cprefix=0           /* cpr=0 names created from just levels */
                separators=' ' ', ',/* use comma sep to build interact terms*/
          nsets=36,                 /* number of choice sets                */
          nalts=6,                  /* number of alternatives               */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

title2 'Evaluate the Choice Design';

%choiceff(data=sasuser.VacationChDes,/* candidate set of choice sets        */
          init=sasuser.VacationChDes(keep=set), /* select these sets        */
          intiter=0,                /* evaluate without internal iterations */
                                    /* alternative-specific effects model   */
                                    /* ref level for place is 'Home'        */
                                    /* order=data - do not sort levels      */
          model=class(place / zero='Home' order=data)
                                    /* ref level for place is 'Home'        */
                                    /* ref level for price is 0             */
                                    /* ref level for scene is 'Home'        */
                                    /* ref level for lodge is 'Home'        */
                                    /* order=formatted - sort levels        */
                class(place * price place * scene place * lodge /
                      zero='Home' '0' 'Home' 'Home' order=formatted) /
                lprefix=0           /* lpr=0 labels created from just levels*/
                cprefix=0           /* cpr=0 names created from just levels */
                separators=' ' ', ',/* use comma sep to build interact terms*/

          nsets=36,                 /* number of choice sets                */
          nalts=6,                  /* number of alternatives               */
                                    /* extra model terms to drop from model */
          drop=Alaska_1499 California_1499 Hawaii_1499 Maine_1499
               Mexico_1499 AlaskaMountains CaliforniaMountains
               HawaiiMountains MaineMountains MexicoMountains AlaskaHotel
               CaliforniaHotel HawaiiHotel MaineHotel MexicoHotel,
          beta=zero)                /* assumed beta vector, Ho: b=0         */

%mktdups(branded, data=sasuser.VacationChDes,
         nalts=6, factors=place price scene lodge)

ods listing close; /* suppress a LOT of output */

title;
proc sort data=sasuser.VacationLinDesBlckd; by block; run;

options ls=80 ps=60 nodate nonumber;

data _null_;
   array dests[&mm1] $ 10 _temporary_ ('Hawaii' 'Alaska' 'Mexico'
                                       'California' 'Maine');
   array prices[3]   $  5 _temporary_ ('$999' '$1249' '$1499');
   array scenes[3]   $ 13 _temporary_
                     ('the Mountains' 'a Lake' 'the Beach');
   array lodging[3]  $ 15 _temporary_
                     ('Cabin' 'Bed & Breakfast' 'Hotel');
   array x[15];
   file print linesleft=ll;

   set sasuser.VacationLinDesBlckd;
   by block;

   if first.block then do;
      choice = 0;
      put _page_;
      put @50 'Form: ' block  ' Subject: ________' //;
      end;
   choice + 1;

   if ll < 19 then put _page_;
   put choice 2. ') Circle your choice of '
       'vacation destinations:' /;
   do dest = 1 to &mm1;
      put '    ' dest 1. ') ' dests[dest]
          +(-1) ', staying in a ' lodging[x[dest]]
          'near ' scenes[x[&mm1 + dest]] +(-1) ',' /
          '       with a package cost of '
         prices[x[2 * &mm1 + dest]] +(-1) '.' /;
      end;
   put "    &m) Stay at home this year." /;
   run;

ods listing;

title 'Vacation Example';

data results;
   input Subj Form (choose1-choose&n) (1.) @@;
   datalines;
  1  1 111353313351554151   2  2 344113155513111413   3  1 132353331151534151
  4  2 341133131523331143   5  1 142153111151334143   6  2 344114111543131151
  7  1 141343111311154154   8  2 344113111343121111   9  1 141124131151342155
 10  2 344113131523131141  11  1 311423131353524144  12  2 332123151413331151
 13  1 311244331352134155  14  2 341114111543131153  15  1 141253111351344151
 16  2 344135131323331143  17  1 142123313154132141  18  2 542113151323131141
 19  1 145314111311144111  20  2 344111131313431143  21  1 133343131313432145
 22  2 344141151213131153  23  1 113453411153334155  24  2 343145151511131153
 25  1 141434111152332144  26  2 334415131511121141  27  1 344144113151334144
 28  2 544344131531131115  29  1 313424133351334151  30  2 344114135513124141
 31  1 131413321111334154  32  2 354113151541131141  33  1 114423121315534144
 34  2 344431151541115141  35  1 141324311331334151  36  2 344114155343131141
 37  1 112423333353534151  38  2 352134131323331141  39  1 112424615353334151
 40  2 444115151523131141  41  1 131123111312532154  42  2 344111131513131131
 43  1 312443131355341155  44  2 344111131333431141  45  1 311453111311534124
 46  2 332111131523134151  47  1 112153333351534111  48  2 342113151513331141
 49  1 114453311351334151  50  2 343115131323132141  51  1 112324333311542144
 52  2 341411151313121154  53  1 143453113353334151  54  2 344113151513134141
 55  1 311314111113334144  56  2 344111151343331151  57  1 111423333153134151
 58  2 544114131523331131  59  1 314144311313134141  60  2 344124131253131143
 61  1 112224121351132141  62  2 344311431523331143  63  1 132223233313332151
 64  2 344124151323331155  65  1 141444313351154154  66  2 341131151333131151
 67  1 112443111311354141  68  2 342144151523135145  69  1 312453133353134114
 70  2 343114431343334141  71  1 353443333311534151  72  2 351114151323335154
 73  1 134124133311334141  74  2 341111151513131143  75  1 142123131111334151
 76  2 331144131543131141  77  1 145353313131532154  78  2 355134131523121151
 79  1 115443311355334121  80  2 344111131323131111  81  1 151223113152332123
 82  2 344114135323134141  83  1 111114311142132125  84  2 554113135323111131
 85  1 311423135351332144  86  2 344141151513131145  87  1 113154111353334151
 88  2 342114151523331111  89  1 115414111151332154  90  2 345115451521134111
 91  1 141153131131131154  92  2 344114111513141143  93  1 314443531152134153
 94  2 344111131323121151  95  1 115123111352534151  96  2 541143151223111151
 97  1 142324113342532153  98  2 344114151533331143  99  1 112424113351334154
100  2 344114131333134141 101  1 111414113355114544 102  2 544113451321334511
103  1 111424311353334134 104  2 341115155313324141 105  1 131314331353132151
106  2 344143131523331141 107  1 233444311353332154 108  2 344113131513234141
109  1 141144121353534154 110  2 343131151251331151 111  1 341443313131334151
112  2 341114151523131134 113  1 131424311121532144 114  2 341114151333341143
115  1 111143123311144544 116  2 343114431541111343 117  1 111123113313134154
118  2 344114151523331141 119  1 111123333111533154 120  2 344113131523131151
121  1 212244111154334151 122  2 342114151343334141 123  1 141123513354544144
124  2 354131431343131151 125  1 132313313351334121 126  2 334115151331135153
127  1 312423131453144154 128  2 344415131513531143 129  1 112423331353534151
130  2 341111151333136153 131  1 141453113131132151 132  2 344115131343231153
133  1 115444131351444553 134  2 344114451513321154 135  1 112653131351334145
136  2 544115151253131141 137  1 112113131321334141 138  2 344114131213334141
139  1 313444511353334121 140  2 344113131323131111 141  1 142123111353134151
142  2 342113151333135141 143  1 111413133352143144 144  2 334131151513131131
145  1 135443311353134144 146  2 345114451521121141 147  1 112424313352331141
148  2 344113151313321144 149  1 112313111351144151 150  2 344115231523131151
151  1 115424611351534154 152  2 344113151453334143 153  1 241143111351534154
154  2 344114131211331151 155  1 114434331311134141 156  2 344114131524331113
157  1 112314311154432145 158  2 341113151353111131 159  1 131454131353332141
160  2 341114151223131351 161  1 111124111315332141 162  2 344143155551131141
163  1 113413311352135554 164  2 342113155523331143 165  1 111443111151334154
166  2 344111131323134143 167  1 112124111313154354 168  2 344113131333131151
169  1 115424513353134151 170  2 544114131343421141 171  1 112444331363334141
172  2 342114131323331151 173  1 112444111351534154 174  2 354141151523331111
175  1 213414311353334141 176  2 344143151533331143 177  1 114434133311314151
178  2 344114151523331113 179  1 141113311354534151 180  2 341144131334321141
181  1 241453113113534154 182  2 344113135223131151 183  1 111444113351514145
184  2 351414151323111113 185  1 142423131351332154 186  2 344134151513131145
187  1 313123131352134121 188  2 341143151323131144 189  1 115443133151534151
190  2 333134151123331141 191  1 112423111351134154 192  2 344411151253321153
193  1 111113311351131141 194  2 334115131523331133 195  1 112123113313534151
196  2 345124155313331144 197  1 142154311311434151 198  2 344115151323121141
199  1 141423111351534154 200  2 342131451313134141
;

%mktmerge(design=sasuser.VacationChDes, data=results, out=res2, blocks=form,
          nsets=&n, nalts=&m, setvars=choose1-choose&n)

proc print data=res2(obs=12);
   id subj form set; by subj form set;
   run;

proc transreg design=5000 data=res2 nozeroconstant norestoremissing;
   model class(place / zero=none order=data)
         class(price scene lodge / zero=none order=formatted) /
         lprefix=0;
   output out=coded(drop=_type_ _name_ intercept);
   id subj set form c;
   run;

proc print data=coded(obs=6);
   id place;
   var subj set form c price scene lodge;
   run;

proc print data=coded(obs=6) label;
   var pl:;
   run;

proc print data=coded(obs=6) label;
   id place;
   var sc:;
   run;

proc print data=coded(obs=6) label;
   id place;
   var lo: pr:;
   run;

proc phreg data=coded brief;
   model c*c(2) = &_trgind / ties=breslow;
   strata subj set;
   run;

%put &_trgind;

proc transreg design data=res2 nozeroconstant norestoremissing;
   model class(place / zero='Home' order=data) identity(price)
         class(scene lodge / zero='Home' 'Home' order=formatted) /
         lprefix=0;
   output out=coded(drop=_type_ _name_ intercept);
   label price = 'Price';
   id subj set form c;
   run;

proc phreg data=coded brief;
   model c*c(2) = &_trgind / ties=breslow;
   strata subj set;
   run;

data res3;
   set res2;
   PriceL = price;
   if price then pricel = (price - 1249) / 250;
   run;

proc transreg design=5000 data=res3 nozeroconstant norestoremissing;
   model class(place / zero='Home' order=data)
         pspline(pricel / degree=2)
         class(scene lodge / zero='Home' 'Home' order=formatted) /
         lprefix=0;
   output out=coded(drop=_type_ _name_ intercept);
   label pricel = 'Price';
   id subj set form c;
   run;

proc phreg data=coded brief;
   model c*c(2) = &_trgind / ties=breslow;
   strata subj set;
   run;

data res4;
   set res3;
   if scene = 0 then scene = .;
   if lodge = 0 then lodge = .;
   run;

proc transreg design=5000 data=res4 nozeroconstant norestoremissing;
   model class(place / zero='Home' order=data)
         pspline(pricel / degree=2)
         class(scene lodge /
               effects zero='Mountains' 'Hotel' order=formatted) /
         lprefix=0;
   output out=coded(drop=_type_ _name_ intercept);
   label pricel = 'Price';
   id subj set form c;
   run;

proc print data=coded(obs=6) label; run;

proc phreg data=coded brief;
   model c*c(2) = &_trgind / ties=breslow;
   strata subj set;
   run;

data key;
   input Place $ 1-10 (Lodge Scene Price) ($);
   datalines;
Hawaii      x1  x6   x11
Alaska      x2  x7   x12
Mexico      x3  x8   x13
California  x4  x9   x14
Maine       x5  x10  x15
.           .   .    .
;

%mktroll(design=sasuser.VacationLinDesBlckd, key=key, alt=place,
         out=sasuser.VacationChDes)

%mktmerge(design=sasuser.VacationChDes, data=results, out=res2, blocks=form,
          nsets=&n, nalts=&m, setvars=choose1-choose&n,
          stmts=%str(price = input(put(price, price.), 5.);
                     format scene scene. lodge lodge.;))

proc print data=res2(obs=12); run;

proc transreg design=5000 data=res2 nozeroconstant norestoremissing;
   model class(place / zero=none order=data)
         class(place * price place * scene place * lodge /
               zero=none order=formatted) / lprefix=0 sep=' ' ', ';
   output out=coded(drop=_type_ _name_ intercept);
   id subj set form c;
   run;

proc print data=coded(obs=6) label noobs; run;

proc phreg data=coded brief;
   model c*c(2) = &_trgind / ties=breslow;
   strata subj set;
   run;

* Begin Vacation Example and Artificial Data Generation Code*;

options ls=80 ps=60 nonumber nodate;
title;

%mktex(3 ** 15,                     /* 15 three-level factors               */
       n=36,                        /* 36 rows in linear arrang - 36 ch sets*/
       seed=205)                    /* random number seed                   */

%mktblock(data=randomized,          /* block randomized design              */
          nblocks=2,                /* create two blocks of 18 choice sets  */
          out=blocked,              /* output data set for blocked design   */
          seed=114)                 /* random number seed                   */

                                    /* make Place from the destinations     */
                                    /* make Lodge from x1-x5                */
                                    /* make Scene from x6-x10               */
                                    /* make Price from x11-x15              */
                                    /* make 'stay at home' from all missing */
data key;
   input Place $ 1-10 (Lodge Scene Price) ($);
   datalines;
Hawaii      x1  x6   x11
Alaska      x2  x7   x12
Mexico      x3  x8   x13
California  x4  x9   x14
Maine       x5  x10  x15
.           .   .    .
;

%mktroll(design=blocked,            /* make choice design from blocked      */
                                    /* linear arrangement from %mktblock    */
         key=key,                   /* use rules in KEY data set            */
         alt=place,                 /* alternative name variable is Place   */
         out=sasuser.ChoiceDesign,  /* permanent data set for results       */
         options=nowarn,            /* don't warn about extra variables     */
         keep=block)                /* keep the blocking variable           */

proc format;                        /* map 1, 2, 3 levels to actual levels  */
   value price 1 = '1499'      2 = '1749'            3 = '1999'  . = ' ';
   value scene 1 = 'Mountains' 2 = 'Lake'            3 = 'Beach' . = ' ';
   value lodge 1 = 'Cabin'     2 = 'Bed & Breakfast' 3 = 'Hotel' . = ' ';
   run;

data sasuser.ChoiceDesign;          /* assign formats to vars in the design */
   set sasuser.ChoiceDesign;
   format scene scene. lodge lodge. price price.;
   run;

proc print data=sasuser.ChoiceDesign; /* display sets and check results     */
   by block set; id block set;
   run;

                                    /* Evaluate the choice design           */
%choiceff(data=sasuser.ChoiceDesign,/* candidate set of choice sets         */
          init=sasuser.ChoiceDesign(keep=set), /* select these sets         */
          intiter=0,                /* evaluate without internal iterations */
                                    /* alternative-specific effects model   */
                                    /* zero=none - no ref levels for place  */
                                    /* order=data - do not sort levels      */
          model=class(place / zero=none order=data)
                                    /* zero=' ' - no ref level for first    */
                                    /* factor (place), ordinary ref levels  */
                                    /* for other factors (price -- lodge).  */
                                    /* order=formatted - sort levels        */
                                    /* use blank sep to build interact terms*/
                class(place * price place * scene place * lodge /
                      zero=' ' order=formatted separators='' ' ') /
                                    /* no ref level for place               */
                                    /* use blank sep to build interact terms*/
                lprefix=0           /* lpr=0 labels created from just levels*/
                cprefix=0,          /* cpr=0 names created from just levels */
          nsets=72,                 /* number of choice sets                */
          nalts=6,                  /* number of alternatives               */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

data Test;          /* Make one copy of the input SAS data set.             */
                    /* DATA step does automatic looping, it automatically   */
                    /* writes out the observation to a SAS data set, and it */
                    /* automatically stops when it hits the end of file on  */
                    /* the input SAS data set.  With 216 observations in    */
                    /* the input SAS data set, there are 216 passes through */
                    /* the DATA step, and since there is no OUTPUT          */
                    /* statement, each observation is automatically written */
                    /* to the output SAS data set by an implicit OUTPUT.    */
   set sasuser.ChoiceDesign;
   run;

data Test;          /* Make one copy of the input SAS data set.  There is   */
                    /* one pass through this DATA step, and the DO loop     */
                    /* reads 216 observations from the input SAS data set.  */

                    /* Do the looping yourself.                             */
   do i = 1 to 216; /* 36 choice sets and 6 alternatives = 216 observations */

                    /* SET statement with POINT=i reads the ith             */
                    /* observation, and the variable i is automatically     */
                    /* dropped from the output SAS data set.                */
      set sasuser.ChoiceDesign point=i;

      output;       /* Write out each observation to a SAS data set.        */
                    /* Without this statement, an OUTPUT statement          */
                    /* implicitly appears at the end of the DATA step,      */
                    /* which would have written out only the last           */
                    /* observation if the STOP statement hadn't stopped the */
                    /* DATA step first.                                     */
      end;

   stop;            /* Must specify STOP since it never hits the end of the */
                    /* data file (it never attempts to read past the last   */
                    /* record).  Infinite loop without this statement.      */
   run;

data Test;          /* Make two copies of the input SAS data set.           */
                    /* There is one pass through this DATA step, the outer  */
                    /* DO loop creates two copies, and the inner DO loop    */
                    /* reads 216 observations from the input SAS data set   */
                    /* (twice due to the outer DO loop).                    */

   do Subject = 1 to 2;/* Two copies.                                       */

                    /* Do the looping yourself.                             */
      do i = 1 to 216; /* 36 choice sets and 6 alternatives = 216 obs       */

                    /* SET statement reads the ith observation, and the     */
                    /* variable i is automatically dropped from the output  */
                    /* SAS data set.                                        */
         set sasuser.ChoiceDesign point=i;

         output;    /* Write out each observation to a SAS data set.        */
                    /* Without this statement, an OUTPUT statement          */
                    /* implicitly appears at the end of the DATA step,      */
                    /* which would have written out only the last           */
                    /* observation if the STOP statement hadn't stopped the */
                    /* DATA step first.                                     */
         end;
      end;

   stop;            /* Must specify STOP since it never hits the end of the */
                    /* data file (it never attempts to read past the last   */
                    /* record).  Infinite loop without this statement.      */
   run;

                    /* Make an informat that will convert the character     */
                    /* values of the Place variable into the integers       */
                    /* 1 - 5.                                               */
proc format;
   invalue plinf 'Hawaii' = 1 'Alaska' = 2 'Mexico' = 3
                 'California' = 4 'Maine' = 5;
   run;

data _null_;
   /* DATA _NULL_ allows you to use the DATA step without creating an       */
   /* output SAS data set.  The result is a list of artificial data written */
   /* to the SAS log.                                                       */
   /*                                                                       */
   /* Specify a list of expected utilities for each level of each           */
   /* attribute in an array for each attribute.  Recall that the Price,     */
   /* Scene, and Lodge have actual values 1, 2, 3 that correspond to the    */
   /* formatted values shown here:                                          */
   /*                                                                       */
   /* value price 1 = '1499'      2 = '1749'            3 = '1999'          */
   /* value scene 1 = 'Mountains' 2 = 'Lake'            3 = 'Beach'         */
   /* value lodge 1 = 'Cabin'     2 = 'Bed & Breakfast' 3 = 'Hotel'         */
   /*                                                                       */
   /* In the design data set, actual values are stored not the formatted    */
   /* values.  However, Place has only actual values.                       */
   /*                                                                       */
   /* When Place = 'Hawaii',                                                */
   /* input(place, plinf.) = 1, and the utility, dests[1] = 5;              */
   /* when Place = 'Alaska',                                                */
   /* input(place, plinf.) = 2, and the utility, dests[2] = -1;             */
   /* and so on.                                                            */
   /*                                                                       */
   /* When Scene = 1, and the formatted value is 'Mountains',               */
   /* scenes[1] = -1; and so on.                                            */
   /*                                                                       */
   /* Price has values 1 to 3 and they can be used directly in the          */
   /* utility function (or in a way similar to the other attributes).       */
   /*                                                                       */
   /* _temporary_ is used when the goal is for an array name and an         */
   /* index to access a list of values, and no data set variables are       */
   /* created or needed.                                                    */
   /*                                                                       */
   /* Be careful that your array names and variable names do not            */
   /* conflict with variable names in the input design data set.            */

   array dests[5]    _temporary_ (5 -1 4 3 2);
   array scenes[3]   _temporary_ (-1 0 1);
   array lodging[3]  _temporary_ (0 3 2);

   array u[6];              /* An array to store the utility of each alt    */

   Subject = 0;             /* Subject number                               */

   do s = 1 to 100;         /* Create data for 100 subjects per block       */

      i = 0;                /* Observation number in the design data set    */
      do BlockNum = 1 to 2; /* Create data for 2 blocks of 100 subjects     */
         Subject + 1;       /* Subject number                               */

         /* put /        - go to a new line                                 */
         /* blocknum 3.  - write the block number in 3 columns              */
         /* +2           - skip two columns                                 */
         /* subject  3.  - write the subject number in 3 columns            */
         /* +2           - skip two columns                                 */
         /* @@;          - hold the output line for the data yet to come    */
         put / blocknum 3. +2 subject 3. +2 @@;

         do SetNum = 1 to 18; /* Loop over the 18 sets in a block           */
            do Alt = 1 to 6;  /* Loop over the 6 alts in a set              */

               i + 1;         /* same as i = i + 1; design index,           */
                              /* i = 1 to 216 (2 blocks x 18 sets x 6 alts) */

                              /* Read the ith observation of the choice     */
                              /* design.  Note that you are reading the     */
                              /* choice design not the linear arrangement.  */
                              /* Just read in the variables that you need.  */
               set sasuser.ChoiceDesign(keep=place--price) point=i;

               if place ne ' '/* process the destinations differently       */
                  then do;    /* from the constant 'stay at home'           */
                  p = input(place, plinf.); /* map place values to 1-5      */
                  u[alt] = 1 +              /* add 1 just for not at home   */
                           dests[p] +       /* util for destination         */
                           scenes[scene] +  /* util for scenery             */
                           lodging[lodge] - /* util for lodging             */
                           price;           /* negative util for price      */

                  if place = 'Hawaii' and   /* add in Hawaii/Beach          */
                     scene = 3 then         /* interaction                  */
                     u[alt] = u[alt] + 2;

                  if place = 'Maine' and    /* add Maine on a lake in a     */
                     scene = 2 and lodge = 1/* cabin interaction            */
                     then u[alt] = u[alt] + 1;

                  end;

               else u[alt] = 0;                  /* util for stay at home   */

               u[alt] = u[alt] + 3 * normal(17); /* add error to utils      */
                                                 /* change '3' to change    */
                                                 /* the magnitude of error  */

               /* Alternatively, you can create Type I Gumbel errors for    */
               /* some scaling parameter b as follows:                      */
               /* u[alt] = u[alt] + b * log(-log(1 - uniform(104)));        */
               end;

            /* at this point you have gathered u1-u6 for all 6 alts         */
            m = max(of u1-u6);              /* max util over alts           */

            /* which one had the maximum util? do fuzzy comparison          */
            if      abs(u1 - m) < 1e-4 then c = 1; /* alt 1 is chosen       */
            else if abs(u2 - m) < 1e-4 then c = 2; /* alt 2 is chosen       */
            else if abs(u3 - m) < 1e-4 then c = 3; /* alt 3 is chosen       */
            else if abs(u4 - m) < 1e-4 then c = 4; /* alt 4 is chosen       */
            else if abs(u5 - m) < 1e-4 then c = 5; /* alt 5 is chosen       */
            else                            c = 6; /* alt 6 is chosen (home)*/

            put +(-1) c @@; /* write number of chosen alt. Use '@@' to hold */
                            /* the line for the rest of the data in this    */
                            /* block for this subject.                      */
                            /* +(-1) skips forward -1 space, which is how   */
                            /* you move back one space                      */
            end;
         end;
      end;
   stop;                    /* explicitly stop since no end of file is hit  */
   run;

data results;               /* Read the input data.  List input for block   */
                            /* and subject.  Formatted input (fields of     */
                            /* size 1) for choices.                         */
   input Block Subject (choose1-choose18) (1.);
   datalines;
  1    1 416434213415311535
  2    2 115411541451441151
  1    3 132455331434113144
  2    4 313313244121311314
  1    5 451143532541411214
  2    6 311131311414411511
  1    7 113115431313311134
  2    8 415343411134441331
  1    9 133335335133331114
  2   10 513414531111451413
  1   11 241153533114313111
  2   12 343434311411344311
  1   13 153153351116313414
  2   14 411111241411111131
  1   15 135353234111411114
  2   16 313314541531311331
  1   17 141133313135411111
  2   18 316414131111241313
  1   19 113135362111411511
  2   20 113413441141315561
  1   21 131331413114413534
  2   22 113235341143341331
  1   23 111153311114151414
  2   24 314313331431411111
  1   25 554315432413113314
  2   26 311435151151311131
  1   27 311351233134311151
  2   28 431344341521411151
  1   29 141133453111411254
  2   30 311441451521411131
  1   31 531353433514311411
  2   32 414114444124441111
  1   33 141133334113111113
  2   34 313111341413441131
  1   35 311355431114313111
  2   36 443314331151441633
  1   37 341154311112413154
  2   38 311314634111311111
  1   39 511333331413111134
  2   40 321416411533441431
  1   41 511134411411445111
  2   42 311443144421511351
  1   43 431613313115111514
  2   44 333413451151144131
  1   45 131354333213313144
  2   46 115141411531411114
  1   47 533333431114413111
  2   48 313441441121341511
  1   49 144355331113411514
  2   50 113435351413415311
  1   51 134154331414311511
  2   52 113411544433411551
  1   53 144245433113111553
  2   54 315633156451541151
  1   55 311333332114313311
  2   56 534413315421414351
  1   57 151353333111411114
  2   58 111415414141441511
  1   59 311133311113411113
  2   60 312431411534331313
  1   61 144135313444331134
  2   62 346635144161411114
  1   63 441333353115414154
  2   64 311333241453115133
  1   65 311155141115331511
  2   66 533313154431451531
  1   67 151153333134311514
  2   68 111314645431431151
  1   69 151133113114311531
  2   70 314334561321345141
  1   71 151335333211113114
  2   72 314411214111411114
  1   73 511324112113311511
  2   74 313411151411541143
  1   75 331633361115111112
  2   76 115314411411341114
  1   77 331333433114111154
  2   78 311513144451111361
  1   79 361443114113311111
  2   80 311433411131411141
  1   81 351313131515311111
  2   82 313313111431441531
  1   83 541333315515313131
  2   84 413433315111353131
  1   85 311154535114111114
  2   86 315436331416511131
  1   87 335144311115116154
  2   88 311334341431341151
  1   89 131351331114451133
  2   90 111333541121461111
  1   91 511133531113313311
  2   92 341413135431415111
  1   93 131353131113111311
  2   94 311411511441131531
  1   95 331153361113313514
  2   96 511111511431311131
  1   97 111351463113411111
  2   98 113133151531311131
  1   99 431153512434411511
  2  100 311113511133431131
  1  101 143133364113111434
  2  102 111434343531411311
  1  103 351113332115111514
  2  104 315413341121161121
  1  105 143335333415311111
  2  106 115513351431261111
  1  107 511353311115333311
  2  108 313413151521313131
  1  109 515443531114113534
  2  110 314633311131231531
  1  111 341131313114311111
  2  112 313513143131411111
  1  113 111135431115113111
  2  114 515313511414351331
  1  115 131343511114313154
  2  116 311331141154311134
  1  117 131311431414311514
  2  118 313316114421541514
  1  119 141364434415411114
  2  120 111313311111341331
  1  121 133135311114313155
  2  122 413315341554441131
  1  123 141333311514161331
  2  124 311415411411411161
  1  125 351113433114131111
  2  126 111411345311341134
  1  127 131454135111143111
  2  128 413331551431443351
  1  129 131333331114353554
  2  130 414431411121431511
  1  131 111134331614111354
  2  132 113431531441443131
  1  133 541144134314311431
  2  134 113431351311511135
  1  135 561135433441411114
  2  136 115413541521311111
  1  137 341451133114411151
  2  138 113433314154341341
  1  139 451254544444313515
  2  140 113111311511513333
  1  141 544335333115411111
  2  142 164113311534111331
  1  143 151333231413311154
  2  144 313451111541313134
  1  145 114253313214311154
  2  146 313311141433311551
  1  147 411134531133114551
  2  148 113453415421231531
  1  149 241355333135115111
  2  150 313453415631111313
  1  151 111134332114313114
  2  152 311313545321351131
  1  153 551343431511311114
  2  154 411314551131451354
  1  155 144453111114343154
  2  156 312411341421541361
  1  157 111133431315314511
  2  158 313413111111411334
  1  159 161134331111315114
  2  160 313331511151311133
  1  161 315155151134311314
  2  162 414333611154151131
  1  163 211633131111311114
  2  164 313411441153341111
  1  165 141145133113411561
  2  166 311415211523311111
  1  167 134345132434311554
  2  168 111413155153341113
  1  169 141551332114411111
  2  170 111511111151311131
  1  171 341361115134111514
  2  172 414433151114111334
  1  173 344334361414311111
  2  174 111441411531541534
  1  175 141353333513411114
  2  176 431413451411141343
  1  177 151134111511314554
  2  178 315413351411511521
  1  179 111155531414313114
  2  180 315413311533633134
  1  181 351445331545311635
  2  182 313341541131441111
  1  183 311133313411313144
  2  184 313113331553241431
  1  185 161113616114115111
  2  186 213313412411451531
  1  187 141343141114113111
  2  188 314411441133363333
  1  189 131313311314113151
  2  190 113435111541241131
  1  191 141153431433311113
  2  192 313434111541151511
  1  193 531143112514311531
  2  194 313435311454513531
  1  195 145345244114311511
  2  196 443313441151463131
  1  197 331335333114313112
  2  198 111314251521211141
  1  199 151351211114311131
  2  200 311314311151143141
;

proc print; run;                       /* make sure data match input        */

%mktmerge(design=sasuser.ChoiceDesign, /* merge the design data set         */
          data=results,                /* with the results                  */
          out=res2,                    /* create output data set res2       */
          blocks=block,                /* name of blocking variable         */
          nsets=18,                    /* number of choice sets per block   */
          nalts=6,                     /* number of alternatives            */
          setvars=choose1-choose18)    /* variables with the choices        */

proc print data=res2(obs=18);          /* display some data - sanity check  */
   id block subject set;
   by block subject set;
   run;

proc transreg                          /* use proc transreg to code         */
      data=res2                        /* name of data set to code          */
      design=5000                      /* code big designs in chunks        */
                                       /* code up to 5000 obs at a time     */
      nozeroconstant                   /* don't zero constant variables     */
      norestoremissing;                /* zeros in coded vars, not missings */
   model class(place /                 /* code Place variable               */
               zero=none               /* use all nonmissing levels         */
               order=data)             /* don't sort levels                 */
         class(place * price           /* code other vars                   */
               place * scene
               place * lodge /
               zero=none               /* use all nonmissing levels         */
                                       /* including 0 reference levels      */
               order=formatted         /* do sort levels by formatted values*/
               separators='' ' ') /    /* use blank separator in interacts  */
         lprefix=0;                    /* make labels just from levels      */
   output out=coded                    /* output coded data set             */
        (drop=_type_ _name_ intercept);/* drop vars that you don't need     */
   id subject set block c;             /* add extra vars that you do need   */
   run;

%phchoice( on )                        /* customize output from PHREG for   */
                                       /* choice models                     */

proc phreg data=coded brief;           /* do analysis with a brief summary  */
                                       /* of strata (set, subject, block)   */
   model c*c(2) = &_trgind / ties=breslow; /* standard choice model         */
   strata subject set block;           /* ID variables who taken together   */
   run;                                /* identify each individual choice   */
                                       /* set                               */

data _null_;
   do s = 1 to 100;
      do BlockNum = 1 to 2;
         Subject + 1;
         put / blocknum 3. +2 subject 3. +2 @@;
         do SetNum = 1 to 18;
            c = ceil(6 * uniform(17));
            put +(-1) c @@;
            end;
         end;
      end;
   stop;
   run;

proc freq data=coded noprint;
   tables subject*set*block / list out=t1;
   run;

proc freq; tables count; run;

proc freq data=coded noprint;
   tables subject*set / list out=t1;
   run;

proc freq; tables count; run;

%phchoice(off)
