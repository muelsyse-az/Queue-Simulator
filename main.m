
%r=================MAIN FUNCTION================%r

function output = main()
    petronas_logo();
    serviceType();
    ServiceTime();
    userInput();
    
    
end

%r===============================================%r


%r=====================decorative display ^^==========================%r

function petronas_logo()
    clc;
    fprintf('\n');
    fprintf('             _____              \n');
    fprintf('            /\   /  \n');
    fprintf('           /  \ /      \n');
    fprintf('          /    \         \n');
    fprintf('         / ___  \         \n');
    fprintf('        |  |  |  |        \n');
    fprintf('        |  |__|  |       \n');
    fprintf('         \______/         \n');
  
    fprintf('\n');
    fprintf('        PETRONAS          \n');
    fprintf('\n');
    fprintf('\nWelcome to Petronas!\n');
end

%r=========================================================================%r

%r================================Service Type Table==========================================%r

function output= serviceType(x)
    printf('\nService Type Probability Table\n');
    printf('--------------------------------------------------------------------------------------|\n');
    printf('|Service Type |Probability  |CDF          |   Random Number Range     | Price/Litre   |\n');
    printf('--------------------------------------------------------------------------------------|\n');
    printf('|Ron 95       |0.30         |0.30         |       1 - 30              |    4.50       |\n');
    printf('|Ron 97       |0.30         |0.60         |      31 - 60              |    6.50       |\n');
    printf('|Diesel       |0.40         |1.00         |      61 - 100             |    7.50       |\n');
    printf('--------------------------------------------------------------------------------------|\n');
    
end

%r=========================================================================%r


%r================================Service Time Table==========================================%r




%r=========================================================================%r

%r=========================USER INPUT FUNCTION==========================================%r

function output = userInput(x)
    printf('\n1 - Mixed LCG\n');
    printf('\n2 - Cumulative LCG\n');
    printf('\n3 - Multiplicative LCG\n');
    
    LCGTypeInput = input('Choose the numbers for the number generator');
    while(LCGTypeInput ~= 1 & LCGTypeInput ~= 2 & LCGTypeInput ~= 3)
         disp('Invalid Input');
         LCGTypeInput = input('Choose the numbers for the number generator');
    end
    
    VehiclesAmountInput = input('Input the amount of vehicles for the simulation');
    printf('\n 1 - Non Peak Hour\n');
    printf('\n 2 - Peak Hour\n');
    HourModeInput = input('Choose the hour mode you prefer!');
    
    while(HourModeInput ~= 1 & HourModeInput ~= 2)
        disp('Invalid Input , please try again');
        HourModeInput = input('Choose the hour mode you prefer!\n');
    end
    
    
    
    if(LCGTypeInput == 1)
        disp('You chose Mixed LCG!');
        if(HourModeInput == 1)
            disp('You chose Non Peak Hour!');
            
        end
        
        if(HourModeInput == 2)
            disp('You chose Peak Hour!');
        end
        
        
        
        
        
    end
        
    if (LCGTypeInput == 2)
        disp('You chose Multiplicative LCG!');
           if(HourModeInput == 1)
            disp('You chose Non Peak Hour!');
        end
        
        if(HourModeInput == 2)
            disp('You chose Peak Hour!');
        end
        
    end
    
    if ( LCGTypeInput == 3)
        disp('You chose Cumulative LCG!');
           if(HourModeInput == 1)
            disp('You chose Non Peak Hour!');
        end
        
        if(HourModeInput == 2)
            disp('You chose Peak Hour!');
        end
     
    end
    
end


%r=============================================================================================%r




%r =============MIXED LCG FUNCTION==========================%r

function output = MixedLCG(seed)
    a = 166457;
    c = 1013904223;
    m = 2^32;
    
    persistent X;
    if isempty(X)
        X = seed;
    end
    X = mod((a * X + c), m);
    r = X / m;
    refuelingtime(r);
end

%r =========================================================%r



%r =============MULTIPLICATIVE LCG FUNCTION==========================%r


function output = MultiplicativeLCG(seed)
    a = 166457;
    m = 2^32;
    
    persistent X;
    if isempty(X)
        X = seed;
    end
    X = mod((a * X), m);
    r = X / m;
    refuelingtime(r);
end

%r =========================================================%r


%r====================CUMULATIVE LCG===========================================%r

function output = CumulativeLCG(seed)
    persistent CumulativeSum;
    if isempty(CumulativeSum)
        CumulativeSum = 0;
    end
    
    val = MixedLCG(seed);
    CumSum = CumulativeSum + val;
    r = mod(CumSum , 1);
    refuelingtime(r);
end
    
    
        
%r ============================================================================%r

                     
     







    
