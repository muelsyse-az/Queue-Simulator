function output = interarrival_time(rand_num , isPeak)
    disp('Running updated interarrival_time function...');

    if isPeak
        % Favor longer interarrival times
        output.arrival_time = [1 2 3 4 5 6 7 8 9 10];
        output.probability  = [0.05 0.05 0.08 0.10 0.12 0.15 0.15 0.12 0.10 0.08];
    else
        output.arrival_time = [2 3 4 5 6 7 8 9 10 11];
        output.probability  = [0.05 0.05 0.08 0.10 0.12 0.15 0.15 0.12 0.10 0.08];
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

