%================= MAIN FUNCTION =================%
function main()
  
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

        lane = mod(i-1,2) + 1;

        if i == 1
    arrival_time = 0 + inter_time;
else
    arrival_time = cars(i-1).arrival_clock + inter_time;
end
       
        cars(i).name = ['Car ' num2str(i)];
        cars(i).random_number = rand_num;
        cars(i).interarrival_time = inter_time;
        cars(i).arrival_clock = arrival_time;
        cars(i).refuel_time = refuel_time;
        cars(i).probability = prob;
        cars(i).petrol_type = chosenPetrol;
        cars(i).price_per_litre = chosenPrice;
        cars(i).lane = lane;
        
      
        
        
% Determine which pumps are available based on lane
if lane == 1
    pumpCandidates = [1, 2];
else
    pumpCandidates = [3, 4];
end

% Find the pump that will be available the soonest
[pumpWait, idx] = min(pump_end_time(pumpCandidates));
pump = pumpCandidates(idx);

% Determine when service can begin
arrival_time = current_time;  
start_time = max(arrival_time, pump_end_time(pump));
waiting_time = start_time - arrival_time;
end_time = start_time + refuel_time;

% Update car info
cars(i).pump = pump;
cars(i).service_begin = start_time;
cars(i).service_end = end_time;
cars(i).waiting_time = waiting_time;
cars(i).time_spent = end_time - arrival_time;

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

    %-------------------------%Average calculation%-------------------------------------%
    waitingCounter = 0;
    totalWaitTime = 0;
    totalTimeSpent = 0;
    totalp1ServiceTime = 0;
    totalp2ServiceTime = 0;
    totalp3ServiceTime = 0;
    totalp4ServiceTime = 0;

    pump1counter = 0;
    pump2counter = 0;
    pump3counter = 0;
    pump4counter = 0;

    for i = 1:VehiclesAmountInput
        totalWaitTime = totalWaitTime + cars(i).waiting_time;
        totalTimeSpent = totalTimeSpent + cars(i).time_spent;
        if cars(i).waiting_time > 0
            waitingCounter = waitingCounter + 1;
        end

        %-----Loop for each pump---------
        if cars(i).pump == 1
            totalp1ServiceTime = cars(i).refuel_time + totalp1ServiceTime;
            pump1counter = pump1counter + 1;
        elseif cars(i).pump == 2
            totalp2ServiceTime = cars(i).refuel_time + totalp2ServiceTime; 
            pump2counter = pump2counter + 1;
        elseif cars(i).pump == 3
            totalp3ServiceTime = cars(i).refuel_time + totalp3ServiceTime;
            pump3counter = pump3counter + 1;
        elseif cars(i).pump == 4
            totalp4ServiceTime = cars(i).refuel_time + totalp4ServiceTime;
            pump4counter = pump4counter + 1;
        end

    end

    %          UNCOMMENT THIS TO CHECK EACH VARIABLE VALUE %
    %---------------------------------------------------------------------------

    % fprintf('\n%s %.2f\n%s %.2f\n%s %.2f\n%s %.2f\n%s %.2f\n%s %.2f\n%s %.2f\n', ...
    % 'Total waiting time is ', totalWaitTime, ...
    % 'Total time spent in system is ', totalTimeSpent, ...
    % 'Number of customers who had to wait is ', waitingCounter, ...
    % 'Total service time for Pump 1 is ', totalp1ServiceTime, ...
    % 'Total service time for Pump 2 is ', totalp2ServiceTime, ...
    % 'Total service time for Pump 3 is ', totalp3ServiceTime, ...
    % 'Total service time for Pump 4 is ', totalp4ServiceTime);

    %------------------------------------------------------------------------


    avgWaitTime = totalWaitTime / VehiclesAmountInput;
    avgTimeSpent = totalTimeSpent / VehiclesAmountInput;
    WaitProbability = waitingCounter / VehiclesAmountInput;

if pump1counter == 0
    p1AvgServiceTime = totalp1ServiceTime;
else
    p1AvgServiceTime = totalp1ServiceTime / pump1counter;
end

if pump2counter == 0
    p2AvgServiceTime = totalp2ServiceTime;
else
    p2AvgServiceTime = totalp2ServiceTime / pump2counter;
end

if pump3counter == 0
    p3AvgServiceTime = totalp3ServiceTime;
else
    p3AvgServiceTime = totalp3ServiceTime / pump3counter;
end

if pump4counter == 0
    p4AvgServiceTime = totalp4ServiceTime;
else
    p4AvgServiceTime = totalp4ServiceTime / pump4counter;
end

    


fprintf('\n%s %.2f minutes\n%s %.2f minutes\n%s %.2f\n%s %.2f minutes\n%s %.2f minutes\n%s %.2f minutes\n%s %.2f minutes\n', ...
    'Average waiting time is', avgWaitTime, ...
    'Average time spent in system is', avgTimeSpent, ...
    'Probability a customer has to wait is', WaitProbability, ...
    'Average service time for Pump 1 is', p1AvgServiceTime, ...
    'Average service time for Pump 2 is', p2AvgServiceTime, ...
    'Average service time for Pump 3 is', p3AvgServiceTime, ...
    'Average service time for Pump 4 is', p4AvgServiceTime);


 
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


















                  
     







    
