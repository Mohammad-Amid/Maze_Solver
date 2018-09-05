function [action] = policy_ac(num_ac)%number of action

    if num_ac == 1
        action = 'N';
    elseif num_ac == 2
        action = 'E';
    elseif num_ac == 3
        action = 'S';
    elseif num_ac == 4
        action = 'W';
    end

end