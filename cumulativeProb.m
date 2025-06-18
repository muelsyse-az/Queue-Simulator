function output = cumulativeProb(x)
    n = length(probability);
    
    cumulative =zeros(1,n);
    cumulative(1)=probability(1);
    
    
    for (i=2:n)
        cumulative(i) = cumulative(i-1)probability(i);
    end
    
    output = cumulative;