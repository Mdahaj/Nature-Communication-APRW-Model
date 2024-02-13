clc
clear all
format long
load("data.mat")
s=size(data,1);
%%%%% Find how many cells have at lease "nr" recorded data
nr=50;% the minimum number of required data for the analysis
tff=70;%the final time of recording
i=1;
is=1;% Start index
coni=1;% Counter
dats=0;% Number of acceptable datasets
while (i<s)
    if (data(i+1,4)==data(i,4))
        coni=coni+1;
    else
        if(coni>nr && data(i,3)>tff)
            ifi=is+coni-1;
            datas(is:ifi,:)=data(i-coni+1:i,:);
            is=ifi+1;
            dats=dats+1;%number of datasets (cells) that have more than "nr" recorded data
            codats(dats,1)=coni;
            codats(dats,2)=data(i,3);
        end
        coni=1;
    end
    i=i+1;
end
%%%%%%%%%%%%%%%% Interpolate betweeb the recorded data to have equal time
%%%%%%%%%%%%%%%% steps
m=1;k=1;
for i=1:dats
    j=1;
    ss=0;
    if (i>1)
        for ii=1:i-1
            ss=ss+codats(ii,1);
        end
        k=1+ss;
    end
    while (j<=tff)
        if (datas(k,3)==j)
            datf(m,1)=datas(k,4);
            datf(m,2)=datas(k,3);
            datf(m,3)=datas(k,1);
            datf(m,4)=datas(k,2);
            k=k+1;
            m=m+1;
            j=j+1;
        else
            for l=j:1:datas(k,3)-1
                datf(m,1)=datas(k,4);
                datf(m,2)=l;
                datf(m,3)=(datas(k,1)-datas(k-1,1))/(datas(k,3)-datas(k-1,3))*(l-datas(k-1,3))+datas(k-1,1);
                datf(m,4)=(datas(k,2)-datas(k-1,2))/(datas(k,3)-datas(k-1,3))*(l-datas(k-1,3))+datas(k-1,2);
                m=m+1;
                j=j+1;
            end
        end
    end
end

plot(datf(:,3))
%%%%%%%% Velocity check
for i=1:dats
    for j=1:69
        v(j,i)=((datf((i-1)*70+j+1,3)-datf((i-1)*70+j,3))^2+(datf((i-1)*70+j+1,4)-datf((i-1)*70+j,4))^2)^0.5;
    end
end
for j=1:69
    t(j,1)=j;
    vm(j,1)=mean(v(j,:));
    SEM(j,1)= std(v(j,:))/sqrt(length(v(j,:))); 
end
errorbar(t,vm,SEM)

