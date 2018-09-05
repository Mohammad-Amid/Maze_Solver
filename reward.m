function [r] = reward(state,action,goal,s)


if(s == 5)
               if any(sigma(state,action,s) == goal)
                   r = 100;
               else
                   r = 0;
               end
           
elseif(s == 25)
       if any(sigma(state,action,s) == goal)
           r = 100;
       else
           r = 0;
       end
end



end


