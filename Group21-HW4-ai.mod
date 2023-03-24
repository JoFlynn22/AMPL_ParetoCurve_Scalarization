
reset;

option solver cplex;
option cplex_options 'sensitivity';

# decision variables, how much to put into projects and investments
var pA >= 0; # Investment in Project A
var pB >= 0; # Investment in Project B
var pC >= 0; # Investment in Project C no limit
var pD >= 0; # Investment in Project D no limit
var pE >= 0; # Investment in Project E
var inv21 >= 0; # Investment in the bank in 2021
var inv22 >= 0; # Investment in the bank in 2022
var inv23 >= 0; # Investment in the bank in 2023

# Objective: maximize total withdrawal in 2024
maximize total2024:
	(1 * pB) + (1.75 * pD) + (1.40 * pE) + (1.06 * inv23);
# 1 for B in 2024, 1.75 for D in 2024, 1.40 for E is only money out for 2024

# Constraints:
subject to investA:
	pA <= 500000;
	
subject to investB:
	pB <= 500000;
	
subject to investE:
	pE <= 750000;
	
# Total investment in 2021 is limited to only $1,000,000
subject to invest2021:
	pA + pC + pD + inv21 = 1000000; # Prof "Available money = A + C + D + Bank"
	
# Total investment in 2022 depends on previous year's investments and returns
subject to invest2022:
	(0.3 * pA) + (1.1 * pC) + (1.06 * inv21) = pB + inv22;
# project B plus the investment = what we got out of the 2021 investment + 6% bank account
# Prof "Investment options = money going to be available in 2022"

# Total investment in 2023 depends on previous year's investments and returns
subject to invest2023:
	pA + (0.3 * pB) + (1.06 * inv22) = pE + inv23;
# Prof "same concept applies for 2023"
# Then cash out in 2024

solve;

display pA, pB, pC, pD, pE, inv21, inv22, inv23;

