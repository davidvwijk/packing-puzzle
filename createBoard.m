function [board] = createBoard(pieces,H,L)
% createBoard: Given k collections of pieces and (x,y) locations, will generate a
% board which will be a (h+3)-by-(l+3) matrix
%
%   INPUTS
%     pieces          (1-by-k*5) cell array, with each cell containing a
%                     (1-by-2) cell with (x,y) grid location and (4-by-4)   
%                     matrix for piece representation
%
%   OUTPUTS
%     board           (h+3)-by-(l+3) matrix representing orientation of k
%                       collection of puzzle pieces on the board dimensions, plus
%                       additional room for the "gutter"

board = zeros(H+3,L+3);

for i = 1:size(pieces,2)
    piece = pieces{1,i}{1,2};
    grid_location = pieces{1,i}{1,1};
    
    board(grid_location(2):grid_location(2)+3, grid_location(1):grid_location(1)+3)...
        = board(grid_location(2):grid_location(2)+3, grid_location(1):grid_location(1)+3) + piece;
end

end