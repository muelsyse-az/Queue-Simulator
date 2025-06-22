function output = RefuelingTime(rand_num)
    % Yeah this should be pretty realistic.
    % Though there's probably instances where someone takes >10mins because
    % they're washing their windshield or something LOL
    rt.time = [4 5 6 7 8 9];
    rt.probability = [0.10 0.20 0.25 0.25 0.15 0.05];

    cdf = cumsum(rt.probability);  % [0.10 0.20 0.40 0.70 1.00]

    % Optional: Display table only once if needed
    fprintf('--------------------------------------------------------------------|\n');
    fprintf('|Refueling Time  |Probability  |CDF         |   Random Number Range |\n');
    fprintf('--------------------------------------------------------------------|\n');

    startRange = 1;
    for i = 1:length(rt.time)
        endRange = round(cdf(i) * 100);
        fprintf('|%-16d|%-13.2f|%-12.2f|   %3d - %-14d|\n', ...
            rt.time(i), rt.probability(i), cdf(i), startRange, endRange);
        startRange = endRange + 1;
    end
    fprintf('--------------------------------------------------------------------|\n');    %line(12-19)for loop to dynamically create and fill table

    %returns the refueling time based on a random number chosen from 1-100
    r = rand_num / 100;
    idx = find(r <= cdf, 1, 'first');
    output = rt.time(idx);
end


