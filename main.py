import datetime
from minizinc import Instance, Model, Solver, Result

PRINT_FIRST_N_SOL = 5
PRINT_LAST_N_SOL = 5
PRINT_EVERY_N_SOL = 100


def print_stats(res: Result):
    print("\n|=== STATISTICS ===|")
    for key, value in res.statistics.items():
        if type(value) is datetime.timedelta:
            print("{0:18} : {1}".format(key, value.total_seconds()))
        else:
            print("{0:18} : {1}".format(key, value))


"""
Print the first PRINT_FIRST_N_SOL solutions, the last PRINT_LAST_N_SOL solutions and 1 solution every PRINT_EVERY_N_SOL
"""
def print_solutions(res: Result):
    n_sol = len(res)
    if n_sol == 1:
        print("{}".format(res["q"]))
    else:
        last_i = 0
        for i in range(n_sol):
            if i < PRINT_FIRST_N_SOL or i >= (n_sol-PRINT_LAST_N_SOL) or ((i+1)%PRINT_EVERY_N_SOL == 0):
                if i > last_i+1:
                    print(" ... ")
                print("{} : {} ".format(i, res[i, "q"]))
                last_i = i

    print("Tot: {}\n".format(n_sol))


model_name = "pwp_v7"
instance_name = "8x8"

# Load pwp model from file
pwp = Model("./CP/" + model_name + ".mzn")
pwp.add_file("./CP/src/" + instance_name + ".dzn")
# Find the MiniZinc solver configuration for Gecode
gecode = Solver.lookup("gecode")
gecode.stdFlags = [ "-s"]  # solutions = %minizinc -a -s CP/pwp_v7.mzn
# Create an Instance of the pwp model for Gecode
instance = Instance(gecode, pwp)


result = instance.solve(all_solutions=False)
# Output the array q

print_solutions(result)

print_stats(result)