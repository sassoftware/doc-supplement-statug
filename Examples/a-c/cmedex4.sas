/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: cmedex4                                             */
/*   TITLE: Example 4 for PROC CAUSALMED                        */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Mediation Analysis by Structural Equation Modeling  */
/*   PROCS: CAUSALMED                                           */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC CAUSALMED, EXAMPLE 4                           */
/*    MISC:                                                     */
/****************************************************************/

data Cognitive;
   input  SubjectID FamSize  SocStatus  Encourage  Motivation  CogPerform;
   datalines;
  1      7       31          36           40          103
  2      3       27          36           40          103
  3      0       25          35           40           99
  4      6       29          36           40          103
  5      4       22          33           37           79
  6      2       23          34           38           87
  7      0       29          37           41          112
  8      4       23          34           38           87
  9      3       20          32           36           71
 10      3       28          36           40          103
 11      5       24          34           38           87
 12      1       25          35           39           95
 13      3       29          37           41          112
 14      2       31          38           42          120
 15      2       21          33           37           79
 16      3       30          37           41          112
 17      1       25          35           39           95
 18      2       21          33           37           79
 19      3       22          33           37           79
 20      3       26          35           39           95
 21      7       25          33           37           79
 22      4       31          38           41          116
 23      4       25          34           38           87
 24      5       22          33           37           79
 25      4       26          35           39           95
 26      6       24          33           37           79
 27      5       28          36           40          103
 28      6       20          32           36           71
 29      4       20          32           36           71
 30      3       21          33           37           79
 31      5       20          31           35           64
 32      3       27          36           40          103
 33      2       26          35           39           95
 34      7       24          33           37           79
 35      5       25          34           38           87
 36      4       25          34           38           87
 37      3       32          38           42          120
 38      4       23          33           37           79
 39      4       25          34           38           87
 40      7       29          35           39           95
 41      6       25          34           38           87
 42      5       24          33           37           79
 43      2       27          36           40          103
 44      3       26          35           39           95
 45      4       32          38           42          120
 46      5       31          37           41          111
 47      4       23          33           37           79
 48      2       29          37           41          112
 49      4       26          35           39           95
 50      3       26          35           39           95
 51      3       25          34           39           91
 52      6       27          35           39           95
 53      4       26          35           39           95
 54      2       25          35           39           95
 55      2       23          34           38           87
 56      7       23          33           37           79
 57      7       22          32           36           71
 58      4       26          35           39           95
 59      4       32          38           42          120
 60      3       20          32           36           71
 61      2       30          37           41          112
 62      4       32          38           42          120
 63      5       28          36           40          103
 64      0       28          37           41          112
 65      3       27          36           40          103
 66      5       15          29           33           49
 67      4       24          34           38           87
 68      6       21          32           36           71
 69      5       27          35           39           95
 70      3       14          29           33           49
 71      3       23          33           38           83
 72      6       26          34           38           87
 73      3       27          36           40          103
 74      3       29          36           41          107
 75      7       23          32           36           71
 76      3       27          35           40           99
 77      2       25          35           39           95
 78      5       32          38           42          120
 79      5       23          33           37           79
 80      2       30          37           42          116
 81      7       23          33           37           79
 82      5       25          34           38           87
 83      5       24          34           38           87
 84      5       27          35           39           95
 85      6       17          30           34           56
 86      2       30          37           41          112
 87      5       21          32           36           71
 88      5       27          35           39           95
 89      1       31          38           42          120
 90      3       22          33           37           79
 91      1       32          39           43          129
 92      3       26          35           39           95
 93      4       24          34           38           87
 94      5       21          32           36           71
 95      4       26          35           39           95
 96      4       24          34           38           87
 97      5       27          35           39           95
 98      4       26          35           39           95
 99      5       21          32           36           71
100      3       23          34           38           87
101      6       25          34           38           87
102      5       24          33           37           79
103      4       26          35           39           95
104      4       26          35           39           95
105      1       24          35           39           95
106      4       32          38           42          121
107      3       33          39           43          129
108      4       31          37           41          112
109      2       20          32           37           75
110      2       28          36           40          103
111      4       23          34           38           87
112      4       26          35           39           95
113      4       25          34           38           87
114      5       28          35           40           99
115      6       22          32           36           71
116      4       26          35           39           95
117      4       29          36           40          103
118      3       24          34           38           87
119      6       29          35           40           99
120      2       22          34           38           87
121      2       28          36           41          107
122      0       26          36           40          103
123      3       20          32           36           71
124      5       20          31           35           64
125      2       25          35           39           95
126      4       17          31           35           64
127      2       25          35           39           95
128      1       25          35           39           95
129      6       25          34           38           87
130      3       25          35           39           95
131      3       29          36           40          103
132      3       22          33           37           79
133      6       20          31           35           64
134      4       22          33           37           79
135      7       28          35           39           95
136      2       24          34           38           87
137      6       23          33           37           79
138      2       24          35           39           95
139      5       26          34           38           87
140      2       29          37           41          112
141      4       22          33           37           79
142      3       28          36           40          103
143      5       28          35           39           95
144      2       24          34           39           91
145      2       26          35           39           95
146      4       25          34           38           87
147      5       24          34           38           87
148      3       27          36           40          103
149      0       27          37           41          112
150      1       25          35           39           95
151      3       22          33           37           79
152      4       25          34           38           87
153      5       25          33           38           83
154      3       28          37           40          108
155      3       21          33           37           79
156      3       25          35           39           95
157      2       21          33           37           79
158      5       21          32           36           71
159      2       27          36           40          103
160      2       29          37           41          112
161      4       29          37           41          112
162      3       25          34           39           91
163      4       23          33           37           79
164      6       26          34           38           87
165      2       23          34           38           87
166      5       24          33           37           79
167      4       28          36           40          103
168      3       22          33           37           79
169      3       24          34           38           87
170      7       22          32           36           71
171      2       25          35           39           95
172      1       28          37           41          112
173      3       28          36           40          103
174      3       25          34           38           87
175      3       23          34           38           87
176      4       21          32           36           71
177      4       19          31           35           64
178      7       25          34           38           87
179      2       29          37           41          112
180      4       25          34           38           87
181      4       19          31           35           64
182      4       24          34           38           87
183      4       31          37           41          112
184      3       22          33           37           79
185      5       30          37           41          112
186      6       28          35           39           95
187      4       21          32           36           71
188      3       27          35           40           99
189      3       17          31           35           64
190      3       22          33           37           79
191      3       26          35           39           95
192      3       22          33           37           79
193      3       25          35           39           95
194      4       31          37           41          112
195      6       22          32           36           71
196      2       24          34           38           87
197      4       22          33           37           79
198      6       25          34           38           87
199      5       16          30           34           56
200      6       32          37           41          112
201      1       24          34           39           91
202      5       24          33           37           79
203      3       18          31           35           64
204      6       28          35           39           95
205      4       20          32           36           71
206      8       33          37           41          112
207      4       30          36           41          107
208      2       29          37           41          112
209      6       15          29           33           49
210      4       24          34           38           87
211      2       18          32           36           71
212      5       17          30           34           56
213      3       24          34           38           87
214      4       19          32           36           71
215      6       23          32           36           71
216      6       27          35           39           95
217      3       32          38           42          120
218      5       27          35           39           95
219      6       20          31           35           64
220      4       21          32           36           71
221      4       23          33           37           79
222      4       25          35           39           95
223      4       21          33           37           79
224      3       28          36           40          103
225      6       23          33           37           79
226      4       26          35           39           95
227      5       22          33           37           79
228      5       30          36           40          103
229      2       31          38           42          120
230      6       23          33           37           79
231      5       30          37           41          112
232      3       24          34           38           87
233      5       24          34           38           87
234      4       25          34           38           87
235      1       23          34           38           87
236      6       30          36           40          103
237      3       23          34           38           87
238      3       22          33           37           79
239      6       26          34           38           87
240      6       22          32           36           71
241      4       24          34           38           87
242      2       23          34           38           87
243      5       28          36           40          103
244      4       30          37           41          112
245      4       26          35           39           95
246      6       28          35           39           95
247      3       23          33           37           79
248      7       28          35           39           95
249      3       21          33           37           79
250      2       25          36           40          103
251      3       29          37           41          112
252      3       30          37           41          112
253      1       26          36           40          103
254      4       26          35           39           95
255      4       29          36           40          103
256      4       29          36           40          103
257      0       27          36           40          103
258      1       29          37           41          112
259      4       31          37           41          112
260      4       26          35           39           95
261      2       23          34           38           87
262      5       22          33           37           79
263      2       26          35           39           95
264      4       24          34           38           87
265      5       20          31           35           64
266      6       21          32           36           71
267      3       26          35           39           95
268      2       21          33           37           79
269      4       29          36           40          103
270      4       29          36           40          103
271      5       24          33           37           79
272      6       21          32           36           71
273      0       27          37           41          112
274      3       26          35           39           95
275      4       24          34           38           87
276      3       20          32           36           71
277      5       27          35           39           95
278      0       27          36           41          107
279      4       28          36           40          103
280      4       27          36           40          103
281      4       27          35           39           95
282      6       24          34           38           87
283      4       22          33           37           79
284      4       26          35           39           95
285      4       24          34           38           87
286      6       21          32           36           71
287      2       14          29           33           49
288      5       24          34           38           87
289      4       24          34           38           87
290      5       30          36           40          103
291      2       24          35           39           95
292      7       30          36           40          103
293      3       25          35           39           95
294      5       25          34           38           87
295      4       19          31           35           64
296      5       24          34           38           87
297      4       27          35           39           95
298      0       28          37           41          112
299      3       29          36           41          107
300      5       30          37           41          111
;

proc causalmed data=Cognitive;
   model    CogPerform  = Encourage Motivation;
   mediator Motivation  = Encourage;
run;

proc causalmed data=Cognitive;
   model    CogPerform  = Encourage Motivation;
   mediator Motivation  = Encourage;
   covar FamSize SocStatus;
run;

proc calis data=cognitive;
   path
      Encourage            ===> Motivation,
      Encourage Motivation ===> CogPerform;
   effpart  Encourage ===> CogPerform;
run;

proc calis data=cognitive;
   path
      Encourage            ===> Motivation,
      Encourage Motivation ===> CogPerform,
      FamSize    ===> Encourage Motivation CogPerform,
      SocStatus  ===> Encourage Motivation CogPerform;
   effpart  Encourage ===> CogPerform;
run;
