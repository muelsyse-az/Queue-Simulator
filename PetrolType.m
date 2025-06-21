function output = PetrolType()
    output.petrol = {'Ron 95', 'Ron 97', 'Dynamic Diesel'};  
    output.probability = [0.30, 0.30, 0.40];
    output.cdf = cumsum(output.probability);  
    output.price = [4.50, 6.50, 7.50];

    output.range = zeros(1, length(output.petrol) * 2);
    lowerbound = 1;

    for i = 1:2:length(output.range)
        idx = (i + 1) / 2;
        output.range(i) = lowerbound;
        output.range(i + 1) = round(output.cdf(idx) * 100);
        lowerbound = output.range(i + 1) + 1;
    end

    fprintf('%s\n', repmat('-', 1, 95));
    fprintf('%-20s %-15s %-10s %-25s %-10s\n', 'Type of Petrol', 'Probability', 'CDF', 'Random Number Range', 'Price/Litre');
    fprintf('%s\n', repmat('-', 1, 95));

    for i = 1:length(output.petrol)
        lower = output.range((i - 1) * 2 + 1);
        upper = output.range((i - 1) * 2 + 2);
        fprintf('%-20s %-15.2f %-10.2f %10d - %-10d %-10.2f\n', ...
            output.petrol{i}, output.probability(i), output.cdf(i), lower, upper, output.price(i));
    end
end


    
    
    