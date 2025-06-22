function output = interarrival_time(rand_num , isPeak)
    disp('Running updated interarrival_time function...');

if isPeak
    % Peak hours: This should be around 80 cars/hour (1 every 45s). Pretty realistic.
    output.arrival_time = [0.2 0.4 0.6 0.8 1.0 1.2 1.5 2.0 2.5 3.0];
    output.probability  = [0.30 0.25 0.20 0.12 0.08 0.03 0.01 0.005 0.003 0.002];
else
    % Non-peak hours: This should be around 23 cars/hour (1 every few mins). That works.
    output.arrival_time = [1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5 6];
    output.probability  = [0.15 0.20 0.18 0.15 0.12 0.10 0.05 0.03 0.01 0.01];
end

    % Normalize just in case
    output.probability = output.probability / sum(output.probability);

    % Recalculate CDF and random number bounds
    output.CDF = cumsum(output.probability);
    output.lowerbound = [1, round(output.CDF(1:end-1) * 100) + 1];
    output.upperbound = round(output.CDF * 100);

    % Display probability table
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

