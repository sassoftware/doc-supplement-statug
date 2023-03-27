/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: hpregex4                                            */
/*   TITLE: Example 4 for PROC HPREG                            */
/*    DESC: Simulated Data                                      */
/*                                                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: SCREEN option, FORWARD  selection                   */
/*   PROCS: HPREG                                               */
/*                                                              */
/****************************************************************/

  %let nObs      = 50000;
  %let nContIn   = 25;
  %let nContOut  = 500;
  %let nClassIn  = 5;
  %let nClassOut = 500;
  %let maxLevs   = 5;
  %let noiseScale= 1;

   data ex4Data;
     array xIn{&nContIn};
     array xOut{&nContOut};
     array cIn{&nClassIn};
     array cOut{&nClassOut};

     drop i j sign nLevs xBeta;

     do i=1 to &nObs;
        sign  = -1;
        xBeta = 0;
        do j=1 to dim(xIn);
           xIn{j} = ranuni(1);
           xBeta  = xBeta + j*sign*xIn{j};
           sign   = -sign;
        end;
        do j=1 to dim(xOut);
           xOut{j} = ranuni(1);
        end;

        xWeakIn1 = ranuni(1);
        xWeakin2 = ranuni(1);

        xBeta  = xBeta + 0.1*xWeakIn1+ 0.1*xWeakIn2;

        do j=1 to dim(cIn);
           nLevs  = 2 + mod(j,&maxlevs-1);
           cIn{j} = 1+int(ranuni(1)*nLevs);
           xBeta  = xBeta + j*sign*(cIn{j}-nLevs/2);
           sign   = -sign;
        end;

        do j=1 to dim(cOut);
           nLevs  = 2 + mod(j,&maxlevs-1);
           cOut{j} = 1+int(ranuni(1)*nLevs);
        end;

        y = xBeta + &noiseScale*rannor(1);

        output;
    end;
  run;


 proc hpreg data=ex4Data;
     class c: ;
     model y = x: c: ;
     selection method=forward screen(details=all)=100 20;
     performance details;
 run;


 proc hpreg data=ex4Data;
     class c: ;
     model y = x: c: ;
     selection method=forward screen(details=all)=100 20;
  ods output screenedfit.screening = iscreening
             residualfit.screening=rscreening;
     performance details;
 run;

%startprint(ex4_iscreening);
 data _null_;
    set work.iscreening(where=(rank<6 or rank>97));
    if rank=4 or rank=5 then do;
        rank = .;
        effect = '  . ';
        correlation=.;
    end;
    file print ods=(template='HPSTAT.HPREG.Screening');
    put _ods_;
 run;
%endprint;


 proc hpreg data=ex4Data;
     class c: ;
     model y = x: c: ;
     selection method=forward;
     performance details;
 run;

