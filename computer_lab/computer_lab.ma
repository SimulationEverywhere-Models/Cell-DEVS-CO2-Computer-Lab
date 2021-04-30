
[top]
components : computer_lab

[computer_lab]
type : cell

% Each cell is 25cm x 25cm x 25cm = 15.626 Liters of air each
dim : (38,57)
delay : transport
defaultDelayTime : 1000
border : nonwrapped

neighbors :                                                            computer_lab(0,-3) 
neighbors :                                       computer_lab(-1,-2)  computer_lab(0,-2)  computer_lab(1,-2)
neighbors :                    computer_lab(-2,-1) computer_lab(-1,-1) computer_lab(0,-1) computer_lab(1,-1) computer_lab(2,-1)
neighbors : computer_lab(-3,0)  computer_lab(-2,0) computer_lab(-1,0)  computer_lab(0,0)  computer_lab(1,0)  computer_lab(2,0) computer_lab(3,0) 
neighbors :                     computer_lab(-2,1) computer_lab(-1,1)  computer_lab(0,1)  computer_lab(1,1)  computer_lab(2,1)
neighbors :                                        computer_lab(-1,2)  computer_lab(0,2)  computer_lab(1,2)
neighbors :                                                            computer_lab(0,3)

% Background indoor CO2 levels assumed to be 500 ppm
initialvalue : 500
localtransition : rules 

% 2 State Variables corresponding to CO2 concentraion in ppm (conc) and the kind of cell (type)
% Default CO2 concentration inside a building (conc) is 0.05% or 500ppm in normal air
StateVariables: conc type step counter direction
NeighborPorts:  c ty st cn dir
StateValues: 500 -100 0 0 0
InitialVariablesValue: computer_lab.val
% STATE VARIABLE LEGEND :
%   conc = double : represents the CO2 concentration (units of ppm) in a given cell, can be any positive numbe, default value is 500ppm
%
%   type = -100 : normal cell representing air with some CO2 concentration
%   type = -200 : CO2 source, constantly emits a specific CO2 output
%   type = -300 : impermeable structure (ie: walls, chairs, tables, solid objects)
%   type = -400 : doors, fixed at normal indoor background co2 level (500 ppm)
%   type = -500 : window, fixed at lower co2 levels found outside (400 ppm)
%   type = -600 : ventillation, actively removing CO2 (300 ppm)
%   type = -700 : workstations (500 ppm)

%   direction = -1 : sit
%   direction = 0 : stand
%   direction = 1 : Left
%   direction = 2 : top
%   direction = 3 : right
%   direction = 4 : down
%   direction = 5 : LeftUp
%   direction = 6 : LeftDown
%   direction = 7 : RightUp
%   direction = 8 : RightDown

%   counter = 1 : move
%   counter = 0 : stop
%   counter = -1 : occupied

[rules]

% Counting the number of students entering the lab
rule : {~ty := $type; ~cn := $counter;} {$counter := $counter + 1;} 10000 { $type = -400 AND (0,-1)~ty = -400 AND (0,-2)~ty = -300 AND (0,1)~ty = -400 AND (0,2)~ty = -300}

% Entering the lab (Every 10 seconds a new student enters the lab)
rule : {~ty := $type; ~st := $step; ~cn := $counter; ~dir := $direction;} {$type:= -200; $step := $step + 1; $counter := 1; $direction := 6;} 10000 { $type = -100 AND (1,0)~cn < 36 AND (1,0)~ty = -400 AND (1,-1)~ty = -400 AND (1,1)~ty = -400 AND (1,-2)~ty = -300 AND (1,2)~ty = -300 AND not((-1,0)~ty = -200 OR (-2,0)~ty = -200 OR (-3,0)~ty = -200)}

%%%%%%%%%%%%%%%%%%%%%%%%----CHOOSE A DIRECITON----%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% find a direction 
rule : {~ty := $type; ~cn := $counter; ~dir := $direction;}  {$counter := 1; $direction := 6;} 1000 { $type = -200 AND $direction = 1 AND (-1,0)~ty != -100}
rule : {~ty := $type; ~cn := $counter; ~dir := $direction;}  {$counter := 1; $direction := 4;} 1000 { $type = -200 AND $direction = 6 AND (-1,1)~ty != -100}
rule : {~ty := $type; ~cn := $counter; ~dir := $direction;}  {$counter := 1; $direction := 8;} 1000 { $type = -200 AND $direction = 4 AND (0,1)~ty != -100}
rule : {~ty := $type; ~cn := $counter; ~dir := $direction;}  {$counter := 1; $direction := 3;} 1000 { $type = -200 AND $direction = 8 AND (1,1)~ty != -100}
rule : {~ty := $type; ~cn := $counter; ~dir := $direction;}  {$counter := 1; $direction := 7;} 1000 { $type = -200 AND $direction = 3 AND (1,0)~ty != -100}
rule : {~ty := $type; ~cn := $counter; ~dir := $direction;}  {$counter := 1; $direction := 2;} 1000 { $type = -200 AND $direction = 7 AND (1,-1)~ty != -100}
rule : {~ty := $type; ~cn := $counter; ~dir := $direction;}  {$counter := 1; $direction := 5;} 1000 { $type = -200 AND $direction = 2 AND (0,-1)~ty != -100}
rule : {~ty := $type; ~cn := $counter; ~dir := $direction;}  {$counter := 1; $direction := 6;} 1000 { $type = -200 AND $direction = 5 AND (-1,-1)~ty != -100}

% LeftUp direction
rule : {~ty := $type; ~cn := $counter; ~dir := $direction;} { $counter := 1; $direction := 5;} 1000 { $type = -200 AND (((0,-1)~ty + (0,-2)~ty +(0,-3)~ty +(-1,0)~ty +(-1,-1)~ty +(-1,-2)~ty +(-2,0)~ty +(-2,-1)~ty +(-3,0)~ty) < ((0,1)~ty + (0,2)~ty +(0,3)~ty +(1,0)~ty +(1,1)~ty +(1,2)~ty +(2,0)~ty +(2,1)~ty +(3,0)~ty) AND (((0,-1)~ty + (0,-2)~ty +(0,-3)~ty +(-1,0)~ty +(-1,-1)~ty +(-1,-2)~ty +(-2,0)~ty +(-2,-1)~ty +(-3,0)~ty) < ((0,-1)~ty + (0,-2)~ty +(0,-3)~ty +(1,0)~ty +(1,-1)~ty +(1,-2)~ty +(2,0)~ty +(2,-1)~ty +(3,0)~ty)) AND (((0,-1)~ty + (0,-2)~ty +(0,-3)~ty +(-1,0)~ty +(-1,-1)~ty +(-1,-2)~ty +(-2,0)~ty +(-2,-1)~ty +(-3,0)~ty) < ((0,1)~ty + (0,2)~ty +(0,3)~ty +(-1,0)~ty +(-1,1)~ty +(-1,2)~ty +(-2,0)~ty +(-2,1)~ty +(-3,0)~ty))) AND not((1,0)~ty = -400 OR (2,0)~ty = -400 OR (3,0)~ty = -400) AND (-1,-1)~ty = -100 AND $direction > -1}
% LeftDown direction
rule : {~ty := $type; ~cn := $counter; ~dir := $direction;} { $counter := 1; $direction := 6;} 1000 { $type = -200 AND (((0,1)~ty + (0,2)~ty +(0,3)~ty +(-1,0)~ty +(-1,1)~ty +(-1,2)~ty +(-2,0)~ty +(-2,1)~ty +(-3,0)~ty) < ((0,1)~ty + (0,2)~ty +(0,3)~ty +(1,0)~ty +(1,1)~ty +(1,2)~ty +(2,0)~ty +(2,1)~ty +(3,0)~ty) AND ((0,1)~ty + (0,2)~ty +(0,3)~ty +(-1,0)~ty +(-1,1)~ty +(-1,2)~ty +(-2,0)~ty +(-2,1)~ty +(-3,0)~ty) < ((0,-1)~ty + (0,-2)~ty +(0,-3)~ty +(1,0)~ty +(1,-1)~ty +(1,-2)~ty +(2,0)~ty +(2,-1)~ty +(3,0)~ty) AND ((0,1)~ty + (0,2)~ty +(0,3)~ty +(-1,0)~ty +(-1,1)~ty +(-1,2)~ty +(-2,0)~ty +(-2,1)~ty +(-3,0)~ty) < ((0,-1)~ty + (0,-2)~ty +(0,-3)~ty +(-1,0)~ty +(-1,-1)~ty +(-1,-2)~ty +(-2,0)~ty +(-2,-1)~ty +(-3,0)~ty)) AND not((1,0)~ty = -400 OR (2,0)~ty = -400 OR (3,0)~ty = -400) AND (-1,1)~ty = -100 AND $direction > -1}
% RightUp direction
rule : {~ty := $type; ~cn := $counter; ~dir := $direction;} { $counter := 1; $direction := 7;} 1000 { $type = -200 AND (((0,-1)~ty + (0,-2)~ty +(0,-3)~ty +(1,0)~ty +(1,-1)~ty +(1,-2)~ty +(2,0)~ty +(2,-1)~ty +(3,0)~ty) < ((0,1)~ty + (0,2)~ty +(0,3)~ty +(1,0)~ty +(1,1)~ty +(1,2)~ty +(2,0)~ty +(2,1)~ty +(3,0)~ty) AND ((0,-1)~ty + (0,-2)~ty +(0,-3)~ty +(1,0)~ty +(1,-1)~ty +(1,-2)~ty +(2,0)~ty +(2,-1)~ty +(3,0)~ty) < ((0,-1)~ty + (0,-2)~ty +(0,-3)~ty +(-1,0)~ty +(-1,-1)~ty +(-1,-2)~ty +(-2,0)~ty +(-2,-1)~ty +(-3,0)~ty) AND ((0,-1)~ty + (0,-2)~ty +(0,-3)~ty +(1,0)~ty +(1,-1)~ty +(1,-2)~ty +(2,0)~ty +(2,-1)~ty +(3,0)~ty) < ((0,1)~ty + (0,2)~ty +(0,3)~ty +(-1,0)~ty +(-1,1)~ty +(-1,2)~ty +(-2,0)~ty +(-2,1)~ty +(-3,0)~ty)) AND not((1,0)~ty = -400 OR (2,0)~ty = -400 OR (3,0)~ty = -400) AND (1,-1)~ty = -100 AND $direction > -1}
% RightDown direction
rule : {~ty := $type; ~cn := $counter; ~dir := $direction;} { $counter := 1; $direction := 8;} 1000 { $type = -200 AND (((0,1)~ty + (0,2)~ty +(0,3)~ty +(1,0)~ty +(1,1)~ty +(1,2)~ty +(2,0)~ty +(2,1)~ty +(3,0)~ty) < ((0,-1)~ty + (0,-2)~ty +(0,-3)~ty +(1,0)~ty +(1,-1)~ty +(1,-2)~ty +(2,0)~ty +(2,-1)~ty +(3,0)~ty) AND ((0,1)~ty + (0,2)~ty +(0,3)~ty +(1,0)~ty +(1,1)~ty +(1,2)~ty +(2,0)~ty +(2,1)~ty +(3,0)~ty) < ((0,-1)~ty + (0,-2)~ty +(0,-3)~ty +(-1,0)~ty +(-1,-1)~ty +(-1,-2)~ty +(-2,0)~ty +(-2,-1)~ty +(-3,0)~ty) AND ((0,1)~ty + (0,2)~ty +(0,3)~ty +(1,0)~ty +(1,1)~ty +(1,2)~ty +(2,0)~ty +(2,1)~ty +(3,0)~ty) < ((0,1)~ty + (0,2)~ty +(0,3)~ty +(-1,0)~ty +(-1,1)~ty +(-1,2)~ty +(-2,0)~ty +(-2,1)~ty +(-3,0)~ty)) AND not((1,0)~ty = -400 OR (2,0)~ty = -400 OR (3,0)~ty = -400) AND (1,1)~ty = -100 AND $direction > -1}


%%%%%%%%%%%%%%%%%%%%%%%%%%%----MOVING----%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Left
rule : {~ty := $type; ~st := $step; ~cn := $counter; ~dir := $direction;} { $type := -200; $step := $step + 1; $counter := 0; $direction := 1;} 1000 { $type = -100 AND (1,0)~ty = -200 AND (1,0)~cn = 1 AND (1,0)~dir = 1}

% Up
rule : {~ty := $type; ~st := $step; ~cn := $counter; ~dir := $direction;} { $type := -200; $step := $step + 1; $counter := 0; $direction := 2;} 1000 { $type = -100 AND (0,1)~ty = -200 AND (0,1)~cn = 1 AND (0,1)~dir = 2}

% Right
rule : {~ty := $type; ~st := $step; ~cn := $counter; ~dir := $direction;} { $type := -200; $step := $step + 1; $counter := 0; $direction := 3;} 1000 { $type = -100 AND (-1,0)~ty = -200 AND (-1,0)~cn = 1 AND (-1,0)~dir = 3}

% Down
rule : {~ty := $type; ~st := $step; ~cn := $counter; ~dir := $direction;} { $type := -200; $step := $step + 1;$counter := 0; $direction := 4;} 1000 { $type = -100 AND (0,-1)~ty = -200 AND (0,-1)~cn = 1 AND (0,-1)~dir = 4}

% LeftUp
rule : {~ty := $type; ~st := $step; ~cn := $counter; ~dir := $direction;} { $type := -200; $step := $step + 1; $counter := 0; $direction := 5;} 1000 { $type = -100 AND (1,1)~ty = -200 AND (1,1)~cn = 1 AND (1,1)~dir = 5}

% LeftDown
rule : {~ty := $type; ~st := $step; ~cn := $counter; ~dir := $direction;} { $type := -200; $step := $step + 1; $counter := 0; $direction := 6;} 1000 { $type = -100 AND (1,-1)~ty = -200 AND (1,-1)~cn = 1 AND (1,-1)~dir = 6}

% RightUp
rule : { ~ty := $type; ~st := $step; ~cn := $counter; ~dir := $direction;} { $type := -200; $step := $step + 1; $counter := 0; $direction := 7;} 1000 { $type = -100 AND (-1,1)~ty = -200 AND (-1,1)~cn = 1 AND (-1,1)~dir = 7}

% RightDown
rule : {~ty := $type; ~st := $step; ~cn := $counter; ~dir := $direction;} { $type := -200; $step := $step + 1; $counter := 0; $direction := 8;} 1000 { $type = -100 AND (-1,-1)~ty = -200 AND (-1,-1)~cn = 1 AND (-1,-1)~dir = 8}

% clear the cell to empty
 rule : {~ty := $type;} {$type := -100;} 1000 { $type = -200 AND $counter = 1 AND $direction > 0}
% Change status back to move 
 rule : {~c := $conc; ~ty := $type; ~cn := $counter;} { $conc := ((121.16*3) + (((-1,0)~c + (0,-1)~c + (0,0)~c + (0,1)~c + (1,0)~c)/5)); $type := -200; $counter := 1;} 0 { $type = -200 AND $counter = 0 AND $direction > 0}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: WORKSTATIONS OCCUPATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%----DIFFUSION----%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Diffusion between normal air cells 
rule : { ~c := $conc; ~ty := $type; } { $conc := (((-1,0)~c + (0,-1)~c + (0,0)~c + (0,1)~c + (1,0)~c)/5); } 1000 { $type = -100 AND (-1,0)~c > 0 AND (0,-1)~c > 0 AND (0,1)~c > 0 AND (1,0)~c > 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((0,-1)~c + (0,0)~c + (0,1)~c + (1,0)~c)/4); } 1000 { $type = -100 AND (-1,0)~c < 0 AND (0,-1)~c > 0 AND (0,1)~c > 0 AND (1,0)~c > 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((-1,0)~c + (0,0)~c + (0,1)~c + (1,0)~c)/4); } 1000 { $type = -100 AND (-1,0)~c > 0 AND (0,-1)~c < 0 AND (0,1)~c > 0 AND (1,0)~c > 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((-1,0)~c + (0,-1)~c + (0,0)~c + (1,0)~c)/4); } 1000 { $type = -100 AND (-1,0)~c > 0 AND (0,-1)~c > 0 AND (0,1)~c < 0 AND (1,0)~c > 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((-1,0)~c + (0,-1)~c + (0,0)~c + (0,1)~c)/4); } 1000 { $type = -100 AND (-1,0)~c > 0 AND (0,-1)~c > 0 AND (0,1)~c > 0 AND (1,0)~c < 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((0,0)~c + (0,1)~c + (1,0)~c)/3); } 1000 { $type = -100 AND (-1,0)~c < 0 AND (0,-1)~c < 0 AND (0,1)~c > 0 AND (1,0)~c > 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((-1,0)~c + (0,-1)~c + (0,0)~c)/3); } 1000 { $type = -100 AND (-1,0)~c > 0 AND (0,-1)~c > 0 AND (0,1)~c < 0 AND (1,0)~c < 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((0,-1)~c + (0,0)~c + (1,0)~c)/3); } 1000 { $type = -100 AND (-1,0)~c < 0 AND (0,-1)~c > 0 AND (0,1)~c < 0 AND (1,0)~c > 0}
rule : { ~c := $conc; ~ty := $type; } { $conc := (((-1,0)~c + (0,0)~c + (0,1)~c)/3); } 1000 { $type = -100 AND (-1,0)~c > 0 AND (0,-1)~c < 0 AND (0,1)~c > 0 AND (1,0)~c < 0}


% CO2 sources have their concentration continually increased by 12.16 ppm every 5 seconds. Normal diffusion rule applies. (idle CO2 sources)
rule : { ~c := $conc; ~ty := $type; } { $conc := ((121.16*2) + (((-1,0)~c + (0,-1)~c + (0,0)~c + (0,1)~c + (1,0)~c)/5)); } 5000 { $type = -200 AND $direction = -1 }

% CO2 sources have their concentration continually increased by 12.16 ppm every 5 seconds. Normal diffusion rule applies. (increase the amount of emitted CO2 if the person is walking. This amount has to be defined based on some scientific references. For simplicity the amount is multiplied by 3.
rule : { ~c := $conc; ~ty := $type; } { $conc := ((121.16*3) + (((-1,0)~c + (0,-1)~c + (0,0)~c + (0,1)~c + (1,0)~c)/5)); } 5000 { $type = -200 AND $direction > -1 }

% TODO : ventillation system in a specific zoon can be switched on/off based on the surrounded CO2 level.
% TODO : Numbers of person's steps have be taken into account as this will increase the amount of emitted CO2.
% TODO : Direction of person's move should be defined more logically using some complex algorithms.

% Default rule: keep concentration the same if all other rules untrue (should never happen)
rule : { ~c := $conc; ~ty := $type; } 1000 { t }



