/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: hplogex4                                            */
/*   TITLE: Example 4 for PROC HPLOGISTIC                       */
/*    DESC: Partitioning Data                                   */
/* PRODUCT: VIYA Statistics                                     */
/*  SYSTEM: ALL                                                 */
/*    KEYS: logistic regression analysis,                       */
/*          binary response data                                */
/*   PROCS: HPLOGISTIC                                          */
/*    DATA: Junk Email data set                                 */
/*                                                              */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/*****************************************************************
Example 4: Partitioning Data
*****************************************************************/

/*
The Sashelp.JunkMail data set comes from a study that classifies
whether an email is junk email (coded as 1) or not (coded as 0).
The data were collected by Hewlett-Packard Labs and donated by
George Forman. The data set, which is specified in the following
program, contains 4,601 observations, with 2 binary variables and
57 continuous explanatory variables. The response variable, Class,
is a binary indicator of whether an email is considered spam or
not. The partitioning variable, Test, is a binary indicator that is
used to divide the data into training and testing sets.  The 57
explanatory variables are continuous variables that represent
frequencies of some common words and characters and lengths of
uninterrupted sequences of capital letters in emails.
*/

title 'Example 4: Partitioning Data';


/*
In the following program, the PARTITION statement divides the data
into two parts.  The training data have a \Variable{Test} value of 0
and contain about two-thirds of the data; the rest of the data are
used to evaluate the fit.  A forward selection method selects the best
model based on the training observations.
*/

proc hplogistic data=Sashelp.JunkMail;
   model Class(event='1')=Make Address All _3d Our Over Remove Internet Order
         Mail Receive Will People Report Addresses Free Business Email You
         Credit Your Font _000 Money HP HPL George _650 Lab Labs Telnet _857
         Data _415 _85 Technology _1999 Parts PM Direct CS Meeting Original
         Project RE Edu Table Conference Semicolon Paren Bracket Exclamation
         Dollar Pound CapAvg CapLong CapTotal;
   partition rolevar=Test(train='0' test='1');
   selection method=forward;
run;


/*
The following program displays the Partition Fit Statistics table
without partitioning your data set by identifying all of your data
as training data.
*/

data JunkMail;
   set Sashelp.JunkMail;
   Role=0;
run;
proc hplogistic data=JunkMail;
   model Class(event='1')= Our Over Remove Internet Order Will
         Free Business You Your Font _000 Money HP George Parts
         Meeting RE Edu Semicolon Exclamation Dollar CapAvg
         CapLong;
   partition role=Role(train='0');
run;

