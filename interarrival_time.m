
function output = interarrival_time(rand_num , isPeak)

    if isPeak
        output.arrival_time = [1 2 3 4 5 6 7 8 9 10];
        output.probability  = [0.30 0.25 0.15 0.10 0.07 0.05 0.03 0.025 0.02 0.015];
       
    else
        output.arrival_time = [2 3 4 5 6 7 8 9 10 11];
        output.probability  = [0.15 0.20 0.20 0.15 0.10 0.08 0.06 0.04 0.01 0.01];
       
    end
    
        output.CDF = cumsum(output.probability);
        % Compute lowerbound and upperbound (mapped to 1-100 random numbers)
    output.lowerbound = [1, round(output.CDF(1:end-1) * 100) + 1];
    output.upperbound = round(output.CDF * 100);

    % Display table
    fprintf('\n%20s %15s %10s %25s\n', ...
        'Interarrival Time', 'Probability', 'CDF', 'Random Number Range');
    fprintf('%s\n', repmat('-', 1, 75));
    for i = 1:length(output.arrival_time)
        lb = output.lowerbound(i);
        ub = output.upperbound(i);
        fprintf('%20d %15.2f %10.2f %12d - %3d\n', ...
            output.arrival_time(i), output.probability(i), output.CDF(i), lb, ub);
    end
end



