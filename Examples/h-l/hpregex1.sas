/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: hpregex1                                            */
/*   TITLE: Example 1 for PROC HPREG                            */
/*    DESC: Simulated Data                                      */
/*                                                              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Model Selection, Validation                         */
/*   PROCS: HPREG                                               */
/*                                                              */
/****************************************************************/


 data analysisData;
    drop i j c3Num;
    length c3$ 7;

    array x{20} x1-x20;

    do i=1 to 15000;
       do j=1 to 20;
          x{j} = ranuni(1);
       end;

       c1 = 1 + mod(i,8);
       c2 = ranbin(1,3,.6);

       if      i < 50   then do; c3 = 'tiny';     c3Num=1;end;
       else if i < 250  then do; c3 = 'small';    c3Num=1;end;
       else if i < 600  then do; c3 = 'average';  c3Num=2;end;
       else if i < 1200 then do; c3 = 'big';      c3Num=3;end;
       else                  do; c3 = 'huge';     c3Num=5;end;

       yTrue = 10 + x1 + 2*x5 + 3*x10 + 4*x20  + 3*x1*x7 + 8*x6*x7
                  + 5*(c1=3)*c3Num + 8*(c1=7);

       error = 5*rannor(1);

       y = yTrue + error;

            if mod(i,3)=1 then Role = 'TRAIN';
       else if mod(i,3)=2 then Role = 'VAL';
       else                    Role = 'TEST';

       output;
   end;
 run;


 proc summary data=analysisData;
    class role;
    ways 1;
    var error;
    output out=ASE uss=uss n=n;
 data ASE; set ASE;
    OracleASE = uss / n;
    label OracleASE = 'Oracle ASE';
    keep Role OracleASE;
 run;


 proc print data=ASE label noobs;
 run;

 proc hpreg data=analysisData;
    partition roleVar=role(train='TRAIN' validate='VAL' test='TEST');
    class c1 c2 c3(order=data);
    model y =  c1|c2|c3|x1|x2|x3|x4|x5|x5|x6|x7|x8|x9|x10
              |x11|x12|x13|x14|x15|x16|x17|x18|x19|x20 @2 /stb;
    selection method = stepwise(select=sl sle=0.1 sls=0.15 choose=validate)
                       hierarchy=single details=steps;
 run;

 proc hpreg data=analysisData;
    partition roleVar=role(train='TRAIN' validate='VAL' test='TEST');
    class c1 c2 c3(order=data);
    model y =  c1|c2|c3|x1|x2|x3|x4|x5|x5|x6|x7|x8|x9|x10
              |x11|x12|x13|x14|x15|x16|x17|x18|x19|x20 @2 /stb;
    selection method = stepwise(select=sl sle=0.1 sls=0.15 choose=validate)
                       hierarchy=single details=steps;
  ods output selectedModel.ParameterEstimates=ex1_ParameterEstimates;
 run;

%startprint(ex1_ParameterEstimates);
 data _NULL_;
     set work.ex1_ParameterEstimates(obs=9);
     file print ods=(template='HPSTAT.HPREG.ParameterEstimates');
     put _ods_;
 run;

 proc hpreg data=analysisData;
    partition roleVar=role(train='TRAIN' validate='VAL' test='TEST');
    class c1(split) c2 c3(order=data);
    model y =  c1|c2|c3|x1|x2|x3|x4|x5|x5|x6|x7|x8|x9|x10
              |x11|x12|x13|x14|x15|x16|x17|x18|x19|x20 @2 /stb;
    selection method = stepwise(select=sl sle=0.1 sls=0.15 choose=validate)
                       hierarchy=single details=steps;
 run;

