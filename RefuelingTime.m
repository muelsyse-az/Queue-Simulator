function output = RefuelingTime(r)
    rt.time = [2 3 4 5 6];
    rt.probability = [0.10 0.10 0.20 0.30 0.30];
    
    cdf = cumsum(rt.probability);  % [0.10 0.20 0.40 0.70 1.00]
    
    printf('--------------------------------------------------------------------|\n');
    printf('|Refueling Time  |Probability  |CDF         |   Random Number Range |\n');
    printf('--------------------------------------------------------------------|\n');
    
    startRange = 1;
    for i = 1:length(rt.time)
        endRange = round(cdf(i) * 100);
        printf('|%-16d|%-13.2f|%-12.2f|   %3d - %-14d|\n', ...
            rt.time(i), rt.probability(i), cdf(i), startRange, endRange);
        startRange = endRange + 1;
    end
    printf('--------------------------------------------------------------------|\n');
    
    r_norm = r / 100;
    
    % Find first index where r_norm <= cdf(i)
    idx = find(r_norm <= cdf, 1, 'first');
    
    output = rt.time(idx);
    
end
