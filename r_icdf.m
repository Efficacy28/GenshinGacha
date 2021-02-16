% Returns ICDF of an any 5* roll as a discrete 1000x2 array
% ICDF is discretized in 1000 bins to utilize hashing

function icdf = r_icdf(q, qr)
	icdf = zeros(1000, 2);
	
	% Actual ICDF for n rolls
	for n = 1:75
		prob = 1-q^n;
		icdf( ceil(1000*prob), : ) = [prob n];
	end
	for n = 76:89
		prob = 1-q^75*qr^(n-75);
		icdf( ceil(1000*prob), : ) = [prob n];
	end
	icdf(end, :) = [1 90];

	% Interpolate the ICDF to fill 1000
	j_o = 1;
	j = 2;
	for n = 1:90
		while icdf(j, 1) == 0
			j = j + 1;
		end
		icdf(j_o:j, 1) = linspace(icdf(j_o, 1), icdf(j, 1), j-j_o+1)';
		icdf(j_o+1:j, 2) = n;
		j_o = j;
		j = j + 1;
	end
