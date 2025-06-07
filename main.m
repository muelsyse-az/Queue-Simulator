function output = main()
    petronas_logo();
    serviceType();
    serviceTime();
    
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
    printf('\nService Time Probability\n'); 
    
    


    
