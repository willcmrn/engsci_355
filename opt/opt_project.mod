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

set TYPES
set AVO_S
set AVO_D
set APP_S
set APP_D
set PACKHOUSE
set SIZE
set PERIOD

# Create sets for all nodes
set AVO_NODES := AVO_S union AVO_D;
set APP_NODES := APP_S union APP_D;

set ALL_NODES := AVO_NODES union APP_NODES;

# --- Params ---

# Set supply params & costs for avocados
param avo_supply {AVO_S};
param avo_demand {AVO_D, PERIOD};

param avo_costs {AVO_NODES, PACKHOUSE};


# Set supply params & costs for apples
param avo_supply {APP_S};
param avo_demand {APP_D, PERIOD};

param avo_costs {APP_NODES, PACKHOUSE};


# Set size parameters
param packrate {SIZE};
param packcost {SIZE};


# The bounds on the flow of goods
param Lower {ALL_NODES, PACKHOUSE} default 0;
param Upper {ALL_NODES, PACKHOUSE} default Infinity;


# --- Vars ---

# Define flows
var flows {i in ALL_NODES, j in PACKHOUSE, PERIODS} >= Lower[i, j], <= Upper[i, j];

# Define plants to build
var build {SIZE, PACKHOUSE, TYPE} integer >= 0;


# --- Model ---

# The objective is to minimise the transportation cost
minimize TotalCost:
  sum{i in SIZE, j in PACKHOUSE, k in TYPE} packcost[i]*build[i,j,k] +
  sum{i in AVO_NODES,j in PACKHOUSE, k in PERIODS} flow[i,j,k]*avo_cost[i,j] +
  sum{i in APP_NODES,j in PACKHOUSE, k in PERIODS} flow[i,j,k]*app_cost[i,j];

#












