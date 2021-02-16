% Simulate a 5* pull mathematically
function rolls = mpull(pset)
	r = rand();
	j = ceil( 1000*r );
	if r < pset(j, 1)
		rolls = pset(j, 2);
	else
		rolls = pset(j+1, 2);
	end
