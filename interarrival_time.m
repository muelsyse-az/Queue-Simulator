function output = interarrival_time()
    output.arrival_time = [ 1 2 3 4 5 6 7 8 9 10 ];
    output.probability = [0.2 0.18 0.16 0.12 0.10 0.08 0.06 0.04 0.03 0.03];
    output.CDF         = [0.20 0.38 0.54 0.66 0.76 0.84 0.9 0.94 0.97 1.00];
    output.lowerbound  = [0 , 21 , 39 , 55 , 67 ,77 , 85, 91 , 95 , 98];
    output.upperbound = [20 , 38 , 54 , 66 , 78 , 84 , 90 ,94 ,97, 100];
    
    
    printf('\n%20s %15s %10s %25s\n', 'Interarrival Time', 'Probability', 'CDF', 'Random Number Range');
    printf('%s\n', repmat('-', 1, 75));

    for i = 1:length(output.arrival_time)
        lb = output.lowerbound(i);
        ub = output.upperbound(i);
        printf('%20d %15.2f %10.2f %12d - %3d\n', output.arrival_time(i), output.probability(i), output.CDF(i), lb, ub);
    end
end


