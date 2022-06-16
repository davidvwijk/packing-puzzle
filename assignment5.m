%% Programming Assignment 5: Packing Puzzle
% CSCE625: Artificial Intelligence
% David van Wijk

%% Puzzle Piece Representation
% Represent pieces and all possible rotations using 4x4 matrices using 1's
% and 0's. Take rotations and reflections into account

[T_blocks,I_blocks,O_blocks,J_L_blocks,S_Z_blocks] = puzzlePieces();
All_blocks = {T_blocks,I_blocks,O_blocks,J_L_blocks,S_Z_blocks};

%% Local Beam Search Algorithm
% Local search is not required to solve the problem - we can show that a 
% packing solution exists if [k is even] AND [(H >= 3) AND (L >= 3)]
%
% Use local beam search to determine if pieces can be packed within given
% dimensions. Actions are for each block type, can select the type of variation
% of block (ie. rotated, translated etc) or the (x,y) location on the

H = input('Please enter the vertical dimension, H: ');
L = input('Please enter the horizontal dimension, L: ');
k = (H*L)/20;
k_beam = 50;
pseudo_time = 0;

% How many times in a row we can repeat min score before random restart
max_repeated_min_count = 30; 

% Timeout in seconds
maxTime = 60*2.5; 
tic

base_board = zeros(H+3,L+3);
base_board(1:H,1:L)=ones(H,L);
[end_score] = evalBoard(base_board,H,L,pseudo_time);

% We know there is a solution if it enters this loop
if (mod(k,2) == 0) && ((H >= 3) && (L >= 3))
    disp('A solution exists! Trying to find it via beam search...')
    % Intialize k_beam collections randomly
    
    % Each collection represents k sets of puzzle pieces (ie. k*5 pieces)
    % Each collection has a score associated with it (2nd row)
    k_beam_collections = cell(2,k_beam);
    for z = 1:k_beam
        % Contains a bunch of pieces and their (x,y) grid locations
        collection = {};
        % For k collections of pieces
        for i = 1:k
            % For each type of piece
            for j = 1:size(All_blocks,2)
                % Pick location on the grid that each piece will have
                grid_location = [randi([1 L],1,1),randi([1 H],1,1)];
                % Pick orientation for each piece
                num_orientations = size(All_blocks{1,j},2);
                orientation_idx = randi([1 num_orientations],1,1);
                piece = All_blocks{1,j}{1,orientation_idx};
                piece_idx = j;
                rand_piece_mtrx = {grid_location,piece,piece_idx,orientation_idx};
                collection{end+1} = rand_piece_mtrx;
            end
        end
        k_beam_collections{1,z} = collection;
        [board] = createBoard(collection,H,L);
        [score] = evalBoard(board,H,L,pseudo_time);
        k_beam_collections{2,z} = score;
    end
    
    % Perform local beam search
    % We will generate k_beam*(5*k)*5 successors in each iteration
    
    totalSuccessors = cell(2,k_beam*(5*k)*5);
    doRun = 1;
    last_best_score = 999;
    count_repeated_sc = 0;
    
    while doRun == 1 && toc < maxTime
        
        % For each beam
        for z = 1:k_beam
            
            % Get 5 successors for each piece in each collection
            for i = 1:size(k_beam_collections{1,z},2)
                
                collection = k_beam_collections{1,z};
                scores = zeros(1,5);
                
                % Get the piece information
                piece2Change = collection{1,i};
                [successors] = getSuccessors(piece2Change,All_blocks,H,L);
                successor_collections = cell(1,5);
                for j = 1:size(successors,2)
                    collection{1,i} = successors{1,j};
                    successor_collections{1,j} = collection;
                    [board] = createBoard(collection,H,L);
                    [score] = evalBoard(board,H,L,pseudo_time);
                    
                    % End condition!
                    if score == end_score
                        disp(['Solution found in ' num2str(pseudo_time) ' beam iterations'])
                        doRun = 0;
                        break
                    end
                    
                    scores(1,j) = score;
                end
                
                piece_idx = 5*k*(z-1)*5 + (5*i)-4;
                piece_idx_next = 5*k*(z-1)*5 + 5*i;
                
                totalSuccessors(1,piece_idx:piece_idx_next) = successor_collections;
                totalSuccessors(2,piece_idx:piece_idx_next) = num2cell(scores);
            end
            
        end
        
        % STOCHASTIC BEAM SEARCH
        % chooses k successors at random, with the probability of choosing
        % a given successor being an increasing function of its value
        
        % Random selection by percentage -- not scaled
        rand_prop = .9-(.01)*pseudo_time;
        if rand_prop < .1
            rand_prop = .1;
        end
        rand_beams = floor(k_beam*rand_prop);
        greedy_beams = k_beam-rand_beams;
        
        scores = cell2mat(totalSuccessors(2,:));
        [sorted_scores,sorted_idxs] = sort(scores,'ascend');
        
        % Get k_beam*(1-rand_prop) best collections
        selected_greedy_scores = 9999*ones(1,greedy_beams);
        for i = 1:greedy_beams
            for j = 1:size(sorted_scores,2)
                idx = sorted_idxs(j);
                value = sorted_scores(j);
                if ~ismember(value,selected_greedy_scores)
                    break
                end
            end
            selected_greedy_scores(1,i) = value;
            k_beam_collections{1,i} = totalSuccessors{1,idx};
            k_beam_collections{2,i} = value;
        end
        for i = (greedy_beams+1):k_beam
            idx = randi([1 size(totalSuccessors,2)],1,1);
            k_beam_collections{1,i} = totalSuccessors{1,idx};
            k_beam_collections{2,i} = totalSuccessors{2,idx};
        end
        
        % For testing only:
        [board] = createBoard(k_beam_collections{1,1},H,L);
        
        min_score = min(scores);
        if min_score == last_best_score
            count_repeated_sc = count_repeated_sc + 1;
        else
            count_repeated_sc = 0;
            last_best_score = min_score;
        end
        
        % RANDOM RESTART -- get k_beam new random beams
        if count_repeated_sc > max_repeated_min_count
            [board] = createBoard(k_beam_collections{1,1},H,L);
            disp(['Beam is stuck at score of ' num2str(min_score) '... randomly restarting'])
            for z = 1:k_beam
                % Contains a bunch of pieces and their (x,y) grid locations
                collection = {};
                % For k collections of pieces
                for i = 1:k
                    % For each type of piece
                    for j = 1:size(All_blocks,2)
                        % Pick location on the grid that each piece will have
                        grid_location = [randi([1 L],1,1),randi([1 H],1,1)];
                        % Pick orientation for each piece
                        num_orientations = size(All_blocks{1,j},2);
                        orientation_idx = randi([1 num_orientations],1,1);
                        piece = All_blocks{1,j}{1,orientation_idx};
                        piece_idx = j;
                        rand_piece_mtrx = {grid_location,piece,piece_idx,orientation_idx};
                        collection{end+1} = rand_piece_mtrx;
                    end
                end
                k_beam_collections{1,z} = collection;
                [board] = createBoard(collection,H,L);
                [score] = evalBoard(board,H,L,pseudo_time);
                k_beam_collections{2,z} = score;
            end
            pseudo_time = 0;
        end
        
        % Keep a pseudo-time (ie. iteration count)
        pseudo_time = pseudo_time + 1;
    end
else
    disp("No solution possible")
end

if toc > maxTime
    disp(['A solution is possible for this board! However, local search timed out after ' int2str(toc/60) ' (min)'])
end