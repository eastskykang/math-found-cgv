clc
close all
clear all

% functions
addpath('functions')

% parameters
threshold = 3;  % 3 px

% visualization 
padding = 10;

% debug
debug = false;

%% DATA LOAD
disp('===================================================================')
disp('data loading...')

addpath('data');
load('data/ListInputPoints.mat', 'ListInputPoints');

% correspondences
p_left = ListInputPoints(:, 1:2);
p_right = ListInputPoints(:, 3:4);

n = size(p_left, 1);

% images
img_left = imread('data/InputLeftImage.png');
img_right = imread('data/InputRightImage.png');

[img_left_h, img_left_w, ~] = size(img_left);
[img_right_h, img_right_w, ~] = size(img_right);

%% DEFINE P0  
disp('===================================================================')
disp('defining P0...')

% make P0 problem
P0 = NewProblem([-img_left_w, -img_left_h], [img_left_w, img_left_h]);

% solve P0 problem
P0 = SolveWithLP(p_left, p_right, P0, threshold);
disp('P0: ')
disp(P0)

% list of problems (stack);
problem_stack = zeros(1, 0);
problem_stack = PushToStack(problem_stack, P0);

% upper and lower bound found by iteration
optimal_inlier = [inf, -inf];
optimal_solution = zeros(1, 2);

% record update history (optimal_solution, iteration_solution)
if debug 
    optimal_inlier_history = zeros(0, 4);
else 
    optimal_inlier_history = zeros(0, 2);
end

%% BRANCH AND BOUND (WITH DFS)

% finding global optimal solution! 
% i.e. iteration until empty stack, not convergence
disp('===================================================================')
disp('branch and bound...')

while(size(problem_stack, 2) > 0) 
    % depth first search
    
    % find the best candidate and remove it from the stack 
    % i.e. pop from stack
    [P_parent, problem_stack] = PopFromStack(problem_stack, debug);
    
    % P_parent obviously doesnot contain optimum in this case
    if P_parent.ObjUpperBound < optimal_inlier(2)
        % P_parent.ObjUpperBound < m* (lower bound of optimum)
        continue;
    end
    
    % update optima 
    if P_parent.ObjLowerBound >= optimal_inlier(2) 
        % updated (P_parent's optimal solution is better)
        optimal_inlier = [P_parent.ObjUpperBound, P_parent.ObjLowerBound];
        optimal_solution = P_parent.ThetaOptimizer;
    end
    
    % record to optimal history
    optimal_inlier_history = SaveOptHistory(optimal_inlier_history, P_parent, optimal_inlier, debug);

    %  if number of inlier converged, not terminate but continue to next
    %  iteration.
    if P_parent.ObjUpperBound - P_parent.ObjLowerBound < 1
        continue;
    end 
    
    % branch (split) 
    [P_left_child, P_right_child] = SplitProblem(P_parent);
    
    % compute child's cardinality by linear programming
    % left child
    P_left_child = SolveWithLP(p_left, p_right, P_left_child, threshold);
    
    % right child
    P_right_child = SolveWithLP(p_left, p_right, P_right_child, threshold);
    
    if debug
        disp('push left child: ')
        disp(P_left_child)
        disp('push right child: ')
        disp(P_right_child)
    end
    
    % who is a better candidate, left child? or right child?
    [P_better, P_worse] = FindBestCandidate([P_left_child, P_right_child]);
    
    % push worse candidate to stack
    problem_stack = PushToStack(problem_stack, P_worse);
    
    % push better candidate to stack
    problem_stack = PushToStack(problem_stack, P_better);
end

%% OPTIMAL SOLUTION
disp('===================================================================')
disp('optimal solution:')

assert(optimal_inlier(1) - optimal_inlier(2) < 1)

disp(['Tx = ', num2str(optimal_solution(1))])
disp(['Ty = ', num2str(optimal_solution(2))])
disp(['# of inlier = ( ', num2str(optimal_inlier(1)),...
    ', ', num2str(optimal_inlier(2)), ' )'])

% find inliers by optimal Tx, Ty
inlier_mask = FindInliers(p_left, p_right, optimal_solution(1), optimal_solution(2), threshold);

inliers_left = p_left(inlier_mask, :);
inliers_right = p_right(inlier_mask, :);

outliers_left = p_left(~inlier_mask, :);
outliers_right = p_right(~inlier_mask, :);

if(debug)
    % index of inliers 
    disp('mask of inliers = ')
    disp(inlier_mask);
end

%% VISUALIZATION
% figure 1
disp('===================================================================')
disp('visualizing...')
VisualizeMatch(padding, img_left, img_right, p_left, p_right, ...
    inliers_left, inliers_right, outliers_left, outliers_right);

% figure 2
figure(2)
% upper bound
plot(optimal_inlier_history(:, 1), '.r-')
hold on 
% lower bound
plot(optimal_inlier_history(:, 2), '.b-')
hold off
xlabel('Iterations') 
ylabel('Upper and loewr bounds')
legend('upper', 'lower')