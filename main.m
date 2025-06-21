function userInput()
    fprintf('\n1 - Mixed LCG\n');
    fprintf('2 - Cumulative LCG\n');
    fprintf('3 - Multiplicative LCG\n');

    LCGTypeInput = input('Choose the number for the random number generator: ');
    while (LCGTypeInput ~= 1 && LCGTypeInput ~= 2 && LCGTypeInput ~= 3)
        disp('Invalid Input');
        LCGTypeInput = input('Choose again: ');
    end

    VehiclesAmountInput = input('Input the amount of vehicles for the simulation: ');

    fprintf('\n1 - Non Peak Hour\n');
    fprintf('2 - Peak Hour\n');
    HourModeInput = input('Choose the hour mode you prefer: ');
    while (HourModeInput ~= 1 && HourModeInput ~= 2)
        disp('Invalid Input, please try again');
        HourModeInput = input('Choose again: ');
    end

    seed = 123;
    cumSum = 0;
    current_time = 0;
    petrolData = PetrolType();  % Display and store petrol info

    for i = 1:VehiclesAmountInput
        if LCGTypeInput == 1
            [r, seed] = MixedLCG(seed);
        elseif LCGTypeInput == 2
            [r, seed, cumSum] = CumulativeLCG(seed, cumSum);
        else
            [r, seed] = MultiplicativeLCG(seed);
        end

        rand_num = round(r * 100);
        if rand_num == 0
            rand_num = 1;
        end

        % Interarrival Time
        isPeak = HourModeInput == 2;
        data = interarrival_time(rand_num , isPeak);
        for j = 1:length(data.arrival_time)
            if rand_num >= data.lowerbound(j) && rand_num <= data.upperbound(j)
                inter_time = data.arrival_time(j);
                prob = data.probability(j);
                break;
            end
        end

        refuel_time = RefuelingTime(rand_num);

        % Petrol Type Assignment (CORRECTED)
        for k = 1:length(petrolData.petrol)
            lb = petrolData.range((k - 1) * 2 + 1);
            ub = petrolData.range((k - 1) * 2 + 2);
            if rand_num >= lb && rand_num <= ub
                chosenPetrol = petrolData.petrol{k};
                chosenPrice = petrolData.price(k);
                break;
            end
        end

        current_time = current_time + inter_time;

        cars(i).name = ['Car ' num2str(i)];
        cars(i).random_number = rand_num;
        cars(i).interarrival_time = inter_time;
        cars(i).arrival_clock = current_time;
        cars(i).refuel_time = refuel_time;
        cars(i).probability = prob;
        cars(i).petrol_type = chosenPetrol;
        cars(i).price_per_litre = chosenPrice;
    end

    % Display results
    fprintf('\n%-6s | %-6s | %-15s | %-13s | %-12s | %-10s | %-12s | %-5s\n', ...
        'Name', 'Rand #', 'Interarrival Time', 'Arrival Clock', ...
        'Refuel Time', 'Prob', 'Petrol Type', 'Price');
    fprintf('%s\n', repmat('-', 1, 110));
    for i = 1:VehiclesAmountInput
        fprintf('%-6s | %-6d | %-15d | %-13d | %-12d | %-10.2f | %-12s | %.2f\n', ...
            cars(i).name, cars(i).random_number, ...
            cars(i).interarrival_time, cars(i).arrival_clock, ...
            cars(i).refuel_time, cars(i).probability, ...
            cars(i).petrol_type, cars(i).price_per_litre);
    end
end



















                  
     







    
