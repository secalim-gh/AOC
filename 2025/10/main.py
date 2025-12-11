import sys
from functools import reduce

def set_xor(set_a, set_b):
    _difference = set(set_a)
    for elem in set_b:
        if elem in _difference:
            _difference.remove(elem)
        else:
            _difference.add(elem)
    return _difference

def parse_instance(s):
    goal, *buttons, energy = s.split()
    goal = set(u for u, v in enumerate(goal.strip('[]')) if v == '#')
    buttons = list(map(
        lambda u: set(map(int, u.strip('()').split(','))), buttons
    ))
    energy = tuple(map(int, energy.strip('{}').split(',')))
    return goal, buttons, energy

def get_min_xor_solution(goal, buttons):
    
    all_indices = set(goal)
    for b in buttons:
        all_indices.update(b)
    
    if not all_indices:
        return 0 if not goal else float('inf')

    num_lights = max(all_indices) + 1
    num_buttons = len(buttons)
    
    M = [[0] * (num_buttons + 1) for _ in range(num_lights)]

    for i in range(num_lights):
        M[i][num_buttons] = 1 if i in goal else 0
        for j in range(num_buttons):
            M[i][j] = 1 if i in buttons[j] else 0

    pivot_row = 0
    for j in range(num_buttons):
        if pivot_row >= num_lights:
            break

        k = pivot_row
        while k < num_lights and M[k][j] == 0:
            k += 1

        if k < num_lights:
            if k != pivot_row:
                M[pivot_row], M[k] = M[k], M[pivot_row]

            for i in range(num_lights):
                if i != pivot_row and M[i][j] == 1:
                    for l in range(j, num_buttons + 1):
                        M[i][l] ^= M[pivot_row][l]
            
            pivot_row += 1

    for i in range(pivot_row, num_lights):
        if M[i][num_buttons] == 1:
            return float('inf')

    determined_vars = []
    free_vars = []
    
    current_pivot_col = 0
    for i in range(pivot_row):
        while current_pivot_col < num_buttons and M[i][current_pivot_col] == 0:
            current_pivot_col += 1
        if current_pivot_col < num_buttons:
            determined_vars.append(current_pivot_col)
            current_pivot_col += 1
    
    for j in range(num_buttons):
        if j not in determined_vars:
            free_vars.append(j)

    min_presses = float('inf')
    num_free = len(free_vars)
    
    for i in range(1 << num_free):
        solution = [0] * num_buttons
        current_presses = 0

        for k in range(num_free):
            is_pressed = (i >> k) & 1
            solution[free_vars[k]] = is_pressed
            current_presses += is_pressed

        for r in range(pivot_row - 1, -1, -1):
            c = -1
            for j in range(num_buttons):
                if M[r][j] == 1:
                    c = j
                    break
            if c == -1:
                continue

            value = M[r][num_buttons]
            
            for j in range(c + 1, num_buttons):
                value ^= (M[r][j] & solution[j])
            
            solution[c] = value
            current_presses += value

        min_presses = min(min_presses, current_presses)
    
    return min_presses if min_presses != float('inf') else 0

def solve_instance(goal, buttons, _):
    return get_min_xor_solution(goal, buttons)

def main():
    if len(sys.argv) != 2:
        print("Please provide filepath")
        sys.exit(1)

    input_file = sys.argv[1]
    
    try:
        with open(input_file, 'r') as f:
            instances = f.read().strip().split('\n')
    except FileNotFoundError:
        print(f"Error: File not found: {input_file}")
        sys.exit(1)

    parsed_instances = [parse_instance(line) for line in instances if line.strip()]

    A = sum(solve_instance(*u) for u in parsed_instances)
    print(f"Part 1: {A}")

if __name__ == "__main__":
    main()
