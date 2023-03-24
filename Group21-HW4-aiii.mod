

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
	
minimize risk:
	(0.10 * pA) + (0.12 * pB) + (0.05 * pC) + (0.20 * pD) + (0.05 * pE);


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

# Problems-------------------------------------------------------------------------------------------------
problem maxInv: total2024, pA, pB, pC, pD, pE, inv21, inv22, inv23, investA, investB, investE, invest2021, 
				invest2022, invest2023;
				
problem minRisk: total2024, pA, pB, pC, pD, pE, inv21, inv22, inv23, investA, investB, investE, invest2021, 
				 invest2022, invest2023;

# scalarization
param gamma1;
param gamma2;

let gamma1 := 0.25;
let gamma2 := 0.75;

maximize ProfitandRisk: (gamma1 * ((1 * pB) + (1.75 * pD) + (1.40 * pE) + (1.06 * inv23))) - (gamma2 * 
					((0.10 * pA) + (0.12 * pB) + (0.05 * pC) + (0.20 * pD) + (0.05 * pE)));

problem maxScalarized: ProfitandRisk, pA, pB, pC, pD, pE, inv21, inv22, inv23, investA, investB, investE, invest2021, 
				 invest2022, invest2023;
				 
solve maxScalarized;

display pA, pB, pC, pD, pE, inv21, inv22, inv23;
#display maxScalarized, maxScalarized.up, maxScalarized.down;

# for loop 
for {k in 0..4} {
	let gamma1 := k/4;
	let gamma2 := 1 - gamma1;
     
    solve maxScalarized;
   
    printf "\n\ngamma1 = %6.2f; gamma2 = %6.2f \n", gamma1, gamma2; 
    printf "Optimal solution values: pA = %6.2f   pB = %6.2f  pC = %6.2f  pD = %6.2f  pE = %6.2f  inv21 = %6.2f  inv22 = %6.2f  inv23 = %6.2f\n", 
    		pA, pB, pC, pD, pE, inv21, inv22, inv23; 
	printf "Profit generated: %6.2f\n",  total2024; 
	printf "Risk obtained: %6.2f \n\n", risk;
	
	}









































