% Simulate a 5* pull programmatically (less efficient)
% For reference purposes.
% This is commented out in the main code.

function rolls = ppull(p, pr)
	rolls = 0;
	n = 0;
	
	while n < 1
		r = rand();
		rolls = rolls + 1;
		if rolls < 76 % p
			if r < p % Rolled a 5-star
				n = 1;
			end
		elseif rolls < 90 % pr
			if r < pr % Rolled a 5-star
				n = 1;
			end
		else
			n = 1; % Guaranteed @ 90 pulls
		end
	end
