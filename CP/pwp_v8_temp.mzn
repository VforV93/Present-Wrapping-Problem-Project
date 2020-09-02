include "globals.mzn";

% --- Parameters ---
int: pr_w;
int: pr_h;
int: n_pieces;
set of int: PIECES = 1..n_pieces;
array[PIECES, 1..2] of int: L;

int: index_largest_p = arg_max([ L[i,1]*L[i,2] | i in PIECES]); % for the symmetry breaking, index of the largest piece

array[int] of int: pieces_ordering_indexes = sort_by(PIECES, [-L[i,1] * L[i,2] | i in PIECES]); % '-' to get the decreasing ordering based on the pieces' area.

set of int: widths_set_values = array2set(L[PIECES, 1]); % distinct(set) pieces' widths
array[int] of int: ordered_widths_values = sort_by(widths_set_values, [-i | i in widths_set_values]); % widths_set_values ordered. '-' to get the decreasing ordering
int: group_number = card(widths_set_values);

array[1..group_number] of set of PIECES: pieces_group_by_w = [{i | i in PIECES where L[i, 1] == w} | w in ordered_widths_values];
array[1..group_number] of int: number_columns_per_group = [sum([L[j,2] | j in pieces_group_by_w[i]]) div pr_h | i in 1..group_number];
array[1..group_number] of int: total_group_width = [sum([L[j,1] | j in pieces_group_by_w[i]]) div card(pieces_group_by_w[i]) | i in 1..group_number];

bool: independent_solving_on_w = independent_solving_on_w_possible(); % 'true' means I renounce to the generality of the model (so it is not important to know the exact number of total solutions anymore), 
                                                                      % I want to speed up the process of finding 1 solution.

% Var
array[PIECES, 1..2] of var 0..max([pr_w, pr_h])-1: q; %-bottom left corner of each pieces


% My Functions
function bool: independent_solving_on_w_possible() = sum([sum([L[j,2] | j in pieces_group_by_w[i]]) >= pr_h | i in 1..group_number]) == group_number;
function int: get_starting_point(int: i) = sum([number_columns_per_group[j] * total_group_width[j] | j in 1..i - 1]);


% --- C O N S T R A I N T S ---
constraint cumulative(q[PIECES,1], L[PIECES, 1], L[PIECES, 2], pr_h)::domain;
constraint cumulative(q[PIECES,2], L[PIECES, 2], L[PIECES, 1], pr_w)::domain;

constraint forall (i in PIECES) ( (q[i,1] + L[i, 1]) <= pr_w  /\ (q[i,2] + L[i, 2]) <= pr_h); %-No exceeding the paper dimensions(pr_w & pr_h)

% Non-overlap constraints between pieces
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
constraint not(independent_solving_on_w) ->
        2 * (q[index_largest_p,1]) <= (pr_w - L[index_largest_p, 1]) 
    /\  2 * (q[index_largest_p,2]) <= (pr_h - L[index_largest_p, 2]);

%implied constraint (point 2)
constraint (nvalue(q[PIECES,1] ++ [ q[i,1] + L[i,1] | i in PIECES ])) <= n_pieces;
constraint (nvalue(q[PIECES,2] ++ [ q[i,2] + L[i,2] | i in PIECES ])) <= n_pieces;


% Constraints        
predicate com_prec(int: i, int: left_margin) = let {
    int: n_pieces = card(pieces_group_by_w[i]);
    array[1..n_pieces] of PIECES: indexes = [j | j in pieces_group_by_w[i]];
    int: columns = number_columns_per_group[i];
    int: width = total_group_width[i];
  } in forall(h in 1..n_pieces) (q[indexes[h],1] >= left_margin /\ q[indexes[h],1] <= left_margin+(columns-1)*width) /\ 
       cumulative(q[pieces_group_by_w[i],1], L[pieces_group_by_w[i], 1], L[pieces_group_by_w[i], 2], pr_h)::domain;

constraint (independent_solving_on_w) -> forall(i in 1..group_number) (com_prec(i, get_starting_point(i)));
    
    
ann: search_ann;
%TEST 1: don't use search_ann, comment it.

%TEST 2 & TEST3
%search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], input_order, indomain_min);     %comment this line to use the basic search
%search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], first_fail, indomain_min);      %comment this line to use the basic search
%search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], dom_w_deg, indomain_min, complete);        % BEST - comment this line to use the basic search
%search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], input_order, indomain_random);  %comment this line to use the basic search
%search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], first_fail, indomain_random);   %comment this line to use the basic search
%search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], dom_w_deg, indomain_random);    %comment this line to use the basic search

solve :: search_ann  
      satisfy;

output [ show(get_starting_point(2))] ++ ["\n"]
       %[ show_int(3,pieces_ordering_indexes[i]) ++ " " | i in PIECES ] ++ ["\n"] ++
       %[ show_int(3,q[i,1]) ++ " " | i in PIECES ] ++ ["\n"] ++
       %[ show_int(3,q[i,2]) ++ " " | i in PIECES ];