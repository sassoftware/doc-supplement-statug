/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: HPMEX4                                              */
/*   TITLE: Example 4 for PROC HPMIXED                          */
/*          Mixed Model Analysis of Microarray Data             */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Microarray Data                                     */
/*          Mixed Model Analysis                                */
/*          Genome                                              */
/*   PROCS: HPMIXED                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC HPMIXED, EXAMPLE 4.                            */
/*    MISC:                                                     */
/****************************************************************/

%let narray  = 6;
%let ndye    = 2;
%let nrow    = 4;
%let ngene   = 500;
%let ntrt    = 6;
%let npin    = 4;
%let ndip    = 4;
%let no      = %eval(&ndye*&nrow*&ngene);
%let tno     = %eval(&narray*&no);

data microarray;
   keep Gene MArray Dye Trt Pin Dip log2i;
   array PinDist{&tno};
   array DipDist{&tno};
   array GeneDist{&tno};

   array ArrayEffect{&narray};
   array ArrayGeneEffect{%eval(&narray*&ngene)};
   array ArrayDipEffect{%eval(&narray*&ndip)};
   array ArrayPinEffect{%eval(&narray*&npin)};

   do i = 1 to &tno;
      PinDist{i}  = 1 + int(&npin*ranuni(12345));
      DipDist{i}  = 1 + int(&ndip*ranuni(12345));
      GeneDist{i} = 1 + int(&ngene*ranuni(12345));
   end;

   igene = 0;
   idip = 0;
   ipin = 0;
   do i = 1 to &narray;
      ArrayEffect{i} = sqrt(0.014)*rannor(12345);
      do j = 1 to &ngene;
         igene = igene+1;
         ArrayGeneEffect{igene} = sqrt(0.0017)*rannor(12345);
      end;
      do j = 1 to &ndip;
         idip = idip + 1;
         ArrayDipEffect{idip} = sqrt(0.0033)*rannor(12345);
      end;
      do j = 1 to &npin;
         ipin = ipin + 1;
         ArrayPinEffect{ipin} = sqrt(0.037)*rannor(12345);
      end;
   end;

   i = 0;
   do MArray = 1 to &narray;
      do Dye = 1 to &ndye;
         do Row = 1 to &nrow;
            do k = 1 to &ngene;
               if MArray=1 and Dye = 1 then do;
                  Trt = 0;
                  trtc = 0;
               end;
               else do;
                  if trtc >= &no then trtc = 0;
                  if trtc = 0 then do;
                     Trt = Trt + 1;
                     if Trt >= &ntrt then do;
                        Trt = 0;
                        trtc = 0;
                     end;
                  end;
                  trtc = trtc + 1;
               end;
               i = i + 1;
               Pin = PinDist{i};
               Dip = DipDist{i};
               Gene = GeneDist{i};
               a   = ArrayEffect{MArray};
               ag  = ArrayGeneEffect{(MArray-1)*&ngene+Gene};
               ad  = ArrayDipEffect{(MArray-1)*&ndip+Dip};
               ap  = ArrayPinEffect{(MArray-1)*&npin+Pin};
               log2i   = 1 +
                        + Dye
                        + Trt
                        + Gene/1000.0
                        + Dye*Gene/1000.0
                        + Trt*Gene/1000.0
                        + Pin
                        + a
                        + ag
                        + ad
                        + ap
                        + sqrt(0.02)*rannor(12345);
               output;
            end;
         end;
      end;
   end;
run;

proc hpmixed data=microarray;
   class marray dye trt gene pin dip;
   model log2i = dye trt gene dye*gene trt*gene pin;
   random marray marray*gene dip(marray) pin*marray;
   test trt;
run;

