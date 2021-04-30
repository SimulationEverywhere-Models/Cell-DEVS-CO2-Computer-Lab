# co2_models
Models for CO2 spread in closed spaces
A CD++ model 

This is a description of the co2_lab model. The other models follow the same rules, but with different floor plans and dimensions.

A Cell-DEVS model in CD++ that can represent: 
1.	Closed spaces of size 3.5m × 5.75m × 2.5m (width × length × height)
2.	Occupants arriving and leaving at different times
3.	Presence of means for CO2 to escape (an open door, a window or a ventilation port), and 
4.	The placement of one or two CO2 sensors in constant locations. 

Computing Function:
T(N) 	                                N 
conc = average of neighbors 	        type = 0 
conc = neighbors average + 12.16 ppm 	type = 1 
conc = −10 	                          type = 2 
conc = 500 ppm 	                      type = 3 
conc = 400 ppm 	                      type = 4 
conc = 300 ppm 	                      type = 5 


Duration Function:
D(S) 	        S 
𝑅0 += 1,000 	type = 0 
𝑅0 += 5,000 	type = 1 
𝑅0 += 1,000 	type = 2 
𝑅0 += 1,000 	type = 3 
𝑅0 += 1,000 	type = 4 
𝑅0 += 1,000 	type = 5 

More information: http://cell-devs.sce.carleton.ca/publications/2020/KWD20/


Execution:
$ bash run_co2.sh

