include "globals.mzn";

%The same model of pwp_v7 but with pieces rotation

%parameters
int: pr_w;
int: pr_h;
int: n_pieces;
set of int: PIECES = 1..n_pieces;

int: index_largest_p = arg_max([ L[i,1]*L[i,2] | i in PIECES]); % for the symmetry breaking, index of the largest piece

array[PIECES, 1..2] of int: L;
array[int] of int: pieces_ordering_indexes = sort_by(PIECES, [-L[i,1] * L[i,2] | i in PIECES]); % '-' to get the decreasing ordering based on the pieces' area.

array[PIECES, 1..2] of var 0..max([pr_w, pr_h])-1: q;
array[PIECES] of var 0..1: rot; %0: no ration, 1: 90° rotation

constraint cumulative(q[PIECES,1], [ (L[i, 1]*(1-rot[i])) + (L[i, 2]*rot[i])  | i in PIECES],[ (L[i, 2]*(1-rot[i])) + (L[i, 1]*rot[i]) | i in PIECES], pr_h)::domain;
constraint cumulative(q[PIECES,2], [ (L[i, 2]*(1-rot[i])) + (L[i, 1]*rot[i]) | i in PIECES], [ (L[i, 1]*(1-rot[i])) + (L[i, 2]*rot[i])  | i in PIECES], pr_w)::domain;

constraint
  forall (i in 1..n_pieces) ( (q[i,1] + (L[i, 1]*(1-rot[i]) + (L[i, 2]*rot[i])) ) <= pr_w  /\ (q[i,2] + (L[i, 2]*(1-rot[i]) + (L[i, 1]*rot[i]))) <= pr_h);

% Non-overlap constraints between two squares
constraint
    forall( i, j in PIECES where i < j ) (
         q[i,1] + (L[i, 1]*(1-rot[i]) + (L[i, 2]*rot[i])) <= q[j,1] 
    \/   q[j,1] + (L[j, 1]*(1-rot[j]) + (L[j, 2]*rot[j])) <= q[i,1] 
    \/   q[i,2] + (L[i, 2]*(1-rot[i]) + (L[i, 1]*rot[i])) <= q[j,2]
    \/   q[j,2] + (L[j, 2]*(1-rot[j]) + (L[j, 1]*rot[j])) <= q[i,2]
    );
% or
%constraint diffn_k(q, L);

% no rotation for the square pieces(w == h)
constraint
  forall (i in PIECES where L[i,1]=L[i,2]) (rot[i] = 0 );

%Symmetry breaking rules
constraint
        2 * (q[index_largest_p,1]) <= (pr_w - (L[index_largest_p, 1]*(1-rot[index_largest_p]) + (L[index_largest_p, 2]*rot[index_largest_p])))      
    /\  2 * (q[index_largest_p,2]) <= (pr_h - (L[index_largest_p, 2]*(1-rot[index_largest_p]) + (L[index_largest_p, 1]*rot[index_largest_p])))      
;

%implied constraint (point 2)
constraint (nvalue(q[PIECES,1] ++ [ q[i,1] + (L[i, 1]*(1-rot[i]) + (L[i, 2]*rot[i]))  | i in PIECES ])) <= n_pieces;
constraint (nvalue(q[PIECES,2] ++ [ q[i,2] + (L[i, 2]*(1-rot[i]) + (L[i, 1]*rot[i])) | i in PIECES ])) <= n_pieces;

ann: search_ann;
%TEST 1: don't use search_ann, comment it.

%TEST 2
%search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], input_order, indomain_min);     %comment this line to use the basic search
%search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], first_fail, indomain_min);      %comment this line to use the basic search
search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], dom_w_deg, indomain_min);        % BEST - comment this line to use the basic search
%search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], input_order, indomain_random);  %comment this line to use the basic search
%search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], first_fail, indomain_random);   %comment this line to use the basic search
%search_ann = int_search( [q[i,1] | i in pieces_ordering_indexes], dom_w_deg, indomain_random);    %comment this line to use the basic search

solve :: search_ann  
      satisfy;
      
output %[ show(index_largest_p)] ++ ["\n"] ++
       [ show_int(3,pieces_ordering_indexes[i]) ++ " " | i in PIECES ] ++ ["\n"] ++
       [ show_int(3,q[i,1]) ++ " " | i in PIECES ] ++ ["\n"] ++
       [ show_int(3,q[i,2]) ++ " " | i in PIECES ] ++ ["\n"] ++ [ show_int(3,rot[i]) ++ " " | i in PIECES ];