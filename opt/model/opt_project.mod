# opt_prpject.mod
#
# Written by Will Cameron, Tyler White, Sulin Phee 2018
#
# This file contains the model for the linear programming model
# used to determine Kemito Pipfruits most effective distrubution plan
#
# Created: 05/08/2018

model;

# --- Sets ---

set TYPE;
set AVO_S;
set AVO_D;
set APP_S;
set APP_D;
set PACKHOUSE;
set SIZE;
set PERIOD;

# Create sets for all nodes
set AVO_NODES := AVO_S union AVO_D;
set APP_NODES := APP_S union APP_D;

set SUPPLY := AVO_S union APP_S;
set DEMAND := AVO_D union APP_D;

set ALL_NODES := AVO_NODES union APP_NODES;

# --- Params ---
# Define number of periods
param no_periods;

# Set supply params & costs for avocados
param avo_supply {AVO_S};
param avo_demand {AVO_D, PERIOD};

param avo_costs {AVO_NODES, PACKHOUSE};


# Set supply params & costs for apples
param app_supply {APP_S};
param app_demand {APP_D, PERIOD};

param app_costs {APP_NODES, PACKHOUSE};


# Set size parameters
param packrate {SIZE};
param packcost {SIZE};


# The bounds on the flow of goods
param Lower {ALL_NODES, PACKHOUSE, TYPE, PERIOD} default 0;
param Upper {ALL_NODES, PACKHOUSE, TYPE, PERIOD} default Infinity;


# --- Vars ---

# Define flows
var flow {i in ALL_NODES, j in PACKHOUSE, k in TYPE, l in PERIOD} >= Lower[i,j,k,l], <= Upper[i,j,k,l];

# Define plants to build
var build {SIZE, PACKHOUSE, TYPE} integer >= 0;


# --- Model ---

# OBJECTIVE FUNCTION
# The objective is to minimise the transportation cost

minimize TotalCost:
  sum{i in SIZE, j in PACKHOUSE, k in TYPE} packcost[i]*no_periods*1000*build[i,j,k] +
  sum{i in AVO_NODES,j in PACKHOUSE, k in TYPE, l in PERIOD} flow[i,j,k,l]*avo_costs[i,j] +
  sum{i in APP_NODES,j in PACKHOUSE, k in TYPE, l in PERIOD} flow[i,j,k,l]*app_costs[i,j];


# CONSTRAINTS

# Supply Constraints

# Avocado flows must not exceed supply
subject to avocado_supply_limit {i in AVO_S, l in PERIOD}:
  sum {j in PACKHOUSE} flow[i,j,'AVO',l] <= avo_supply[i];

# Apple flows must not exceed supply
subject to apple_supply_limit {i in APP_S, l in PERIOD}:
  sum {j in PACKHOUSE} flow[i,j,'APP',l] <= app_supply[i];


# Demand Constraints

# Avocado flows must meet demand
subject to avocado_demand_limit {i in AVO_D, l in PERIOD}:
  sum {j in PACKHOUSE} flow[i,j,'AVO',l] >= avo_demand[i,l];

# Apple flows must meet demand
subject to apple_demand_limit {i in APP_D, l in PERIOD}:
  sum {j in PACKHOUSE} flow[i,j,'APP',l] >= app_demand[i,l];


# Conservation of flows

# Avocado supply
subject to avocado_process_limit {j in PACKHOUSE, l in PERIOD}:
  sum {i in AVO_S} flow[i,j,'AVO',l] - sum {m in AVO_D} flow[m,j,'AVO',l] = 0;

# Apple supply
subject to apple_process_limit {j in PACKHOUSE, l in PERIOD}:
  sum {i in APP_S} flow[i,j,'APP',l] - sum {m in APP_D} flow[m,j,'APP',l] = 0;


# Avocado demand
subject to avocado_output {j in PACKHOUSE, l in PERIOD}:
	sum {i in AVO_D} flow[i,j,'AVO',l] <= sum{z in SIZE} packrate[z]*build[z,j,'AVO'];


# Apple demand
subject to apple_output {j in PACKHOUSE, l in PERIOD}:
	sum {i in APP_D} flow[i,j,'APP',l] <= sum{z in SIZE} packrate[z]*build[z,j,'APP'];







