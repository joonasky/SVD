function plotter(D,i,num);
    #plots image stored in column i from D
    im = reshape(D(:,i),28,28);
    im = im';
    imagesc(im);
    hold off;
    filename = sprintf("eigenpattern%d%d.png",num,i);
    print(filename);
    waitforbuttonpress;
endfunction

function plotTestImage();
    load test4.mat;
    #D=D'; 
    D=z;
    im = reshape(D(:,1),28,28);
    im = im';
    imagesc(im);
    hold off;
    print -djpg number4.jpg
    waitforbuttonpress;
endfunction

function U = createTrainingSets();
    #reads each numbers training sets, calculates their 
    # SVDs and stores them into a 3 dimensional array.
    U = zeros(784,784,10);
    for i=0:9
        filename = sprintf("digit%d.mat",i);
        load("-mat",filename);
        printf("calculating svd number %d\n",i)
        #The svd calculation
        [U(:,:,i+1),S,V] = svd(D');
        printf("svd number %d complete\n",i)
    endfor
endfunction

function plotKDependance(res);
    #plots how residual decrease when k increase
    x = linspace(1,100);
    plot(x,res(:,1),x,res(:,2),x,res(:,3),x,res(:,4),x,res(:,5),x,res(:,6),x,res(:,7),x,res(:,8),x,res(:,9),x,res(:,10));
    title("k values");
    legend({"0","1","2","3","4","5","6","7","8","9"});
    hold off;
    print -dpng kvalues.png
    waitforbuttonpress;
endfunction

function [smallestResiduals,kValues] = analyze(z,U);
    #compares picture z to every numbers U matrix.
    #K-values from 1 to 100 are being used and for each
    #number the smallest residual and its k-value are being returned
    #in arrays smallestResiduals and kValues.
    residual = zeros(100,1);
    allResiduals = zeros(100,10);
    smallestResiduals = zeros(10,1);
    kValues = zeros(10,1);
    for i=1:10
        U0 = U(:,:,i);
        for k=1:100
            U00 = U0(:,1:k);
            unitary = eye(784);
            #This is where the magic happens
            residual(k) = norm((unitary - U00*(U00'))*z);
        endfor
        allResiduals(:,i) = residual;
        [a,b] = min(residual);
        [smallestResiduals(i),kValues(i)] = min(residual);
    endfor
    plotKDependance(allResiduals);
endfunction

U = createTrainingSets();

plotTestImage();

#Task number 1
for i=1:5
    plotter(U(:,:,3),i,2);
endfor

for i=1:5
    plotter(U(:,:,9),i,8);
endfor

#Taks number 2

num = input("which digit you want to try to recognise?");
fil = sprintf("test%d.mat",num);

load(fil);
#temp = D';
#z = temp(:,1);

[residual,k] = analyze(z,U);

#The index which has the smallest residual is the answer
#but because indexing starts from 1, zero is stored in index 1 
#and 1 to index 2 etc.
[smallest,number] = min(residual);

printf("for number %d the number %d has the smallest residual: %f\n",num,number-1,smallest);





