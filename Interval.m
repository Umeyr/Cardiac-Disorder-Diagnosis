%load arrhythmia.data;

%load('arrhythmia','-mat');


size = 452;
Xord = [];
Yord = [];

for i = 1:16
    
    index = find(Y == i);
    
    Xord = [Xord; X(index,:)];

end

for i  = 1:16
    
    index = find(Y == i);
    
    Yord = [Yord; Y(index)];

end




%clustering

cluster = zeros(size,1);

for i = 1:size
    
    elect = zeros(13,1);
    
    for j = 1:279
        if ~isnan(X(i,j ))
           
            Dif = zeros(13,1);
            
            for k = 1:13
                Dif(k,1) = abs(avg(k,j) - X(i,j));
            end
            
             [M,I] = min(Dif);
             I  = find(Dif == M);
             elect(I) = elect(I) + 1;
    
        end
    end
    
    [M,I] = max(elect);
    
    if I >= 11
        I = I + 3;
    end
    
    cluster(i,1) = I;
   
    
end
                
    
    
    
    
    
    