 /****************************************************************/
 /*          S A S   S A M P L E   L I B R A R Y                 */
 /*                                                              */
 /*    NAME: MR2010F                                             */
 /*   TITLE: Discrete Choice 7                                   */
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

************ Begin Prescription Drug Example Code ***********;

title 'Allocation of Prescription Drugs';

%mktruns(3 ** 10)

%let nalts = 10;

%mktex(3 ** &nalts 3, n=27, seed=396)

* Due to machine differences, you might not get the same design if you run
* the step above, so here is the design that is used in the book;
data randomized; input x1-x11 @@; datalines;
3 3 2 3 2 3 2 1 2 1 1 2 3 2 1 3 2 1 3 2 2 2 2 3 3 3 2 1 2 2 3 2 3 1 1 2
1 2 3 3 3 3 1 3 3 2 2 1 1 1 2 3 1 3 1 1 3 1 3 2 2 2 3 1 3 2 3 1 2 2 3 2
2 2 3 2 1 1 1 1 2 3 1 2 1 2 1 2 3 1 3 1 2 1 3 1 1 2 2 3 1 1 3 1 3 1 3 2
2 3 3 2 1 2 2 2 1 1 3 3 3 1 2 1 1 1 3 2 2 3 2 2 2 1 2 3 1 1 1 1 3 3 2 1
2 2 3 3 2 3 1 1 2 3 3 2 3 3 3 3 3 2 2 3 2 2 2 1 3 3 1 3 3 3 1 1 3 3 1 1
3 1 1 2 1 1 3 1 1 3 3 1 2 1 2 1 1 1 1 3 2 2 1 1 3 2 2 3 3 3 3 3 2 1 2 3
3 3 1 2 1 3 3 1 3 3 1 1 3 3 1 2 1 3 2 3 3 2 3 1 3 3 1 2 3 2 2 1 1 3 2 2
1 2 3 1 2 1 3 3 1 1 2 1 2 1 1 1 2 2 3 2 2 3 1 2 2 2 2 2 3 1 2 1 1 2 2 2
3 1 1 2 2 1 2 1 3
;

data key(drop=i);
   input Block Brand1;
   array Brand[10];
   do i = 2 to 10; brand[i] = brand1; end;
   format brand: dollar4.;
   datalines;
1  50
2  75
3 100
;

proc print; run;

%mktlab(data=randomized, key=key)

proc sort out=sasuser.DrugAlloLinDes; by block; run;

proc print; id block; by block; run;

%mkteval(blocks=block)

%mktkey(Brand1-Brand10)

data key(keep=Brand Price);
   input Brand $ 1-8 Price $;
   datalines;
Brand  1    Brand1
Brand  2    Brand2
Brand  3    Brand3
Brand  4    Brand4
Brand  5    Brand5
Brand  6    Brand6
Brand  7    Brand7
Brand  8    Brand8
Brand  9    Brand9
Brand 10    Brand10
-           .
;

%mktroll(design=sasuser.DrugAlloLinDes, key=key, alt=brand, out=rolled,
         options=nowarn)

%choiceff(data=rolled,              /* candidate set of choice sets         */
          init=rolled(keep=set),    /* select these sets                    */
          intiter=0,                /* evaluate without internal iterations */
                                    /* model with stdz orthogonal coding    */
                                    /* ref level for brand is '-'           */
          model=class(brand price / zero='-' sta),
          options=relative,         /* display relative D-efficiency        */
          nsets=27,                 /* number of choice sets                */
          nalts=11,                 /* number of alternatives               */
          beta=zero)                /* assumed beta vector, Ho: b=0         */

data results(drop=i s n sub);
   length Block Subject Set 8;
   do sub  = 1 to 100;
      do Block = 1 to 3;
         Subject + 1;
         do s = 1 to 9;
            array Freq[&nalts];
            do i = 1 to &nalts; freq[i] = 0; end;
            if uniform(7) > 0.01 then
               do until(sum(of freq1-freq&nalts) = 10);
               freq[3] = 5 * (uniform(7) > 0.3);
               n = max(1, min(&nalts, round(abs(5 * normal(7)))));
               do i = 1 to n;
                  freq[ceil(&nalts * uniform(7))] +
                       round(abs(4 * normal(7)));
                  end;
               n = max(1, sum(of freq1-freq&nalts));
               do i = 1 to &nalts;
                  freq[i] = round(10 * freq[i] / n);
                  end;
               end;
            Set = (block - 1) * 9 + s;
            output;
            end;
         end;
      end;
   run;

data _null_;
   set results;
   put Block 1. Subject 4. Set 2. @9 (freq1-freq&nalts) (2.);
   if _n_ = 11 then stop;
   run;

data allocs(keep=block set brand count);
   set results;
   array freq[&nalts];

   * Handle the &nalts alternatives;
   do b = 1 to &nalts;
      Brand = 'Brand ' || put(b, 2.);
      Count = freq[b];
      output;
      end;

   * Constant alt choice is implied if nothing else is chosen.
     brand = ' ' is used to flag the constant alternative.;
   brand = ' ';
   count = 10 * (sum(of freq:) = 0);
   output;
   run;

proc print data=results(obs=3) label noobs; run;
proc print data=allocs(obs=33); id block set; by block set; run;

* Aggregate, store the results back in count.;

proc summary data=allocs nway missing;
   class set brand;
   output sum(count)=Count out=allocs(drop=_type_ _freq_);
   run;

%mktkey(Brand1-Brand10)

data key(keep=Brand Price);
   input Brand $ 1-8 Price $;
   datalines;
Brand  1    Brand1
Brand  2    Brand2
Brand  3    Brand3
Brand  4    Brand4
Brand  5    Brand5
Brand  6    Brand6
Brand  7    Brand7
Brand  8    Brand8
Brand  9    Brand9
Brand 10    Brand10
.           .
;

%mktroll(design=sasuser.DrugAlloLinDes, key=key, alt=brand, out=rolled,
         options=nowarn)

proc print data=rolled(obs=11); format price dollar4.; run;

proc sort data=rolled; by set brand; run;

data allocs2;
   merge allocs(in=flag1) rolled(in=flag2);
   by set brand;
   if flag1 ne flag2 then put 'ERROR: Merge is not 1 to 1.';
   format price dollar4.;
   run;

proc print data=allocs2(obs=22);
   var brand price count;
   sum count;
   by notsorted set;
   id set;
   run;

%mktallo(data=allocs2, out=allocs3, nalts=%eval(&nalts + 1),
         vars=set brand price, freq=Count)

proc print data=allocs3(obs=22);
   var set brand price count c;
   run;

proc transreg design data=allocs3 nozeroconstant norestoremissing;
   model class(brand price / zero=none) / lprefix=0;
   output out=coded(drop=_type_ _name_ intercept);
   id set c count;
   run;

proc phreg data=coded;
   where count > 0;
   model c*c(2) = &_trgind / ties=breslow;
   freq count;
   strata set;
   run;

data coded2;
   set coded;
   count = count / 10;
   run;

proc phreg data=coded2;
   where count > 0;
   model c*c(2) = &_trgind / ties=breslow;
   freq count / notruncate;
   strata set;
   run;

%phchoice(off)
