function output = main()
    petronas_logo();
    serviceType();
    serviceTime();
    userInput();
    
    
end


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

function output = serviceTime(x)
      printf('\nTypes of Service offered\n');
    printf('---------------------------------------------------------\n'); 
    printf('|  Lane Type   |               Pump Stations            |\n');
    printf('---------------------------------------------------------\n');
    printf('|      1       |                   1,2                  |\n');
    printf('|      2       |                   3,4                  |\n');
    printf('---------------------------------------------------------\n');
end


function output = userInput(x)
    printf('\n1 - Mixed LCG\n');
    printf('\n2 - Cumulative LCG\n');
    printf('\n3 - Multiplicative LCG\n');
    
    x = input('Choose the numbers for the number generator');
    while(x ~= 1 & x ~= 2 & x ~= 3)
         disp('Invalid Input');
         x = input('Choose the numbers for the number generator');
    end
    
    if(x == 1)
        disp('Chosed 1');
    end
        
    if (x == 2)
        disp('Chosed 2');
    end
    
    if ( x == 3)
        disp('Chosed 3');
    end
    
end
        

                     
         






    
