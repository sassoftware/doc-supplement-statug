/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: HPSPLEX1                                            */
/*   TITLE: Documentation Example 1 for PROC HPSPLIT            */
/*                                                              */
/* PRODUCT: HPSTAT                                              */
/*  SYSTEM: ALL                                                 */
/*    KEYS: cost-complexity pruning                             */
/*   PROCS: HPSPLIT                                             */
/*                                                              */
/****************************************************************/

proc print data=sampsio.LAQ(obs=5);
   var LobaOreg MinMinTemp Aconif PrecipAve Elevation ReserveStatus;
run;

ods graphics on;

proc hpsplit data=sampsio.LAQ seed=123;
   class LobaOreg ReserveStatus;
   model LobaOreg (event='1') =
      Aconif DegreeDays TransAspect Slope Elevation PctBroadLeafCov
      PctConifCov PctVegCov TreeBiomass EvapoTransAve EvapoTransDiff
      MoistIndexAve MoistIndexDiff PrecipAve PrecipDiff RelHumidAve
      RelHumidDiff PotGlobRadAve PotGlobRadDiff AveTempAve AveTempDiff
      DayTempAve DayTempDiff MinMinTemp MaxMaxTemp AmbVapPressAve
      AmbVapPressDiff SatVapPressAve SatVapPressDiff ReserveStatus;
   grow entropy;
   prune costcomplexity;
run;

proc hpsplit data=sampsio.LAQ cvmodelfit seed=123;
   class LobaOreg ReserveStatus;
   model LobaOreg (event='1') =
      Aconif DegreeDays TransAspect Slope Elevation PctBroadLeafCov
      PctConifCov PctVegCov TreeBiomass EvapoTransAve EvapoTransDiff
      MoistIndexAve MoistIndexDiff PrecipAve PrecipDiff RelHumidAve
      RelHumidDiff PotGlobRadAve PotGlobRadDiff AveTempAve AveTempDiff
      DayTempAve DayTempDiff MinMinTemp MaxMaxTemp AmbVapPressAve
      AmbVapPressDiff SatVapPressAve SatVapPressDiff ReserveStatus;
   grow entropy;
   prune costcomplexity(leaves=6);
   * Delete this comment and modify the file name as needed to run:
   code file='trescore.sas';
run;

proc hpsplit data=sampsio.LAQ cvmodelfit seed=123
   plots=zoomedtree(nodes=('4') depth=4);
   class LobaOreg ReserveStatus;
   model LobaOreg (event='1') =
      Aconif DegreeDays TransAspect Slope Elevation PctBroadLeafCov
      PctConifCov PctVegCov TreeBiomass EvapoTransAve EvapoTransDiff
      MoistIndexAve MoistIndexDiff PrecipAve PrecipDiff RelHumidAve
      RelHumidDiff PotGlobRadAve PotGlobRadDiff AveTempAve AveTempDiff
      DayTempAve DayTempDiff MinMinTemp MaxMaxTemp AmbVapPressAve
      AmbVapPressDiff SatVapPressAve SatVapPressDiff ReserveStatus;
   grow entropy;
   prune costcomplexity(leaves=6);
   * Delete this comment and modify the file name as needed to run:
   code file='trescore.sas';
run;

/* Uncomment and modify the file name as needed to run:
data lichenpred(keep=Actual Predicted);
   set sampsio.PRG end=eof;
   %include "trescore.sas";
   Actual    = LobaOreg;
   Predicted = (P_LobaOreg1 >= 0.5);
run;

title "Confusion Matrix Based on Cutoff Value of 0.5";
proc freq data=lichenpred;
   tables Actual*Predicted / norow nocol nopct;
run;

data lichenpred(keep=Actual Predicted);
   set sampsio.PRG end=eof;
   %include "trescore.sas";
   Actual    = LobaOreg;
   Predicted = (P_LobaOreg1 >= 0.1);
run;

title "Confusion Matrix Based on Cutoff Value of 0.1";
proc freq data=lichenpred;
   tables Actual*Predicted / norow nocol nopct;
run;
*/

