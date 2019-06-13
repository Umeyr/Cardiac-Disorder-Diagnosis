%load arrhythmia.data;

%load('arrhythmia','-mat');

%take 74 samples for test data
sample = [ 10 5 5 5 5 5 2 2 2 5 0 0 0 2 2 5];
location = [];
totsample = sum(sample);

for i = 1:16
    
    index = find(Y==i);
    
    
    index = index(1:sample(i));
    
    location = [location; index];

end



%first normalize the data

length = 452;

avg = zeros(1,279);
var = zeros(1,279);
num = zeros(1,279);

for j = 1:279
    for i = 1:length
        if ~isnan( X(i,j) )
            avg(1,j)  = avg(1,j) + X(i,j) ;
            var(1,j)  = var(1,j) + (X(i,j))^2 ;
            num(1,j)  = num(1,j) + 1;
        end
    end
    
end


    for j = 1:279
        avg(1,j ) = avg(1,j )/num(1,j);
        var(1,j ) = var(1,j )/num(1,j);
    end
    
%standardize
Xst = X;

for j = 1:279
    for i = 1:length
        if ~isnan(X(i,j)) 
            if var(1,j) ~= 0
            Xst(i,j) = ( X(i,j)-avg(1,j) )/sqrt(var(1,j));
            end
        end
    end
end



% finding the k means
avg = zeros(16,279);
num = zeros(16,279);


for i = 1:length
    
    for j = 1:279
        if ~isnan( Xst(i,j) )  &&  ~any(location(:) == i) 
            avg(Y(i,1),j)  = avg(Y(i,1),j) + Xst(i,j) ; 
            num(Y(i,1),j)  = num(Y(i,1),j) + 1;
        end
    end
    
end

for i = 1:16
    for j = 1:279
        avg(i,j ) = avg(i,j )/num(i,j);
    end
    
end


%remove the nan parts of average
avg  = [ avg(1:10,:) ; avg(14:16,:)];



for i = 1:13
    for j = 1:279
        if isnan(avg(i,j))
            avg(i,j)  = 0;
        end
    end
end
  
  
   
%kmeans steps
%%%%%%%%%%%%%%
%%%%%%%%%%%%%%


%clustering

cluster = zeros(totsample,1);

%expectation
for count = 1:100

for i = 1:totsample
    
    elect = zeros(13,1);
    
    Dif = zeros(13,1);
    
    for j = 1:279
        if ~isnan(Xst(location(i),j ))
            
            for k = 1:13
                Dif(k,1) = Dif(k,1) + (avg(k,j) - Xst(location(i),j))^2;
            end

        end
    end
    
    [M,I] = min(Dif);
    
%     if I >= 11
%         I = I + 3;
%     end
%     
    cluster(i,1) = I;
   
    
end


%maximization
for i = 1:13
    
    loc = find(cluster==i);
   
    for j = 1:279
        avg (i,j) = sum( Xst(loc,j) );
    end
    
    if size(loc,1)
        avg(i,:) = avg(i,:)/size(loc,1);
    end
    
end  
  
end


for i = 1:totsample
    
    elect = zeros(13,1);
    
    Dif = zeros(13,1);
    
    for j = 1:279
        if ~isnan(Xst(location(i),j ))
            
            for k = 1:13
                Dif(k,1) = Dif(k,1) + (avg(k,j) - Xst(location(i),j))^2;
            end

        end
    end
    
    [M,I] = min(Dif);
    
    if I >= 11
        I = I + 3;
    end
    
    cluster(i,1) = I;
   
    
end
%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%
%kmeans end


%performance measure

                
%number of each label
numexp = zeros(16,1);
for i = 1:totsample
       
numexp(cluster(i,1),1)  = numexp(cluster(i,1),1) + 1;


end


%percentage error



falsedet = sum( abs(sign( cluster - Y(location,1)  )) );
correctdet  = totsample - falsedet;
accuracy = correctdet / totsample

    
    
    
    
    