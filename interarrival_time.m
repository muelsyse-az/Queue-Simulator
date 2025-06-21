
function output = interarrival_time(rand_num , isPeak)
disp('Running updated interarrival_time function...');

    if isPeak
        output.arrival_time = [1 2 3 4 5 6 7 8 9 10];
        output.probability  = [0.20 0.18 0.16 0.12 0.10 0.08 0.06 0.04 0.03 0.03];
        output.CDF          = [0.20 0.38 0.54 0.66 0.76 0.84 0.90 0.94 0.97 1.00];
        output.lowerbound   = [0, 21, 39, 55, 67, 77, 85, 91, 95, 98];
        output.upperbound   = [20, 38, 54, 66, 76, 84, 90, 94, 97, 100];
    else
        output.arrival_time = [2 3 4 5 6 7 8 9 10 11];
        output.probability  = [0.10 0.15 0.20 0.18 0.12 0.10 0.08 0.04 0.02 0.01];
        output.CDF          = [0.10 0.25 0.45 0.63 0.75 0.85 0.93 0.97 0.99 1.00];
        output.lowerbound   = [0, 11, 26, 46, 64, 76, 86, 94, 98, 100];
        output.upperbound   = [10, 25, 45, 63, 75, 85, 93, 97, 99, 100];
    end

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



