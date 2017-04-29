addpath(genpath('GraphCut'));

%% BUILD GRAPH
disp('-------------------------------------------------------------------')
disp('creating handle for 5 nodes')

% graph with 3 nodes, 1 source and 1 sink
h = BK_Create(3);

% unary cost
disp('-------------------------------------------------------------------')
disp('assign unary cost for source and sink : ')

costs = [ ...
    4   7   8;      % label1 (to source)
    9   7   5];     % label2 (to sink)

disp(costs)
BK_SetUnary(h, costs);

% edge weight matrix
disp('-------------------------------------------------------------------')
disp('edge weight matrix : ')

edge_mat = [ ...
    0   3   0;  % from node 1
    2   0   5;  % from node 2  
    0   1   0]; % from node 3

disp(edge_mat)
disp('(0 for no edge)')

edges = ConvertEdgeMat(edge_mat);
BK_SetPairwise(h, edges);

%% OPTIMAL LABEL
energy = BK_Minimize(h);
disp('-------------------------------------------------------------------')
disp(['energy : ', num2str(energy)])

disp('labels : ')
labeling = BK_GetLabeling(h);

disp(labeling)
disp('(each row for each node)')

%% DEALLOC HANDLE
disp('-------------------------------------------------------------------')
disp('dealloc handle')
BK_Delete(h);

% convert graph edge weight matrix to SetPairwise input form
function D = ConvertEdgeMat(S)
    [i,j,s] = find(S);
    z = zeros(size(s,1),1);
    D = [i,j,z,s,z,z];  % [i,j,e00,e01,e10,e11]
end