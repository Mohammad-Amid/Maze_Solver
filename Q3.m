fileid = fopen('maze_25.txt','r');
A = fscanf(fileid,'%u');
s = A(1); %size of matrix
if s == 5
    start = A(103);
    goal = A(104:end);
    A = A(3:102);
    B = reshape(A,[4,25]);
    B = B';
elseif s == 25
    start = A(2503);
    goal = A(2504:end);
    A = A(3:2502);
    B = reshape(A,[4,625]);
    B = B';
end

Q_table = zeros(s*s*4,1);
gama = 0.5;
policy = zeros(s*s,1);
current_state =  randi([1 s*s],1);
maxiter = 400000;
g = 0;
h = 1;
ka = 0.5;
kaa = zeros(4,1);
aa =0;
kk = zeros(s*s*4);
z = 0;
for i = 0:maxiter 
    %ka = ka + 1;
    if i>250000
        ka = 10;
    end
    if(any(current_state == goal))
        if(h~=1)% if the first guess was goal then ignore it
            for u = 1:h-1
                Q_table(w(1,u)) = w(2,u);
            end
            h = 1;
        end
        %current_state =  randi([1 s*s],1);
        %action = randi([1 s*s*4],1);
        if i ~=0
            for y = 1 : s*s*4
                aa = aa + ka^Q_table((current_state-1)*4+y);
            end
            for y = 1 : s*s*4
                kk(y) =  ka^Q_table((current_state-1)*4+y)/aa;
            end
            random_num =(2*eps)*floor(rand/(2*eps));
            for y = 0 : s*s*4
                if (z<= random_num) && (random_num<z+kk(y+1))
                    action = rem(y,4);
                    current_state = round(y/4);
                end
                if y == 0
                    y = 1;
                end
                z = z + kk(y);
            end
        else
        action = randi([1 4],1);
        end
    else
        if i == 0
            action = randi([1 4],1);
        end
        if(B(current_state,action))
                    w(1,h) = ((current_state - 1)*4) + action;
                    w(2,h) = reward(current_state,policy_ac(action),goal,s) + ...
                    gama*max(Q_table(((sigma(current_state,policy_ac(action),s)-1)*4 + 1):((sigma(current_state,policy_ac(action),s)-1)*4)+ 4));
                    current_state = sigma(current_state,policy_ac(action),s);
                    h = h + 1;
        elseif (g>2000)% if its not good episode and we are not gonaa achive goal
                    %current_state =  randi([1 s*s],1);
                    for y = 1 : s*s*4
                        aa = aa + ka^Q_table(y);
                    end
                    for y = 1 : s*s*4
                        kk(y) =  ka^Q_table(y)/aa;
                    end
                    random_num =(2*eps)*floor(rand/(2*eps));
                    for y = 0 : s*s*4
                        if (z<= random_num) && (random_num<z+kk(y+1))
                            action = rem(y,4);
                            current_state = round(y/4);
                        end
                        if y == 0
                            y = 1;
                        end
                        z = z + kk(y);
                    end
                    g  = 0;
                    h = 1;
        else
                    g = g + 1;
        end
    end
end

for i = 1:s*s
   [~, policy(i)] = max(Q_table((i-1)*4+1:(i-1)*4+4));
end
current_state = start;
i = 1;
while ~(any(current_state == goal))
    p(i) = current_state;
    fprintf('%i->',current_state);
    if policy(current_state) == 1
        next = current_state - 1;
    elseif(policy(current_state) == 2)
        next = current_state + s;
    elseif(policy(current_state) == 3)
        next = current_state + 1;
    elseif(policy(current_state) == 4)
        next = current_state - s;
    end
    current_state = next;
    i = i + 1;
end
fprintf('%i',current_state);
p(i) = current_state;

% if s == 5
% 
%     % figure's window
%     figure('resize', 'off', 'position', [500 50 350 375]);
% 
%     % white board
%     field_h = annotation('rectangle');
%     set(field_h, 'units', 'pixels', 'position', [50,20,250,250],...
%         'color', [0 0 0], 'facecolor', 'white');
% 
% for A=1:4
%     a_h = annotation('line');
%     set(a_h, 'units', 'pixels', 'position',[50 20+50*A 250 0 ] );
% end
% 
% for A=1:4
%     a_h = annotation('line');
%     set(a_h, 'units', 'pixels', 'position',[50+A*50 20 0 250 ] );
% end
% 
%     %horizental line
%     n = -1;
%     m = 0;
%     for a=1:25
%            n = n+1;
%            if B(a,1) == 0 
%              a_h = annotation('line', 'LineWidth', 3);
%              set(a_h, 'units', 'pixels', 'position',[50+50*(m) 270-50*(n) 50 0 ] );
%            end
%            if B(a,3) == 0 
%              a_h = annotation('line', 'LineWidth', 3);
%              set(a_h, 'units', 'pixels', 'position',[50+50*(m) 220-50*(n) 50 0 ] );
%            end
%            if rem(a,5) == 0 
%                n = -1;
%                m = m + 1;
%            end
%     end
% 
%     % vertical line
%     n = -1;
%     m = 0;
%     for a=1:25
%            n = n+1;
%            if B(a,2) == 0 
%             a_h = annotation('line', 'LineWidth', 3);
%             set(a_h, 'units', 'pixels', 'position',[50+50*(m+1) 220-50*(n) 0 50 ] );
%            end
%            if B(a,4) == 0 
%              a_h = annotation('line', 'LineWidth', 3);
%              set(a_h, 'units', 'pixels', 'position',[50+50*(m) 220-50*(n) 0 50 ] );
%            end
%            if rem(a,5) == 0 
%                n = -1;
%                m = m + 1;
%            end
%     end
% 
%     p = unique(p);
%     
%     %start's location
%     if any(start == [5 10 15 20 25])
%         cell_h = annotation('rectangle');
%         set(cell_h, 'units', 'pixels', 'position', [66+50*(fix(start/5)-1),35+50*(0),20,20],...
%         'color', [0 1 0], 'facecolor', 'green', 'tag', 'tmpcell');
%     else
%         cell_h = annotation('rectangle');
%         set(cell_h, 'units', 'pixels', 'position', [66+50*(fix(start/5)),35+50*(5 - rem(start,5)),20,20],...
%         'color', [0 1 0], 'facecolor', 'green', 'tag', 'tmpcell');
%     end
%     %goal's location
%     for i = 1 : length(goal)
%         if any(goal(i) == [5 10 15 20 25])
%              cell_h = annotation('rectangle');
%              set(cell_h, 'units', 'pixels', 'position', [66+50*(fix(goal(i)/5)-1),35+50*(0),20,20],...
%              'color', [1 0 0], 'facecolor', 'red', 'tag', 'tmpcell');
%         else
%              cell_h = annotation('rectangle');
%              set(cell_h, 'units', 'pixels', 'position', [66+50*(fix(goal(i)/5)),35+50*(5 - rem(goal(i),5)),20,20],...
%              'color', [1 0 0], 'facecolor', 'red', 'tag', 'tmpcell');
%         end
%     end
%     %path
%     for i = 2 : (length(p) - 1)
%         if any(p(i) == [5 10 15 20 25])
%             cell_h = annotation('rectangle');
%             set(cell_h, 'units', 'pixels', 'position', [66+50*(fix(p(i)/5)-1),35+50*(0),20,20],...
%             'color', [0 0 1], 'facecolor', 'blue', 'tag', 'tmpcell');
%         else
%             cell_h = annotation('rectangle');
%             set(cell_h, 'units', 'pixels', 'position', [66+50*(fix(p(i)/5)),35+50*(5 - rem(p(i+1),5)),20,20],...
%             'color', [0 0 1], 'facecolor', 'blue', 'tag', 'tmpcell');
%         end
%     end
% end
% 
% 
% 
% 
% if s == 25
%     
%     % figure's window
%     figure('resize', 'off', 'position', [320 10 700 700]);
% 
%     % white board
%     field_h = annotation('rectangle');
%     set(field_h, 'units', 'pixels', 'position', [50,20,625,625],...
%         'color', [0 0 0], 'facecolor', 'white');
% 
%     %horizental line             
%     n = -1;
%     m = 0;
%     for a=1:625
%            n = n+1;
%            if B(a,1) == 0 
%              a_h = annotation('line', 'LineWidth', 3);
%              set(a_h, 'units', 'pixels', 'position',[50+25*(m) 645-25*(n) 25 0 ] );
%            end
%            if B(a,3) == 0 
%              a_h = annotation('line', 'LineWidth', 3);
%              set(a_h, 'units', 'pixels', 'position',[50+25*(m) 620-25*(n) 25 0 ] );
%            end
%            if rem(a,25) == 0 
%                n = -1;
%                m = m + 1;
%            end
%     end
% 
% 
%     % vertical line
%     n = -1;
%     m = 0;
%     for a=1:625
%            n = n+1;
%            if B(a,2) == 0 
%             a_h = annotation('line', 'LineWidth', 3);
%             set(a_h, 'units', 'pixels', 'position',[50+25*(m+1) 620-25*(n) 0 25 ] );
%            end
%            if B(a,4) == 0 
%              a_h = annotation('line', 'LineWidth', 3);
%              set(a_h, 'units', 'pixels', 'position',[50+25*(m) 620-25*(n) 0 25 ] );
%            end
%            if rem(a,25) == 0 
%                n = -1;
%                m = m + 1;
%            end
%     end
% for A=1:24
%     a_h = annotation('line');
%     set(a_h, 'units', 'pixels', 'position',[50 20+25*A 625 0 ] );
% end
% 
% for A=1:24
%     a_h = annotation('line');
%     set(a_h, 'units', 'pixels', 'position',[50+A*25 20 0 625 ] );
% end
%      %start's location
%      if any(start==[25 50 75 100 125 150 175 200 225 250 275 300 325 350 375 ...
%             400 425 450 475 500 525 550 575 600 625])
%              cell_h = annotation('rectangle');
%              set(cell_h, 'units', 'pixels', 'position', [58 + 25*(fix(start/25)-1),27 + 25*(0),10,10],...
%             'color', [0 1 0], 'facecolor', 'green', 'tag', 'tmpcell');
%      else
%             cell_h = annotation('rectangle');
%             set(cell_h, 'units', 'pixels', 'position', [58 + 25*(fix(start/25)),27 + 25*(25 - (rem(start,25))),10,10],...
%             'color', [0 1 0], 'facecolor', 'green', 'tag', 'tmpcell');
%      end
%     %goal's location
%     for i = 1 : length(goal)
%         if any(goal(i)==[25 50 75 100 125 150 175 200 225 250 275 300 325 350 375 ...
%                 400 425 450 475 500 525 550 575 600 625])
%              cell_h = annotation('rectangle');
%              set(cell_h, 'units', 'pixels', 'position', [58 + 25*(fix(goal(i)/25)-1),27 + 25*(0),10,10],...
%              'color', [1 0 0], 'facecolor', 'red', 'tag', 'tmpcell');
%         else
%               cell_h = annotation('rectangle');
%               set(cell_h, 'units', 'pixels', 'position', [58 + 25*(fix(goal(i)/25)),27 + 25*(25 - (rem(goal(i),25))),10,10],...
%               'color', [1 0 0], 'facecolor', 'red', 'tag', 'tmpcell');
%         end
%     end
%     %path
%     for i = 2 : length(p)-1
%         if any(p(i)==[25 50 75 100 125 150 175 200 225 250 275 300 325 350 375 ...
%                 400 425 450 475 500 525 550 575 600 625])
%              cell_h = annotation('rectangle');
%              set(cell_h, 'units', 'pixels', 'position', [58 + 25*(fix(p(i)/25)-1),27 + 25*(0),10,10],...
%              'color', [0 0 1], 'facecolor', 'blue', 'tag', 'tmpcell');
%         else
%               cell_h = annotation('rectangle');
%               set(cell_h, 'units', 'pixels', 'position', [58 + 25*(fix(p(i)/25)),27 + 25*(25 - (rem(p(i),25))),10,10],...
%               'color', [0 0 1], 'facecolor', 'blue', 'tag', 'tmpcell');
%         end
%     end
%     
% end