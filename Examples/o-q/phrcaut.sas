/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: PHRCAUT                                             */
/*   TITLE: Caution about using survival data with left         */
/*          truncation                                          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: product-limit estimator, left-truncated data        */
/*   PROCS: PHREG                                               */
/*    DATA: Channing data in Klein and Moeschberger (2003)      */
/*     REF: SAS/STAT User's Guide, PROC PHREG Chapter           */
/*    MISC:                                                     */
/****************************************************************/

data Channing;
   input Gender$ Age_entry Age_exit Death @@;
   datalines;
Female  1042 1172  1  Female   921 1040  1  Female   885 1003  1
Female   901 1018  1  Female   808  932  1  Female   915 1004  1
Female   901 1023  1  Female   852  908  1  Female   828  868  1
Female   968  990  1  Female   936 1033  1  Female   977 1056  1
Female   929  999  1  Female   936 1064  1  Female  1016 1122  1
Female   910 1020  1  Female  1140 1200  1  Female  1015 1056  1
Female   850  940  1  Female   895  996  1  Female   854  969  1
Female   957 1089  1  Female  1013 1115  1  Female  1073 1192  1
Female   976 1085  1  Female   872  976  1  Female  1027 1142  1
Female  1071 1200  1  Female   919 1017  1  Female   894 1006  1
Female   885 1012  1  Female   889 1000  1  Female   887 1012  1
Female   920 1040  1  Female  1015 1024  1  Female   942 1070  1
Female   924 1014  1  Female   883  996  1  Female   930  944  1
Female   956 1085  1  Female   886  994  1  Female   987 1097  1
Female   883  966  1  Female   837  948  1  Female   958 1029  1
Female   850  963  1  Female   890  905  1  Female   847  970  1
Female   919 1015  1  Female   748  804  1  Female   934 1041  1
Female   895  991  1  Female   874  982  1  Female   877  989  1
Female   900  959  1  Female   957 1084  1  Female  1013 1131  1
Female   967 1068  1  Female   904  919  0  Female   829  848  0
Female   842  979  0  Female   802  876  0  Female   840  938  0
Female   792  929  0  Female   837  848  0  Female   941 1006  0
Female   746  804  0  Female   834  932  0  Female   865  932  0
Female   828  965  0  Female   894 1011  0  Female   874 1011  0
Female   917 1054  0  Female   993 1028  0  Female   918 1055  0
Female   818  955  0  Female   984 1019  0  Female  1002 1010  0
Female   857  994  0  Female   827  836  0  Female   883 1020  0
Female  1008 1042  0  Female   954 1091  0  Female   905 1042  0
Female   838  975  0  Female   934  946  0  Female   872  940  0
Female   918  922  0  Female   844  981  0  Female   805  928  0
Female   922 1059  0  Female   821  958  0  Female   838  975  0
Female   934  961  0  Female   886 1023  0  Female   934 1023  0
Female   878 1010  0  Female   935 1072  0  Female   799  825  0
Female   849  952  0  Female   920  953  0  Female   948  998  1
Female   968 1105  0  Female   908  996  0  Female   828  965  0
Female   897 1034  0  Female   823  938  0  Female   950 1008  0
Female  1049 1186  0  Female   878 1015  0  Female   854  991  0
Female   877 1014  0  Female   820  955  0  Female   899 1036  0
Female   855  893  0  Female   827  964  0  Female   925  960  0
Female   900 1037  0  Female   935  948  0  Female  1005 1053  0
Female   855  992  0  Female   920  992  0  Female   810  895  0
Female   792  857  0  Female   882 1019  0  Female   934 1071  0
Female   910 1047  0  Female   865  973  0  Female   899 1036  0
Female   982 1119  0  Female   856  993  0  Female   961  963  0
Female   893 1030  0  Female   861  998  0  Female   829  932  0
Female   882 1019  0  Female   875 1012  0  Female   833  970  0
Female   972 1013  0  Female   807  944  0  Female   924  959  0
Female   845  982  0  Female   840  977  0  Female   867 1004  0
Female   881  913  0  Female   901  917  0  Female   944  947  0
Female   821  824  0  Female   811  898  0  Female  1007 1014  0
Female   912 1049  0  Female   802  939  0  Female   928 1065  0
Female   911  938  0  Female   847  899  0  Female  1035 1172  0
Female   893  973  0  Female   922  971  0  Female   977  985  0
Female   941  944  0  Female   869 1006  0  Female   885  955  0
Female   859  996  0  Female   948 1085  0  Female   890 1005  0
Female   887  891  0  Female   968 1105  0  Female   927  989  0
Female   997 1134  0  Female   846  983  0  Female   831  861  0
Female   842  979  0  Female   768  905  0  Female   896 1033  0
Female   894 1014  0  Female   885 1022  0  Female   822  959  0
Female   927  954  0  Female   897  904  0  Female   848  985  0
Female   912 1001  0  Female   863 1000  0  Female   813  950  0
Female   802  939  0  Female   956 1061  0  Female   822  945  0
Female   934  993  0  Female  1026 1054  0  Female   981 1114  0
Female   934 1071  0  Female   836  927  0  Female   760  897  0
Female   820  957  0  Female   907 1044  0  Female   979 1016  0
Female   894 1031  0  Female   852  989  0  Female   948  971  0
Female   813  950  0  Female   902 1024  0  Female   913 1050  0
Female   810  812  0  Female   841  978  0  Female   875 1012  0
Female   841  927  0  Female   948 1012  0  Female   859  995  1
Female   820  957  0  Female   860  997  0  Female   917  948  0
Female   936 1073  0  Female   950  986  0  Female  1013 1031  0
Female   847  984  0  Female   777  914  0  Female   960  988  0
Female   920 1057  0  Female   935 1051  0  Female   933  979  0
Female   933  985  0  Female   797  934  0  Female   733  870  0
Female   866  953  0  Female   870  930  0  Female   795  875  0
Female   905 1005  1  Female   796  891  0  Female   965 1102  0
Female   775  912  0  Female   942  977  0  Female   895  926  0
Female   981 1038  0  Female   991 1006  0  Female   894  918  0
Female   886  943  0  Female   871  924  0  Female   839  976  0
Female   839  976  0  Female   858  995  0  Female   830  967  0
Female   868 1005  0  Female   831  925  0  Female   783  888  0
Female   925 1062  0  Female   898 1035  0  Female   910 1009  0
Female   958 1008  0  Female   866 1003  0  Female   851  988  0
Female   906 1043  0  Female   882 1019  0  Female   815  952  0
Female   972 1083  1  Female   973  985  0  Female   957  957  0
Female  1010 1147  0  Female  1070 1207  0  Female   895 1032  0
Female   818  860  0  Female   864 1001  0  Female   857  994  0
Female  1028 1063  0  Female   892 1029  0  Female   769  906  0
Female   883 1020  0  Female   972 1109  0  Female   965 1088  0
Female   925  961  0  Female   814  872  0  Female   805  942  0
Female   992 1010  0  Female   943 1080  0  Female   951  958  0
Female   926  987  0  Female   954  962  0  Female   944  944  0
Female   935  935  0  Female   900  912  0  Female   762  854  0
Female   823  882  0  Female   978 1010  1  Female   966 1027  1
Female   912  916  0  Female   823  829  0  Female   909  933  0
Female   967 1041  1  Female   851  905  1  Female   843  861  1
Female   963 1021  1  Female   888  919  1  Female   794  798  0
Female   905  928  1  Female  1039 1086  1  Female   901  923  1
Female   823  830  1  Female   809  822  1  Female   887  905  0
Female   859  926  1  Female  1004 1015  0  Female   919  931  1
Female   958 1041  1  Female  1003 1093  1  Female   871  944  1
Female   864  873  1  Female   996 1073  1  Female  1034 1068  1
Female   873  897  1  Female   984 1047  1  Female   943 1011  1
Female  1007 1019  1  Female   935 1006  1  Female   929  996  1
Female   939  978  1  Female   772  840  1  Female   871  912  0
Female   873  954  1  Female   981 1018  1  Female   894  927  0
Female   994 1040  1  Female   976  995  1  Female   847  883  1
Female   859  941  1  Female   933  990  1  Female   861  934  1
Female   886  908  1  Female   943  986  1  Female   931  969  1
Female   948 1019  1  Female   955  992  1  Female  1004 1023  1
Female   828  895  1  Female   835  845  1  Female   868  870  0
Female   988 1074  1  Female   861  930  1  Female   959  976  0
Female   959  912  1  Female   871  874  0  Female   847  892  0
Female   874  885  1  Female   992 1044  1  Female  1027 1072  1
Female   857  901  1  Female   994 1013  1  Female  1041 1043  1
Female   900  926  0  Female  1096 1152  1  Female   930  936  1
Female   943  994  1  Female  1024 1063  1  Female   802  821  0
Female   811  819  0  Female   927 1001  1  Female   967  975  1
Female   943  982  1  Female   840  905  0  Female   979 1040  1
Female   921  926  0  Female   986 1030  1  Female  1039 1132  1
Female   968  990  1  Female   955  990  1  Female   837  911  1
Female   861  915  1  Female   967  983  1    Male   782  909  1
  Male  1020 1128  1    Male   856  969  1    Male   915  957  1
  Male   863  983  1    Male   906 1012  1    Male   955 1055  1
  Male   943 1025  1    Male   943 1043  1    Male   837  945  1
  Male   966 1009  1    Male   936  971  1    Male   919 1033  1
  Male   852  869  1    Male  1073 1139  1    Male   925 1036  1
  Male   967 1085  1    Male   806  943  0    Male   969 1001  0
  Male   923 1060  0    Male   865 1002  0    Male   953 1031  0
  Male   871  945  0    Male   982 1006  0    Male   883  959  0
  Male   817  843  0    Male   875 1012  0    Male   821  956  0
  Male   936 1073  0    Male   971 1107  0    Male   830  940  0
  Male   885  911  0    Male   894 1031  0    Male   893  996  0
  Male   866  895  0    Male   878 1015  0    Male   820  957  0
  Male  1007 1043  0    Male   879 1016  0    Male   956 1093  0
  Male   854  989  1    Male   890 1027  0    Male  1041 1044  0
  Male   978 1005  0    Male   836  973  0    Male   938 1064  0
  Male   886 1023  0    Male   876 1013  0    Male   955  977  0
  Male   823  960  0    Male   960 1047  0    Male   843  943  0
  Male   856  951  0    Male   847  984  0    Male  1027 1058  0
  Male   988 1045  0    Male   953  953  0    Male   978 1018  0
  Male   981 1118  0    Male   926  970  0    Male  1036 1070  0
  Male  1016 1153  0    Male   969 1106  0    Male   900  936  0
  Male   898  906  0    Male   846  866  0    Male   964 1029  1
  Male   984 1053  1    Male  1046 1080  1    Male   871  872  1
  Male   847  893  1    Male   962  966  0    Male   853  894  1
  Male   967  985  1    Male  1063 1094  1    Male   856  927  1
  Male   865  948  1    Male  1051 1059  1    Male  1010 1012  1
  Male   878  911  1    Male  1021 1094  1    Male   959  972  0
  Male   921  993  1    Male   836  876  1    Male   919  993  1
  Male   751  777  1    Male   906  966  1    Male   835  907  1
  Male   946 1031  1    Male   759  781  1    Male   909  914  0
  Male   962  998  1    Male   984 1022  1    Male   891  932  1
  Male   835  898  1    Male  1039 1060  1    Male  1010 1044  1
;

ods graphics on;
proc phreg data=Channing plots(overlay=row)=survival atrisk;
   model Age_exit*Death(0)= /entrytime=Age_entry;
   strata Gender;
   baseline out=Outs survival=Probability / method=pl;
   ods output RiskSetInfo=Atrisk;
run;

data Outs;
   set Outs;
   if Gender="Female" then StratumNumber=1;
   else                    StratumNumber=2;
run;
data Outs;
   merge atrisk outs;
   by StratumNumber Age_exit;
run;

proc print data=Outs;
   id Gender;
   var Age_exit Atrisk Event Probability;
run;
