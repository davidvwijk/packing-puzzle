function [score] = evalBoard(board,H,L,pseudo_time)
% evalBoard: Score the inputted board made up of k collections of puzzle
% pieces
%
%   INPUTS
%       board           (h+3)-by-(l+3) matrix representing orientation of k
%                       collection of puzzle pieces on the board dimensions, plus
%                       additional room for the "gutter"
%       H               y dimension
%       L               x dimension
%       pseudo_time     keeps track of "time"
%
%   OUTPUTS
%       score       	Scalar value evaluating board based on heuristic
% 

%% Max overlap in main space
scalar_main = 1;
maxOverlap = sum(max(board(1:H,1:L)));
overlap_score = scalar_main*(maxOverlap);

%% Zeros in the main board are gaps which are bad
scalar_zeros = 2;
numZeros_main = length(find(board(1:H,1:L) == 0));
zeros_score = scalar_zeros*numZeros_main;

%% Overlap in gutter
scalar_gutter = .5;
maxGutter = sum([max(max(board(H+1:H+3,1:L))),max(max(board(1:H+3,L+1:L+3)))]);
gutter_score = (scalar_gutter*pseudo_time)*(maxGutter)^2;
% gutter_score = (scalar_gutter)*(maxGutter)^2;

%% Reward (ie. negative score) for filled rows
filled_score = 0;
filled_scalar = .05;
full_row = ones(1,L);
for i = 1:H
    if board(i,1:L) == full_row
        filled_score = filled_score + i^2*filled_scalar;
    end
end

%% Sum up and return total score

score = overlap_score + zeros_score + gutter_score - filled_score;

end