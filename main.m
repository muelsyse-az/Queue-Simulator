%================= MAIN FUNCTION =================%
function main()
    clc;
    clear;
    petronas_logo();
    serviceType();
    userInput();
end
%=================================================%


%===================== Petronas Logo =====================%
function petronas_logo()
    fprintf('\n');
    fprintf('             _____              \n');
    fprintf('            /\\   /              \n');
    fprintf('           /  \\ /              \n');
    fprintf('          /    \\               \n');
    fprintf('         / ___  \\              \n');
    fprintf('        |  |  |  |             \n');
    fprintf('        |  |__|  |             \n');
    fprintf('         \\______/              \n\n');
    fprintf('         PETRONAS               \n\n');
    fprintf('Welcome to Petronas!\n');
end


%===================== Service Type Display =====================%
function serviceType()
    fprintf('\nService Type Probability Table\n');
    fprintf('--------------------------------------------------------------------------------------|\n');
    fprintf('|Service Type |Probability  |CDF          |   Random Number Range     | Price/Litre   |\n');
    fprintf('--------------------------------------------------------------------------------------|\n');
    fprintf('|Ron 95       |0.30         |0.30         |       1 - 30              |    4.50       |\n');
    fprintf('|Ron 97       |0.30         |0.60         |      31 - 60              |    6.50       |\n');
    fprintf('|Diesel       |0.40         |1.00         |      61 - 100             |    7.50       |\n');
    fprintf('--------------------------------------------------------------------------------------|\n');
end


%===================== User Input & Simulation =====================%
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
    petrolData = PetrolType();
    pump_end_time = zeros(1,4); %array that holds the end time for island [1,2,3,4]

    for i = 1:VehiclesAmountInput
        % Generate random number
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

        % Interarrival time
        isPeak = HourModeInput == 2;
        data = interarrival_time(rand_num , isPeak);
        for j = 1:length(data.arrival_time)
            if rand_num >= data.lowerbound(j) && rand_num <= data.upperbound(j)
                inter_time = data.arrival_time(j);
                prob = data.probability(j);
                break;
            end
        end

        % Refueling time
        refuel_time = RefuelingTime(rand_num);

        % Petrol type & price
        for k = 1:length(petrolData.petrol)
            lb = petrolData.range((k-1)*2 + 1);
            ub = petrolData.range((k-1)*2 + 2);
            if rand_num >= lb && rand_num <= ub
                chosenPetrol = petrolData.petrol{k};
                chosenPrice = petrolData.price(k);
                break;
            end
        end

        lane = mod(i,2) + 1;

        current_time = current_time + inter_time;

        cars(i).name = ['Car ' num2str(i)];
        cars(i).random_number = rand_num;
        cars(i).interarrival_time = inter_time;
        cars(i).arrival_clock = current_time;
        cars(i).refuel_time = refuel_time;
        cars(i).probability = prob;
        cars(i).petrol_type = chosenPetrol;
        cars(i).price_per_litre = chosenPrice;
        cars(i).lane = lane;
        
        
        %if checks for occupied pumps
        
        if lane == 1
            if current_time >= pump_end_time(2)
                pump = 2;
                
            elseif current_time >= pump_end_time(1)
                pump =1;
            
            else 
                [wait_time , pump] = min(pump_end_time(1:2) - current_time); %get wait time, and the pump island that will be free in the earliest moment
                current_time = current_time + wait_time; 
            end
        
        
        else 
            if current_time >= pump_end_time(4)
                pump = 4;
                
            elseif current_time >= pump_end_time(3)
                pump = 3;
            
            else 
                [wait_time , idx] = min(pump_end_time(3:4) - current_time); %get wait time, and the pump island that will be free in the earliest moment
                pump = idx + 2 %offsets referred pump the either 3 or 4
                current_time = current_time + wait_time; 
            end 
        end
        
        cars(i).pump = pump;
        
        %if else to get time service begins
        if current_time > pump_end_time(pump)
            start_time = current_time;
            
        else
           start_time = pump_end_time(pump);
        end 
        
        end_time = start_time + refuel_time;

        cars(i).service_begin = start_time;
        cars(i).service_end = end_time;
        cars(i).waiting_time = start_time - cars(i).arrival_clock;
        cars(i).time_spent = end_time - cars(i).arrival_clock;

        % Update pump status
        pump_end_time(pump) = end_time;
        
        
                
        
              
        
        
     
        
        
    end
       for i=1:VehiclesAmountInput
           fprintf('\n%s arrived at minute %d and began refueling with %s at Lane %d using Pump %d.\n', ...
           cars(i).name, ....
           cars(i).arrival_clock,...
           cars(i).petrol_type,...
           cars(i).lane,...
           cars(i).pump);
        end

    % Display results
    fprintf('\n%-6s | %-6s | %-15s | %-13s | %-12s | %-10s | %-4s | %-12s | %-6s\n', ...
        'Name', 'Rand ', 'Interarrival Time', 'Arrival Clock', 'Refuel Time', 'Prob','Lane', 'Petrol Type','Price');
    fprintf('%s\n', repmat('-', 1, 120));
    for i = 1:VehiclesAmountInput
        fprintf('%-6s | %-6d | %-17d | %-13d | %-12d | %-10.2f | %-4d | %-12s | %.2f\n', ...
            cars(i).name, cars(i).random_number, ...
            cars(i).interarrival_time, cars(i).arrival_clock, ...
            cars(i).refuel_time, cars(i).probability, ...
            cars(i).lane, cars(i).petrol_type, cars(i).price_per_litre);
    end

    
%chatgpt what the helly starts here
fprintf('\nPump Usage Details:\n');

for p = 1:4
    fprintf('\nPump %d:\n', p);
    fprintf('%-6s | %-13s | %-13s | %-11s | %-12s | %-11s\n', ...
        'Car', 'Refuel Time', 'Service Begin', 'Service End', 'Waiting Time', 'Time Spent');
    fprintf('%s\n', repmat('-', 1, 80));

    pump_used = false;
    for i = 1:VehiclesAmountInput
        if cars(i).pump == p
            pump_used = true;
            fprintf('%-6s | %-13d | %-13d | %-11d | %-12d | %-11d\n', ...
                cars(i).name, ...
                cars(i).refuel_time, ...
                cars(i).service_begin, ...
                cars(i).service_end, ...
                cars(i).waiting_time, ...
                cars(i).time_spent);
        end
    end

    if ~pump_used
        fprintf('No cars used this pump.\n');
    end
end
    
 
end


%===================== Petrol Type Function =====================%
function output = PetrolType()
    output.petrol = {'Ron 95','Ron 97','Diesel'};
    output.probability = [0.30 , 0.30 , 0.40];
    output.cdf = cumsum(output.probability);
    output.price = [4.50 , 6.50 , 7.50];

    output.range = zeros(1, length(output.petrol)*2);
    lowerbound = 1;
    
    for i = 1:length(output.petrol)
        output.range((i-1)*2 + 1) = lowerbound;
        output.range((i-1)*2 + 2) = round(output.cdf(i) * 100);
        lowerbound = output.range((i-1)*2 + 2) + 1;
    end
end


%===================== Mixed LCG =====================%
function [r, nextSeed] = MixedLCG(seed)
    a = 1664525;
    c = 1013904223;
    m = 2^32;
    nextSeed = mod((a * seed + c), m);
    r = nextSeed / m;
end

%===================== Multiplicative LCG =====================%
function [r, nextSeed] = MultiplicativeLCG(seed)
    a = 1664525;
    m = 2^32;
    nextSeed = mod((a * seed), m);
    r = nextSeed / m;
end

%===================== Cumulative LCG =====================%
function [r, nextSeed, cumSum] = CumulativeLCG(seed, cumSum)
    [val, nextSeed] = MixedLCG(seed);
    cumSum = mod(cumSum + val, 1);
    r = cumSum;
end


















                  
     







    
