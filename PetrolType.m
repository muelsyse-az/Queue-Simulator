function output = PetrolType(x)
    output.petrol = ['Ron 95','Ron 97' , 'Dynamic Diesel'];
    output.probability = [ 0.30 , 0.30 , 0.40 ];
    output.skibidi = CumulativeProb(output.probability);
    
    