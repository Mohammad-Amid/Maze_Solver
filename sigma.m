function [state] = sigma(state,action,s)



if(action == 'N')
    state = state - 1;
elseif(action == 'S')
    state = state + 1;
elseif(action == 'E')
    state = state + s;
elseif(action == 'W')
    state = state - s;
end


end

