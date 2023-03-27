/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: crspex3                                             */
/*   TITLE: Documentation Example 3 for PROC CORRESP            */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: marketing research, categorical data analysis       */
/*   PROCS: CORRESP                                             */
/****************************************************************/

proc corresp data=sashelp.heart short obs mca outc=c1;
   ods output burt=burt;
   tables DeathCause Sex Chol_Status BP_Status Weight_Status Smoking_Status;
run;

proc corresp data=burt short mca nvars=6 outc=c2;
   var _numeric_;
run;

data c2; length _NAME_ $ 26; set c2; run;

proc compare error note nosummary criterion=1e-10
   data=c1 compare=c2 method=relative(1);
run;

                            /*---------------------------------------------*/
                            /* Create a Burt table.                        */
%macro burt(data=_last_,    /* Input SAS data set.                         */
            vars=,          /* Variable list.                              */
            options=nomiss, /* If you know that you have no missing        */
                            /* values, you might speed things up by        */
                            /* instead specifying options=.                */
            out=Burt,       /* Output SAS data set.                        */
           );;              /*---------------------------------------------*/

%let _t = %sysfunc(time());
%if &data eq _last_ %then %let data = &syslast;

proc contents data=&data(keep=&vars) noprint out=_cont(keep=length); run;

data _null_;
   set _cont end=eof;
   retain max 0;
   max = max(length, max);
   if eof then do;
      l = floor(log10(_n_)) + 1;
      call symputx('_opt', catx(' ', getoption('source'),
                   'varlenchk=', getoption('varlenchk')));
      call symputx('_f', l );
      call symputx('_lablen', l + max + 1, 'G');
      call symputx('_nvars', _n_, 'G');
      call symputx('_nomiss', lowcase(symget('options')) eq 'nomiss');
   end;
run;

options nosource varlenchk=nowarn;
data _r2(keep=_r1 _r2) / view=_r2;
   length _r1 _r2 $ &_lablen;
   set &data(keep=&vars);
   array _x[&_nvars] $ &vars;
   %if &_nomiss %then %do; if cmiss(of _x[*]) eq 0; %end;
   do _j = 1 to &_nvars;
      _r1 = cats('v', put(_j,z&_f..), _x[_j]); _r2 = _r1; output;
      do _k = _j+1 to &_nvars;
         _r2 = cats('v', put(_k,z&_f..), _x[_k]); output;
      end;
   end;
run;

proc freq data=_r2;
   tables _r1 *_r2 / noprint sparse out=_c2(drop=p:);
run;

proc transpose data=_c2 out=_t1(drop=_n: _l:);
   by _r1;
   var count;
   id _r2;
   idlabel _r2;
run;

proc transpose data=_t1 out=_t2(drop=_n:);
   var _numeric_;
   id _r1;
   idlabel _r1;
run;

data _t2(drop=_j);
   length _label_ $ &_lablen;
   set _t2 end=_eof;
   array _x[*] _numeric_;
   do _j = _n_ + 1 to dim(_x); _x[_j] = .; end;
   if _n_ eq 1 then call execute('%nrstr(%%)macro _lab;');
   call execute(catx(' ', 'label', vname(_x[_n_]), '=',
                     quote(trim(substr(_label_, &_f+2))), ';'));
   if _eof then call execute('%nrstr(%%)mend;');
run;

data &out(drop=_label_);
   label Label=' ';
   update _t1(rename=(_r1=_label_)) _t2;
   by _label_;
   Label = substr(_label_, &_f+2);
   %_lab
run;

proc datasets nolist;
   delete _cont _r2(memtype=view) _t1 _t2 _c2;
quit;

options &_opt;
%let _t = %sysfunc(round(%sysevalf((%sysfunc(time()) - &_t)/60), 0.1));
%put Burt macro time=&_t minutes.;
%mend;

%macro check(data=, vars=);
options varlenchk=nowarn nosource nonotes;
ods select none;

%let t1 = %sysfunc(time());
proc corresp mca data=&data short obs outc=c1;
   ods output burt=burt2;
   tables &vars;
run;
%let t1 = %sysfunc(round(%sysevalf((%sysfunc(time()) - &t1)/60), 0.1));
%put PROC CORRESP time=&t1 minutes.;
ods select all;

proc contents data=burt noprint
   out=_cont(keep=name varnum rename=(name=_n) where=(_n ne 'Label'));
run;

proc sort data=_cont out=_cont(drop=varnum); by varnum; run;

data _null_;
   merge _cont burt2 end=_eof;
   array _x[*] _numeric_;
   if _n_ eq 1 then call execute('%nrstr(%%)macro ren;');
   _l = vname(_x[_n_]);
   call execute(catx(' ', 'label', _l, '=', quote(trim(label)), ';'));
   call execute(catx(' ', 'rename', _l, '=', _n, ';'));
   if _eof then call execute('%nrstr(%%)mend;');
run;

data burt2;
   length label $ &_lablen;
   set burt2;
   array _x[*] _numeric_;
   format _numeric_;
   %ren
run;

proc corresp data=burt mca nvar=&_nvars noprint outc=c2;
   var _numeric_;
run;

data c1;
   length _NAME_ $ &_lablen;
   set c1;
run;

data c2;
   length _NAME_ $ &_lablen;
   set c2;
run;
options varlenchk=warn source notes;

proc compare error note nosummary data=burt compare=burt2;
run;

proc compare error note nosummary data=c1 compare=c2 method=relative(1);
run;
%mend;

%let v = DeathCause Sex Chol_Status BP_Status Weight_Status Smoking_Status;
%burt(data=sashelp.heart, vars=&v)
%check(data=sashelp.heart, vars=&v)

proc corresp data=burt short obs mca nvars=&_nvars;
   var _numeric_;
run;

%let nvars = 50;
data x1(drop=i j a);
   a = catx(' ', '1 2 3 4 5 6 7 8 9 0 abcd fgh jkl nop rst',
            'vwx zAB DEF HIJ LMN PQR TUV XYZ');
   length x1-x&nvars $ 36;
   array x[&nvars] $;
   do i = 1 to 1e5;
      do j = 1 to &nvars;
         x[j] = catx(' ', 'v', put(j, 2.),
                     substr(a, ceil(uniform(7) * (mod(j, 20) + 2))));
      end;
   output;
   end;
run;

%burt(data=x1, vars=x:)
%check(data=x1, vars=x:)

%let nvars = 10;
data x1(drop=i j);
   array x[&nvars];
   length x: 3;
   do i = 1 to 1e5;
      do j = 1 to &nvars;
         x[j] = ceil(uniform(7) * 3);
      end;
   output;
   end;
run;

proc format;
   value yn 1='Yes' 2='No' 3='Maybe';
run;

data z(drop=x:) / view=z;
   set x1;
   a = put(x1 , yn5.);
   b = put(x2 , yn5.);
   c = put(x3 , yn5.);
   d = put(x4 , yn5.);
   e = put(x5 , yn5.);
   f = put(x6 , yn5.);
   g = put(x7 , yn5.);
   h = put(x8 , yn5.);
   i = put(x9 , yn5.);
   j = put(x10, yn5.);
   length k $ 1;
   k = cats(mod(_n_, 5));
run;

%burt(data=z, vars=a b c d e f g h i j k)

%check(data=z, vars=a b c d e f g h i j k)

%burt(data=z, vars=a k b d c e g f h j i)

%check(data=z, vars=a k b d c e g f h j i)

