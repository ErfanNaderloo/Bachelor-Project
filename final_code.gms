$Title ThesisFinal Problem
$onsymxref
$onsymlist

Sets
   N       'index of all nodes' /1*15/
   NP(N)   'subset of Plants'     /1*3/
   ND(N)   'subset of potential Depots'     /4*8/
   NC(N)   'subset of customers (clients)'     /9*15/
   V       'set of all available primary vehicles at first echelon'  /1,2,3/
;
alias (N,i);
alias (N,j);
alias (N,k);
alias (N,m);

parameter FD(k)  'Depot Opening Cost'
          /4   150
           5   100
           6   200
           7   350
           8   450  / ;

parameter CP(k)  'Plants Capacity'
          /1   10000
           2   8000
           3   11000/ ;

parameter CD(k)  'Depots Capacity'
          /4   5000
           5   5500
           6   5300
           7   5200
           8   5100  / ;

parameter d(i)   'represents the Customers Demand'
/
9         300
10        3100
11        125
12        100
13        200
14        150
15        150
  /;

parameter FV1(v)   'primary vehicles fixed cost'
/
1        40
2        20
3        10  /;

parameter CV1(v)   'primary vehicles capacity'
/
1        5000
2        10000
3        20000  /;

parameter Eve1(v)   'primary vehicles empty emissions'
/
1        0.51219
2        0.63789
3        0.75783  /;

parameter Evf1(v)   'primary vehicles full emissions'
/
1        0.60127
2        0.82015
3        1.09053  /;

Scalar NV    'Maximum number of Secondary vehicles at each depot'    /1/;
Scalar FV2   'Secondary Vehicles Fixed cost' /100/;
Scalar CV2   'Secondary Vehicles capacity' /4500/;
Scalar Eve2  'Secondary vehicles empty emissions'   /0.51219/;
Scalar Evf2  'Secondary vehicles full emissions'    /0.60127/;

Table C(i,j)      'represents the transportation costs between nodes i and j, i; j belongs to N'

   1        2        3         4        5           6        7          8        9         10       11        12        13        14        15
1  0        0        0        63        76         23        44        43        0         0        0         0         0         0         0
2  0        0        0        19        95         27        12        42        0         0        0         0         0         0         0
3  0        0        0        64        44         68        50        24        0         0        0         0         0         0         0
4  63       19       64       0         103        45        21        49        22        43       29        30        35        18        109
5  76       95       44       103        0         91        85        55        113       112      95        108       118       106       8
6  23       27       68       45        91         0         31        45        35        22       17        25        32        31        93
7  44       12       50       21        85         31        0         31        30        39       18        28        38        22        90
8  43       42       24       49        55         45        31        0         60        62       43        56        66        52        60
9  0        0        0        22        113        35        30        60        0         24       21        12        14        8         118
10 0        0        0        43        112        22        39        62        24        0        21        14        14        26        115
11 0        0        0        29        95         17        18        43        21        21       0         14        23        15        99
12 0        0        0        30        108        25        28        56        12        14       14        0         11        12        112
13 0        0        0        35        118        32        38        66        14        14       23        11        0         19        122
14 0        0        0        18        106        31        22        52        8         26       15        12        19        0         110
15 0        0        0        109        8         93        90        60        118       115      99        112       122       110        0

;
variable z1               'objective function (1) value' ;
variable z2               'objective function (2) value' ;
variable
Vtest1
Vtest2
Vtest3
Vtest4
Vtest5
Vtest6
Vtest7 ;

binary variable y(k)      'binary variables for Depots location' ;
binary variable s(i,j,v)  'binary variables for first level routing' ;
binary variable x(i,j)    'binary variables for second level routing' ;
binary variable w(i,k)    '=1 if depot k is assigned to service customer i' ;
integer variable U(i,j)   'represent  the  remaining  demand  to  be  delivered  after  leaving node i if a vehicle travels from node i to node j, for every i, j belong to N' ;
integer variable Q(i,j,v) 'flow of freight passing through arc (i,j) belonging to the first echelon' ;

Equations
      Cost1               'minimize the total cost, consisting of vehicle traveling cost, depot opening cost, and vehicle fixed cost (for both levels).'
      Environment2        'minimize the total CO2 emissions of system'
*      epscons             'upper bound for epssilon constraint method'
      Constraint3         'Constraint (3) ensures that all plants must be located.'
      Constraint4(i,v)    'Constraint (4) assures that a given primary vehicle only starts a tour from the aaociate plant.'
      Constraint5(i,v)    'Constraints (5)-(6)-(7)-(8) guarantee that, in the first echelon, exactly one arc enters and one arc exits for each node associated with open Depots.'
      Constraint6(k)      'Constraints (5)-(6)-(7)-(8) guarantee that, in the first echelon, exactly one arc enters and one arc exits for each node associated with open Depots.'
      Constraint7(k)      'Constraints (5)-(6)-(7)-(8) guarantee that, in the first echelon, exactly one arc enters and one arc exits for each node associated with open Depots.'
      Constraint8(k,i)    'Constraints (5)-(6)-(7)-(8) guarantee that, in the first echelon, exactly one arc enters and one arc exits for each node associated with open Depots.'
      Constraint9(i)      'Constraint (9) ensures that the total demand of depots assigned to a plant must not exceed the plants capacity.'
      Constraint10(i,j,v) 'Constraint (10) guarantee that, in the first echelon, no route created between the plants'
      Constraint11(i)     'Constraint (11) indicate that the flow balance for each node'
      Constraint12(i,j,v) 'Constraint (12) are capacity constraints.'
      Constraint13(v)     'Constraint (13) guarantee that the entering flow in the plants is equal to zero'
      Constraint14(j,k)   'Constraint (14) state that the generic second echelon arc can assume value 1 only if the respective depot is open.'
      Constraint15(i)     'Constraint (15) ensures that each customer is served exactly once.'
      Constraint16(i)     'Constraint (16) makes sure that the number of entering arcs is equal to the number of leaving arcs for each node.'
      Constraint17(i)     'Constraint (17) is the flow constraint for demand.'
      Constraint18(j,i)   'Constraint (18) guarantees  that  the  remaining  demand  does  not  exceed  the capacity of  vehicle at  any  time.'
      Constraint19(k)     'Constraint (19)  implies  that  the total demand of customers assigned to a specific depot is satisfied by the vehicles dispatched from the depot.'
      Constraint20(k)     'Constraint (20) ensures that the remaining demand of a vehicle is zero after the vehicle has serviced its last customer.'
      Constraint21(i,j)   'Constraints (21) and (22) state the bounds of the U(i,j) variables.'
      Constraint22(i,j)   'Constraints (21) and (22) state the bounds of the U(i,j) variables.'
      Constraint23(i)     'Constraint (23) guarantees that each customer is assigned to a depot.'
      Constraint24(k)     'Constraint (24) ensures that the total demand of customers assigned to a depot must not exceed the depots capacity.'
      Constraint25(i,k)   'Constraints  (25)–(27)  prohibit  infeasible routes.'
      Constraint26(i,k)   'Constraints  (25)–(27)  prohibit  infeasible routes.'
      Constraint27(i,j,k) 'Constraints  (25)–(27)  prohibit  infeasible routes.'
*      Constraint28(k)     'Constraint (28) stipulate the Maximum number of Secondary vehicles at each depot'
Ctest1
Ctest2
Ctest3
Ctest4
Ctest5
Ctest6
Ctest7
;


Cost1..          z1 =e= sum((i,j,v)$(NP(i)+ND(i) and NP(j)+ND(j) and ord(i)<>ord(j)),C(i,j)*s(i,j,v))
                       +sum((i,j)$(ND(i)+NC(i) and NC(j)),C(i,j)*x(i,j))
                       +sum((k)$(ND(k)),FD(k)*y(k))
                       +sum((i,j,v)$(ND(j) and NP(i)),FV1(v)*s(i,j,v))
                       +sum((k,i)$(ND(k) and NC(i)),FV2*x(k,i)) ;

Ctest1..  Vtest1=e= sum((i,j,v)$(NP(i)+ND(i) and NP(j)+ND(j) and ord(i)<>ord(j)),C(i,j)*s(i,j,v));
Ctest2..  Vtest2=e= sum((i,j)$(ND(i)+NC(i) and NC(j)),C(i,j)*x(i,j));
Ctest3..  Vtest3=e= sum((k)$(ND(k)),FD(k)*y(k));
Ctest4..  Vtest4=e= sum((i,j,v)$(ND(j) and NP(i)),FV1(v)*s(i,j,v));
Ctest5..  Vtest5=e= sum((k,i)$(ND(k) and NC(i)),FV2*x(k,i)) ;




Environment2..   z2 =e= sum((i,j,v)$(NP(i)+ND(i) and NP(j)+ND(j) and ord(i)<>ord(j)),C(i,j)*(((Evf1(v)-Eve1(v))*Q(i,j,v)/CV1(v))+(Eve1(v)*S(i,j,v))))
                       +sum((i,j)$(ND(i)+NC(i) and NC(j)),C(i,j)*(((Evf2-Eve2)*U(i,j)/CV2)+(Eve2*x(i,j))))   ;


Ctest6..  Vtest6=e= sum((i,j,v)$(NP(i)+ND(i) and NP(j)+ND(j) and ord(i)<>ord(j)),C(i,j)*(((Evf1(v)-Eve1(v))*Q(i,j,v)/CV1(v))+(Eve1(v)*S(i,j,v))))      ;
Ctest7..  Vtest7=e= sum((i,j)$(ND(i)+NC(i) and NC(j)),C(i,j)*(((Evf2-Eve2)*U(i,j)/CV2)+(Eve2*x(i,j))))   ;

*epscons..        z1 =l= 1493 ;

Constraint3..                                                                                  sum((k)$(NP(k)),y(k))=e= card(NP) ;

Constraint4(i,v)$(NP(i))..                                                                     sum((j)$(ND(j)),s(i,j,v))=l=1 ;

Constraint5(i,v)$(NP(i)+ND(i))..                                                               sum((j)$(NP(j)+ND(j) and ord(i)<>ord(j)),s(i,j,v))=e=sum((j)$(NP(j)+ND(j) and ord(i)<>ord(j)),s(j,i,v))  ;

Constraint6(k)$(ND(k))..                                                                       sum((j,v)$(NP(j)+ND(j) and ord(k)<>ord(j)),s(k,j,v))=e=y(k) ;

Constraint7(k)$(ND(k))..                                                                       sum((j,v)$(NP(j)+ND(j) and ord(k)<>ord(j)),s(j,k,v))=e=y(k) ;

Constraint8(k,i)$(NP(i) and ND(k))..                                                           sum((v),s(i,k,v))=l=y(k) ;

Constraint9(i)$(NP(i))..                                                                       sum((j,v)$(ND(j)),Q(i,j,v)) =l= CP(i)  ;

Constraint10(i,j,v)$(NP(i) and NP(j))..                                                        S(i,j,v)=e=0  ;

Constraint11(i)$(ND(i))..                                                                      sum((j,v)$(NP(j)+ND(j)),Q(j,i,v))-sum((j,v)$(NP(j)+ND(j)),Q(i,j,v))=e=sum((k)$(NC(k)),d(k)*w(k,i))    ;

Constraint12(i,j,v)$(NP(i)+ND(i) and NP(j)+ND(j) and ord(i)<>ord(j))..                         Q(i,j,v)=l=CV1(v)*s(i,j,v)       ;

Constraint13(v)..                                                                              sum((i,j)$(NP(j) and ND(i)),Q(i,j,v))=e=0     ;

Constraint14(j,k)$(ND(k) and NC(j))..                                                          x(k,j)=l=y(k) ;

Constraint15(i)$(NC(i))..                                                                      sum((j)$(ND(j)+NC(j)),x(i,j))=e=1  ;

Constraint16(i)$(ND(i)+NC(i))..                                                                sum((j)$(ND(j)+NC(j)),x(j,i))=e=sum((j)$(ND(j)+NC(j)),x(i,j))  ;

Constraint17(i)$(NC(i))..                                                                      sum((j)$(ND(j)+NC(j)),U(j,i))-sum((j)$(ND(j)+NC(j)),U(i,j))=e=d(i)  ;

Constraint18(j,i)$(ND(j)+NC(j) and ND(i)+NC(i) and ord(i)<>ord(j))..                           U(i,j)=l=(CV2*x(i,j)) ;

Constraint19(k)$(ND(k))..                                                                      sum((j)$(NC(j)),U(k,j))=e=sum((j)$(NC(j)),w(j,k)*d(j)) ;

Constraint20(k)$(ND(k))..                                                                      sum((j)$(NC(j)),U(j,k))=e=0 ;

Constraint21(i,j)$(NC(i) and ND(j)+NC(j))..                                                    U(i,j)=l=((CV2-d(i))*x(i,j)) ;

Constraint22(i,j)$(NC(j) and ND(i)+NC(i))..                                                    U(i,j)=g=d(j)*x(i,j) ;

Constraint23(i)$(NC(i))..                                                                      sum((k)$(ND(k)),w(i,k))=e=1 ;

Constraint24(k)$(ND(k))..                                                                      sum((i)$(NC(i)),d(i)*w(i,k))=l=CD(k)*y(k) ;

Constraint25(i,k)$(NC(i) and ND(k))..                                                          x(i,k)=l=w(i,k)  ;

Constraint26(i,k)$(NC(i) and ND(k))..                                                          x(k,i)=l=w(i,k)  ;

Constraint27(i,j,k)$(NC(i) and NC(j) and ord(i)<>ord(j) and ND(k))..                           x(i,j)+w(i,k)+sum((m)$(ND(m) and ord(m)<>ord(k)),w(j,m))=l=2 ;

*Constraint28(k)$(ND(k))..                                                                     sum((i)$(NC(i)),x(k,i))=l=NV  ;


U.up(i,j)=100000 ;
Q.up(i,j,v)=100000 ;

Model ThesisFinal /all/   ;

option reslim=3600;
option limrow=1000;
option limcol=1000;
option threads=5;

*option optcr=0;
*option optca=0;

*Solve ThesisFinal using MIP Minimizing z2   ;


Option MIP=CPLEX;
Option Reslim=300;
option optca=0, optcr=0;



********************************************************************************
******************************LexAEC Method*************************************
********************************************************************************

Sets  OBJECTIVE 'set of objctives'  /obj1 , obj2 /;

* All functions are minimized *

Variables
f_obj1
f_obj2
;

Equations
ObjFun1
ObjFun2
;

*Preference of objectives
ObjFun1..        f_obj1=e=z1;
ObjFun2..        f_obj2=e=z2;


Model MODM
/
ThesisFinal
ObjFun1
ObjFun2
/
;


*****Lexicografic method for determining Epsilon range


Parameter PayoffMat(OBJECTIVE,OBJECTIVE);

Solve MODM US MIP Min f_obj1;
PayoffMat('obj1','obj1')=f_obj1.l;

Solve MODM US MIP Min f_obj2;
PayoffMat('obj2','obj2')=f_obj2.l;

*

Equation
Optimality_objfun1
Optimality_objfun2
;

Optimality_objfun1..     f_obj1=e=PayoffMat('obj1','obj1');
Optimality_objfun2..     f_obj2=e=PayoffMat('obj2','obj2');


** first row of the Payoff Matrix

Model    objfun1_objfun2
/
MODM
Optimality_objfun2
/
;

*Option Reslim=400;
Solve objfun1_objfun2 US MIP Min f_obj1;
PayoffMat('obj1','obj2')=f_obj1.l;


** second row of the payoff matrix

Option Reslim=400;
Model    objfun2_objfun1
/
MODM
Optimality_objfun1
/
;
Solve objfun2_objfun1 US MIP Min f_obj2;
PayoffMat('obj2','obj1')=f_obj2.l;


********************************************************************************
Parameter
MinFunction(OBJECTIVE)
MaxFunction(OBJECTIVE)
RangFunction(OBJECTIVE)
;

MinFunction('obj1')=PayoffMat('obj1','obj1');
MinFunction('obj2')=PayoffMat('obj2','obj2');

MaxFunction('obj1')=smax(objective,PayoffMat('obj1',objective));
MaxFunction('obj2')=smax(objective,PayoffMat('obj2',objective));

RangFunction(OBJECTIVE)=MaxFunction(OBJECTIVE)-MinFunction(OBJECTIVE);


Display
PayoffMat
MinFunction
MaxFunction
RangFunction


*****AEC method******

Scalar
PHI2
Epsilon2
;

PHI2=1/100*RangFunction('obj1')/RangFunction('obj2');

Positive Variables
Slack2
;

Free Variable
Z_AEC
;

Equations
AEC_OBJ
AEC_Cons2
;

AEC_OBJ..        Z_AEC =e= f_obj1 - PHI2*Slack2 ;
AEC_Cons2..      f_obj2 + Slack2 =e= Epsilon2;

*********************Main Loop of AEC for Pareto Front********************

Sets
Partion_Fun2     /1*20/

;

Epsilon2=MinFunction('obj2');


Scalar
stepsize2

;
stepsize2=RangFunction('obj2')/(card(Partion_Fun2)-1);

Model AEC
/
MODM
AEC_OBJ
AEC_Cons2
/

Parameter Result(Partion_Fun2,*);


Option Reslim=300;

Loop(Partion_Fun2,


Solve AEC US MIP Min Z_AEC;

if ( AEC.ModelStat <> 4 and AEC.ModelStat <> 19,

Display z1.l , z2.l , x.l , y.l , w.l , u.l , Q.l , s.l
Vtest1.l ,
Vtest2.l ,
Vtest3.l ,
Vtest4.l ,
Vtest5.l
Vtest6.l ,
Vtest7.l  ;


Result(Partion_Fun2,'Epsilon2')=Epsilon2;
Result(Partion_Fun2,'Obj1')=f_obj1.l;
Result(Partion_Fun2,'Obj2')=f_obj2.l;
);

Epsilon2=Epsilon2+stepsize2;

);

Display   Result;







