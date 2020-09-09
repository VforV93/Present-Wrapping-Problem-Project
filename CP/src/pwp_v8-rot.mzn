include "globals.mzn";

% --- Parameters ---
int: pr_w;
int: pr_h;
int: n_pieces;
set of int: PIECES = 1..n_pieces;
array[PIECES, 1..2] of int: L;

int: index_largest_p = arg_max([ L[i,1]*L[i,2] | i in PIECES]); % for the symmetry breaking, index of the largest piece

array[int] of int: pieces_ordering_indexes = sort_by(PIECES, [-L[i,1] * L[i,2] | i in PIECES]); % '-' to get the decreasing ordering based on the pieces' area.


% --- V A R I A B L E S ---
array[PIECES, 1..2] of var 0..max([pr_w, pr_h])-1: q; %-bottom left corner of each pieces
array[PIECES] of var 0..1: rot; %0: no ration, 1: 90° rotation

% --- F U N C T I O N S ---
function var int: get_dim(int: i, int: d) = (L[i, d]*(1-rot[i]) + (L[i, 3-d]*rot[i]));  % according to the rotation, return the correct value of the width and height of a given piece(i)

% --- C O N S T R A I N T S ---
constraint cumulative(q[PIECES,1], [ get_dim(i, 1) | i in PIECES ], [ get_dim(i, 2) | i in PIECES ], pr_h)::domain;
constraint cumulative(q[PIECES,2], [ get_dim(i, 2) | i in PIECES ], [ get_dim(i, 1) | i in PIECES ], pr_w)::domain;

constraint forall (i in PIECES) ( (q[i,1] + get_dim(i, 1)) <= pr_w  /\ (q[i,2] + get_dim(i, 2)) <= pr_h); %-No exceeding the paper dimensions(pr_w & pr_h)

% Non-overlap constraints between pieces
constraint
    forall( i, j in PIECES where i < j ) (
         q[i,1] + get_dim(i, 1) <= q[j,1] 
    \/   q[j,1] + get_dim(j, 1) <= q[i,1] 
    \/   q[i,2] + get_dim(i, 2) <= q[j,2]
    \/   q[j,2] + get_dim(j, 2) <= q[i,2]
    );
% or
%constraint diffn_k(q, L);

% no rotation for the square pieces(w == h)
constraint
  forall (i in PIECES where L[i,1]=L[i,2]) (rot[i] = 0 );

%Symmetry breaking rules --TEST1 comment the following 3 lines
constraint 
        2 * (q[index_largest_p,1]) <= (pr_w - get_dim(index_largest_p, 1)) 
    /\  2 * (q[index_largest_p,2]) <= (pr_h - get_dim(index_largest_p, 2));

%implied constraint (point 2)
constraint (nvalue(q[PIECES,1] ++ [ q[i,1] + get_dim(i,1) | i in PIECES ])) <= n_pieces;
constraint (nvalue(q[PIECES,2] ++ [ q[i,2] + get_dim(i,2) | i in PIECES ])) <= n_pieces;
    
    
ann: search_ann;

%search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], input_order, indomain_min);     %comment this line to use the basic search
%search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], first_fail, indomain_min);      %comment this line to use the basic search
search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], dom_w_deg, indomain_min, complete);        % BEST - comment this line to use the basic search
%search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], input_order, indomain_random);  %comment this line to use the basic search
%search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], first_fail, indomain_random);   %comment this line to use the basic search
%search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], dom_w_deg, indomain_random);    %comment this line to use the basic search

solve :: search_ann  
      satisfy;

output [ show(pr_w) ++ " " ++ show(pr_h)] ++ ["\n"] ++
       [ show(n_pieces) ] ++ ["\n"] ++
       [ "rot:" ++ show(rot[i]) ++ " " ++ show_int(3,L[i,1]) ++ " " ++ show_int(3,L[i,2]) ++ "\t" ++ show_int(3,q[i,1]) ++ " " ++show_int(3,q[i,2]) ++ "\n" | i in PIECES ]