%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Genshin Impact Gacha Statistics (by Efficacy28)
%
% This program uses Monte Carlo simulations. The tables shown on Reddit use
% 1 billion samples (1e9).
%
% Assumptions:  p = 0.6% from 1 <= n <= 75
%              pr = 32.4% (soft pity) from 76 <= n <= 89
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;clc;

%*** Inputs ***
	nsim = 1e9; % Number of simulations (Monte Carlo)
	f = true; % false for any 5*, true for featured 5*
	c = 2; % Constellation (0 for C0, 6 for C6)
	nr = 50; % Success in the next 'nr' amount of pulls

% Initialization
	if c < 0
		error('Unable to obtain statistics for less than one 5* pulls')
	end
	trials = zeros(nsim, 1);
	[p, pr] = deal(0.006, 0.324); % Without pity, with soft pity
	[q, qr] = deal(1-p, 1-pr);
	pset = r_icdf(q, qr); % For simulating a 5* pull mathematically

% Simulation start
	parfor i = 1:nsim % Parallel for loop
		tot = 0;
		n = 0; % Number of 5* pulled
		isG = false; % Is the next 5* a guaranteed featured?

		while n <= c
			% Programmatic 5* pull simulation (not recommended)
				%rolls = ppull(p, pr);

			% Mathematical 5* pull simulation (same as above but more efficient)
				rolls = mpull(pset);

			if ~f || isG || rand() < 0.5 % Guaranteed or Won 50/50
				n = n + 1; % Successful 5* pull
				isG = false;
			else % Lost 50/50
				isG = true; % Next 5* is a guaranteed featured
			end
			tot = tot + rolls;
		end
		trials(i) = tot;
	end

sim_icdf = sort(trials);

% Summary values
fprintf('Summary values\n')
for p = [5 10 20 30 40 50 60 70 80 90 95 99]
	fprintf('%d%%: %d rolls\n', p, sim_icdf(nsim*p/100))
end

% Live values
fprintf('\nLive values\n')
fprintf('0 rolls: %.2f%%\n', 100*(find(sim_icdf==nr,1,'last'))/nsim )
for x = nr:nr:((1+c)*90*(1+f)-nr-1)
	% Given x rolls, probability to pull within the next 'nr' rolls
	% (CDF(x+nr)-CDF(x)) / (1 - CDF(x))
	[~, loc1] = builtin('_ismemberhelper',x+nr+1,sim_icdf); % Binary search
	[~, loc2] = builtin('_ismemberhelper',x+1,sim_icdf);
	loc1 = loc1 - 1; % CDF(x+nr) not normalized
	loc2 = loc2 - 1; % CDF(x) not normalized
	fprintf('%d rolls: %.2f%%\n', x, 100*(loc1-loc2)/(nsim-loc2) )
end
fprintf('%d rolls: 100%%\n', (1+c)*90*(1+f)-nr)
