include "globals.mzn";

%parameters
int: pr_w;
int: pr_h;
int: n_pieces;
set of int: PIECES = 1..n_pieces;

int: index_largest_p = arg_max([ L[i,1]*L[i,2] | i in PIECES]); % for the symmetry breaking, index of the largest piece

array[PIECES, 1..2] of int: L;
array[int] of int: pieces_ordering_indexes = sort_by(PIECES, [-L[i,1] * L[i,2] | i in PIECES]); % '-' to get the decreasing ordering based on the pieces' area.
set of int: presents_xs_values = array2set(L[PIECES, 1]);
array[int] of int: presents_xs_ordered_values = sort_by(presents_xs_values, [-i | i in presents_xs_values]);

array[1..card(presents_xs_values)] of set of PIECES: presents_group_xs = [group_presents(i, 1) | i in presents_xs_ordered_values];
bool: col_stacking_feasible = is_col_stacking_feasible();
array[1..card(presents_xs_values)] of int: group_columns = 
    [sum([L[j,2] | j in presents_group_xs[i]]) div pr_h | i in 1..card(presents_xs_values)];
array[1..card(presents_xs_values)] of int: group_widths = 
    [sum([L[j,1] | j in presents_group_xs[i]]) div card(presents_group_xs[i]) | i in 1..card(presents_xs_values)];
    
% My Functions
function set of PIECES: group_presents(int: size, int: axis) = {i | i in PIECES where L[i, axis] == size};
function bool: is_col_stacking_feasible() = 
    sum([sum([L[j,2] | j in presents_group_xs[i]]) >= pr_h | i in 1..card(presents_xs_values)]) == card(presents_xs_values);
function int: get_starting_point(int: i) = sum([group_columns[j] * group_widths[j] | j in 1..i - 1]);

%var
array[PIECES, 1..2] of var 0..max([pr_w, pr_h])-1: q;

constraint cumulative(q[PIECES,1], L[PIECES, 1], L[PIECES, 2], pr_h)::domain;
constraint cumulative(q[PIECES,2], L[PIECES, 2], L[PIECES, 1], pr_w)::domain;

constraint
  forall (i in PIECES) ( (q[i,1] + L[i, 1]) <= pr_w  /\ (q[i,2] + L[i, 2]) <= pr_h);

% Non-overlap constraints between two squares
constraint
    forall( i, j in PIECES where i < j ) (
         q[i,1] + L[i, 1] <= q[j,1] 
    \/   q[j,1] + L[j, 1] <= q[i,1] 
    \/   q[i,2] + L[i, 2] <= q[j,2]
    \/   q[j,2] + L[j, 2] <= q[i,2]
    );
% or
%constraint diffn_k(q, L);


%Symmetry breaking rules
constraint
        2 * (q[index_largest_p,1]) <= (pr_w - L[index_largest_p, 1]) 
    /\  2 * (q[index_largest_p,2]) <= (pr_h - L[index_largest_p, 2])
;

%implied constraint (point 2)
constraint (nvalue(q[PIECES,1] ++ [ q[i,1] + L[i,1] | i in PIECES ])) <= n_pieces;
constraint (nvalue(q[PIECES,2] ++ [ q[i,2] + L[i,2] | i in PIECES ])) <= n_pieces;


% Constraints
% Stack presents with the same width on the same column
predicate stack_cols(int: i, int: starting_point) = let { 
    int: n_presents = card(presents_group_xs[i]);
    array[1..n_presents] of PIECES: indexes = [j | j in presents_group_xs[i]];
    array[1..n_presents] of 1..pr_h: weights = [L[j,2] | j in indexes];
    int: columns = group_columns[i];
    array[1..n_presents] of var 1..columns: bins
    } in 
        forall(h in 1..n_presents, l in 1..columns where bins[h] == l) (
            q[indexes[h],1] == starting_point + (group_widths[i] * (l - 1)) 
        );
constraint
    (col_stacking_feasible) -> forall(i in 1..card(presents_xs_values)) (stack_cols(i, get_starting_point(i)));
    
    
ann: search_ann;
%TEST 1: don't use search_ann, comment it.

%TEST 2 & TEST3
search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], input_order, indomain_min);     %comment this line to use the basic search
%search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], first_fail, indomain_min);      %comment this line to use the basic search
%search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], dom_w_deg, indomain_min);        % BEST - comment this line to use the basic search
%search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], input_order, indomain_random);  %comment this line to use the basic search
%search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], first_fail, indomain_random);   %comment this line to use the basic search
%search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], dom_w_deg, indomain_random);    %comment this line to use the basic search

solve :: search_ann  
      satisfy;

output [ show(group_widths)] ++ ["\n"]
       %[ show_int(3,pieces_ordering_indexes[i]) ++ " " | i in PIECES ] ++ ["\n"] ++
       %[ show_int(3,q[i,1]) ++ " " | i in PIECES ] ++ ["\n"] ++
       %[ show_int(3,q[i,2]) ++ " " | i in PIECES ];