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

%------------------------------ initial temp -----------------------------
T_init=0.1;
T=zeros(w,l,1000);
T(2:l-1,2:w-1,p)=T_init;
%---------------------------- lenght & width------------------------------
lg=1; %length=width

%-------------------------- material properties --------------------------
h=1100; %W/m^2.K
k=30; %W/m.K
alpha=5e-6; %m^2/s

%-------------------- number of divisions in each direction --------------
dd=lg/(l-1); %dx=dy

%------------------------------ boundry conditions -----------------------

T(1,2:w-1,:)=1; %top surface temp
T(2:l-1,w,:)=0; %right surface temp
T(2:l-1,1,:)=0; %left surface temp
T(l,2:w-1,:)=0; %bottom surface temp
T(1,1,:)=(T(2,1,p)+T(1,2,p))/2;
T(l,1,:)=(T(l-1,1,p)+T(l,2,p))/2;
T(1,w,:)=(T(2,w,p)+T(1,w-1,p))/2;
T(l,w,:)=(T(l-1,w,p)+T(l,w-1,p))/2;

%---------------------------- Bio and Fourier numbers --------------------
Bi=(h*dd)/k;
F0=1/(2*(1+Bi));

%-------------------------------- time step ------------------------------
dt=0.05;

%----------------------------- caclulation steps ------------------------
tim=0;
count=1;
while 1
    tim=tim+dt;
    p=p+1;
    for i=2:l-1
        for j=2:w-1
            T(i,j,p)=F0*(T(i,j-1,p-1)+T(i+1,j,p-1)+T(i-1,j,p-1)+ ...
                T(i,j+1,p-1))+(1-4*F0)*T(i,j,p-1);
        end
    end
    T_final=T(:,:,p);
    contourf(flipud(T_final)),title(['Time: ',num2str(tim),'s']);
    colorbar
    Mv(count)=getframe;
    count=count+1;
    if T(:,:,p)-T(:,:,p-1)<=eps
        break
    end
end

%--------------------------------- Animation ----------------------------
figure
contourf(flipud(T_final));
colorbar
movie(Mv,1000) % Play the movie 1000 times !
