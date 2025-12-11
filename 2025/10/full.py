import sys
from itertools import combinations
from functools import reduce
from operator import xor
from scipy.optimize import milp, Bounds, LinearConstraint

def parse_instance(s):
    goal, *buttons, energy = s.split()
    goal = set(u for u, v in enumerate(goal.strip('[]')) if v == '#')
    buttons = list(map(
        lambda u: set(map(int, u.strip('()').split(','))), buttons
    ))
    energy = tuple(map(int, energy.strip('{}').split(',')))
    return goal, buttons, energy

def solve_instance(goal, buttons, _):
    for i in range(len(buttons) + 1):
        for s in combinations(buttons, i):
            if reduce(xor, s, set()) == goal:
                return i
    return 0

def solve_instance_energy(_, buttons, energy):
    num_vars = len(buttons)
    num_constraints = len(energy)
    
    # Cost function (c): Minimize the sum of coefficients (button presses)
    c = [1] * num_vars
    
    # Constraint Matrix (A_ub / A_eq)
    # The matrix must be transposed compared to how 'buttons' is structured
    # A[i][j] = 1 if button j affects energy level i, 0 otherwise.
    A = []
    for i in range(num_constraints):
        row = [(i in b) * 1 for b in buttons]
        A.append(row)
        
    # The original MILP call uses A_eq * x = b_eq
    linear_constraint = LinearConstraint(A, energy, energy)
    
    # Bounds for variables (x): Must be non-negative integers
    # The 'integrality' parameter handles the integer part.
    bounds = Bounds([0] * num_vars, [float('inf')] * num_vars)
    
    res = milp(
        c=c, 
        constraints=linear_constraint, 
        bounds=bounds, 
        integrality=1
    )
    
    # res.fun is the optimal value of the objective function
    return int(res.fun) if res.success else 0

def main():
    if len(sys.argv) != 2:
        print("Usage: python main.py <input_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    
    try:
        with open(input_file, 'r') as f:
            instances = f.read().strip().split('\n')
    except FileNotFoundError:
        print(f"Error: File not found: {input_file}")
        sys.exit(1)

    parsed_instances = [parse_instance(line) for line in instances if line.strip()]

    # Part 1 Calculation
    A = sum(solve_instance(*u) for u in parsed_instances)
    print(f"Part 1 Sum: {A}")

    # Part 2 Calculation
    A_energy = sum(solve_instance_energy(*u) for u in parsed_instances)
    print(f"Part 2 Sum: {A_energy}")

if __name__ == "__main__":
    main()
