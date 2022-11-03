/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: SURFEX1                                             */
/*   TITLE: Documentation Example 1 for PROC SURVEYFREQ         */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: survey sampling, categorical data analysis,         */
/*    KEYS: stratification, clustering, unequal weighting,      */
/*    KEYS: crosstabulation tables, Wald chi-square test        */
/*   PROCS: SURVEYFREQ                                          */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC SURVEYFREQ, Example 1                          */
/*    MISC:                                                     */
/****************************************************************/
/* Generate Data -----------------------------------------------*/
proc format;
   value ResponseCode
      1 = 'Very Unsatisfied'
      2 = 'Unsatisfied'
      3 = 'Neutral'
      4 = 'Satisfied'
      5 = 'Very Satisfied';
run;

proc format;
   value UserCode
      1 = 'New Customer'
      0 = 'Renewal Customer';
run;

proc format;
   value SchoolCode
      1 = 'Middle School'
      2 = 'High School';
run;

proc format;
   value DeptCode
      0 = 'Faculty'
      1 = 'Admin/Guidance';
run;
data SIS_Survey;
   format Response ResponseCode.;
   format NewUser UserCode.;
   format SchoolType SchoolCode.;
   format Department DeptCode.;
   drop j;
   retain seed1 111;
   retain seed2 222;
   retain seed3 333;
   State = 'GA';
   NewUser = 1;
   do School=1 to 71;
      call rantbl( seed1, .45, .55, SchoolType );
      Department = 0;
      call rannor( seed3, x );
      SamplingWeight = 25 + x * 2;
      do j=1 to 2;
         if ( SchoolType = 1 ) then
            call rantbl( seed2, .16, .21, .30, .24, .09, Response);
         else
            call rantbl( seed2, .18, .23, .30, .22, .07, Response);
         output;
      end;
      output;
      Department = 1;
      call rannor( seed3, x );
      SamplingWeight = 15 + x * 1.5;
      do j=1 to 2;
         if ( SchoolType = 1 ) then
            call rantbl( seed2, .10, .15, .33, .28, .14, Response );
         else
            call rantbl( seed2, .13, .20, .30, .26, .11, Response);
         output;
      end;
   end;
   NewUser = 0;
   do School=72 to 134;
      call rantbl( seed1, .45, .55, SchoolType );
      Department = 0;
      call rannor( seed3, x );
      SamplingWeight = 25 + x * 2;
      do j=1 to 2;
         if ( SchoolType = 1 ) then
            call rantbl( seed2, .16, .21, .30, .24, .09, Response);
         else
            call rantbl( seed2, .18, .23, .30, .22, .07, Response);
         output;
      end;
      output;
      Department = 1;
      call rannor( seed3, x );
      SamplingWeight = 15 + x * 1.5;
      do j=1 to 2;
         if ( SchoolType = 1 ) then
            call rantbl( seed2, .10, .15, .33, .28, .14, Response );
         else
            call rantbl( seed2, .13, .20, .30, .26, .11, Response);
         output;
      end;
   end;
   State = 'NC';
   NewUser = 1;
   do School = 135 to 218;
      call rantbl( seed1, .45, .55, SchoolType );
      Department = 0;
      call rannor( seed3, x );
      SamplingWeight = 25 + x * 2;
      if ( SchoolType = 1 ) then
         call rantbl( seed2, .16, .21, .30, .24, .09, Response);
      else
         call rantbl( seed2, .18, .23, .30, .22, .07, Response);
      output;
      output;
      output;
      Department = 1;
      call rannor( seed3, x );
      SamplingWeight = 15 + x * 1.5;
      if ( SchoolType = 1 ) then
         call rantbl( seed2, .10, .15, .33, .28, .14, Response );
      else
         call rantbl( seed2, .13, .20, .30, .26, .11, Response);
      output;
      output;
   end;
   NewUser = 0;
   do School = 219 to 274;
      call rantbl( seed1, .45, .55, SchoolType );
      Department = 0;
      call rannor( seed3, x );
      SamplingWeight = 25 + x * 2;
      do j=1 to 2;
         if ( SchoolType = 1 ) then
            call rantbl( seed2, .16, .21, .30, .24, .09, Response);
         else
            call rantbl( seed2, .18, .23, .30, .22, .07, Response);
         output;
      end;
      output;
      Department = 1;
      call rannor( seed3, x );
      SamplingWeight = 15 + x * 1.5;
      if ( SchoolType = 1 ) then
         call rantbl( seed2, .10, .15, .33, .28, .14, Response );
      else
         call rantbl( seed2, .13, .20, .30, .26, .11, Response);
      output;
      output;
   end;
   State = 'SC';
   NewUser = 1;
   do School = 275 to 328;
      call rantbl( seed1, .45, .55, SchoolType );
      Department = 0;
      call rannor( seed3, x );
      SamplingWeight = 25 + x * 2;
      do j=1 to 2;
         if ( SchoolType = 1 ) then
            call rantbl( seed2, .16, .21, .30, .24, .09, Response);
         else
            call rantbl( seed2, .18, .23, .30, .22, .07, Response);
         output;
      end;
      output;
      Department = 1;
      call rannor( seed3, x );
      SamplingWeight = 15 + x * 1.5;
      if ( SchoolType = 1 ) then
         call rantbl( seed2, .10, .15, .33, .28, .14, Response );
      else
         call rantbl( seed2, .13, .20, .30, .26, .11, Response);
      output;
      output;
   end;
   NewUser = 0;
   do School = 329 to 370;
      call rantbl( seed1, .45, .55, SchoolType );
      Department = 0;
      call rannor( seed3, x );
      SamplingWeight = 25 + x * 2;
      do j=1 to 2;
         if ( SchoolType = 1 ) then
            call rantbl( seed2, .16, .21, .30, .24, .09, Response);
         else
            call rantbl( seed2, .18, .23, .30, .22, .07, Response);
         output;
      end;
      output;
      Department = 1;
      call rannor( seed3, x );
      SamplingWeight = 15 + x * 1.5;
      if ( SchoolType = 1 ) then
         call rantbl( seed2, .10, .15, .33, .28, .14, Response );
      else
         call rantbl( seed2, .13, .20, .30, .26, .11, Response);
      output;
      output;
   end;
run;
/* Two-Way Table
      Stratum Information Table
      CVs and Design Effects    --------------------------------*/
title 'Student Information System Survey';
proc surveyfreq data=SIS_Survey;
   tables  Department * Response / cv deff nowt nostd nototal;
   strata  State NewUser / list;
   cluster School;
   weight  SamplingWeight;
run;
/* Two-Way Table
      Row Percentages
      Wald Chi-Square Test -------------------------------------*/
proc surveyfreq data=SIS_Survey nosummary;
   tables  Department * Response / row nowt wchisq;
   strata  State NewUser;
   cluster School;
   weight  SamplingWeight;
run;
