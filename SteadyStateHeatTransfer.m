clc
clear all
close all
p=1;

%--------------------------- convergence condition -----------------------
eps=0.001;

%----------------------- number of nodes in each direction ---------------
%we suppose number of nudes in x and y direction are equal
l=input('number of nodes in each-direction='); %lenght
w=l; %width

%------------------------------ initial guess -----------------------------
T_guess=0.2;
T=zeros(w,l,1000);
T(2:l-1,2:w-1,p)=T_guess;

%---------------------------- length & width------------------------------
lg=1; %length=width

%------------------------------ boundry conditions -----------------------

T(1,2:w-1,:)=1; %top surface temp
T(2:l-1,w,:)=0; %right surface temp
T(2:l-1,1,:)=0; %left surface temp
T(l,2:w-1,:)=0; %down surface temp
T(1,1,:)=(T(2,1,p)+T(1,2,p))/2;
T(l,1,:)=(T(l-1,1,p)+T(l,2,p))/2;
T(1,w,:)=(T(2,w,p)+T(1,w-1,p))/2;
T(l,w,:)=(T(l-1,w,p)+T(l,w-1,p))/2;

%----------------------------- caclulation steps ------------------------

count=1;
while 1
    p=p+1;
    for i=2:l-1
        for j=2:w-1
            T(i,j,p)=0.25*(T(i,j-1,p-1)+T(i+1,j,p-1)+ ...
                T(i-1,j,p-1)+T(i,j+1,p-1));
        end
    end
    if T(:,:,p)-T(:,:,p-1)<=eps
        break
    end
    count=count+1;
end

fprintf('number of steps with convergence condition = %g is : %g\n',eps,count);
%-------------------------------- plot results----------------------------
T_final=T(:,:,p);
contourf(flipud(T_final))
colorbar