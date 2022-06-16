function [successors] = getSuccessors(piece,All_blocks,H,L)
% getSuccessors: Will return valid sucessors given a piece and location
%
%   INPUTS
%     piece           (1-by-4) cell with (x,y) grid location and (4-by-4)   
%                     matrix for piece representation, idx corresponding to
%                     the type of piece (ie. T,O,etc) and orientation idx
%                     corresponding to the orientation of type of piece
%
%     All_blocks
%           
%     H
%   
%     L
%
%   OUTPUTS
%                     (1-by-5) cell array containing 5 new sucessors of the
%                     inputted piece, with each cell containing a (1-by-4) 
%                     cell with (x,y) grid location and (4-by-4)   
%                     matrix for piece representation, idx corresponding to
%                     the type of piece (ie. T,O,etc) and orientation idx
%                     corresponding to the orientation of type of piece
%
% Performs check to see what x, y translation moves are valid
% (i.e. moves on edges of board are restricted)

grid_location = piece{1,1};
pieceIdx = piece{1,3};
orientationIdx = piece{1,4};

successors = cell(1,5);

% Change the grid location only
% Jump sizes based on grid size
max_step = (H*L)/20;
step = [1 max_step];
gridChanges = [0 randi(step,1,1);randi(step,1,1) 0;0 -randi(step,1,1);-randi(step,1,1) 0];

for i = 1:4
    successors{1,i} = piece;
    newGridLoc = grid_location + gridChanges(i,:);
    % Check x 
    if newGridLoc(1) <= 0
        newGridLoc(1) = 1;
    elseif newGridLoc(1) > L
        newGridLoc(1) = L;
    end
    % Check y 
    if newGridLoc(2) <= 0
        newGridLoc(2) = 1;
    elseif newGridLoc(2) > H
        newGridLoc(2) = H;
    end
    
    successors{1,i}{1,1} = newGridLoc;
end

% Cycle through possible orientations
successors{1,5} = piece;
newOrientationIdx = orientationIdx + 1;

if size(All_blocks{1,pieceIdx},2) < newOrientationIdx
    newOrientationIdx = 1;
end
successors{1,5}{1,2} = All_blocks{1,pieceIdx}{1,newOrientationIdx};

end