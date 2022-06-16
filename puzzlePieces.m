function [T_blocks,I_blocks,O_blocks,J_L_blocks,S_Z_blocks] = puzzlePieces()
% puzzlePieces: Will output all the different types of puzzle pieces
% represented as 1's and 0's, taking account all possible reflections or
% rotations
%
%   INPUTS
%
%   OUTPUTS
%       T_blocks       	
%       I_blocks
%       O_blocks
%       J_L_blocks
%       S_Z_blocks

T_base = [1 1 1 0;
    0 1 0 0];

T_blocks = {};
for i = 1:4
    base = zeros(4,4);
    A = rot90(T_base,i);
    base(1:size(A,1),1:size(A,2)) = A;
    if i == 1
        % Row
        a = base;
        a(1,:)=[];
        base = [a; zeros(1,4)];
    end
    if i == 2
        % Column
        a = base;
        a(:,1)=[];
        base = [a zeros(4,1)];
    end
    T_blocks{i} = base;
end

% I block
I_base = [1 1 1 1;
    0 0 0 0];

I_blocks = {};
for i = 1:2
    base = zeros(4,4);
    A = rot90(I_base,i);
    base(1:size(A,1),1:size(A,2)) = A;
    if i == 2
        % Row
        a = base;
        a(1,:)=[];
        base = [a; zeros(1,4)];
    end
    I_blocks{i} = base;
end

% O block
O_blocks = {[1 1 0 0;
    1 1 0 0
    0 0 0 0
    0 0 0 0]};

% J/L block
J_base = [1 1 1 0;
    0 0 1 0];

L_base = [0 0 1 0;
    1 1 1 0];

J_L_blocks = {};
for i = 1:4
    base = zeros(4,4);
    A = rot90(J_base,i);
    base(1:size(A,1),1:size(A,2)) = A;
    if i == 1
        % Row
        a = base;
        a(1,:)=[];
        base = [a; zeros(1,4)];
    end
    if i == 2
        % Column
        a = base;
        a(:,1)=[];
        base = [a zeros(4,1)];
    end
    J_L_blocks{i} = base;
end
for i = 1:4
    base = zeros(4,4);
    A = rot90(L_base,i);
    base(1:size(A,1),1:size(A,2)) = A;
    if i == 1
        % Row
        a = base;
        a(1,:)=[];
        base = [a; zeros(1,4)];
    end
    if i == 2
        % Column
        a = base;
        a(:,1)=[];
        base = [a zeros(4,1)];
    end
    J_L_blocks{end+1} = base;
end

% S/Z block
Z_base = [1 1 0 0;
    0 1 1 0];

S_base = [0 1 1 0;
    1 1 0 0];

S_Z_blocks = {};

for i = 1:2
    base = zeros(4,4);
    A = rot90(Z_base,i);
    base(1:size(A,1),1:size(A,2)) = A;
    if i == 1
        % Row
        a = base;
        a(1,:)=[];
        base = [a; zeros(1,4)];
    end
    if i == 2
        % Column
        a = base;
        a(:,1)=[];
        base = [a zeros(4,1)];
    end
    S_Z_blocks{i} = base;
end
for i = 1:2
    base = zeros(4,4);
    A = rot90(S_base,i);
    base(1:size(A,1),1:size(A,2)) = A;
    if i == 1
        % Row
        a = base;
        a(1,:)=[];
        base = [a; zeros(1,4)];
    end
    if i == 2
        % Column
        a = base;
        a(:,1)=[];
        base = [a zeros(4,1)];
    end
    S_Z_blocks{end+1} = base;
end

end



