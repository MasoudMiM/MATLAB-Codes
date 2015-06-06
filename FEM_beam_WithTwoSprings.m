
clc
clear all
close all

%---------------------------- user inputs --------------------------------

n=5; %input('Number of elements:');
l=0.7; %input('Length of the beam:');
ro=7850; %input('Density :');
A=100e-6; %input('Cross-section area :');
E=200e9;
I=833.3333333333e-12; %input('enter moment of area (I):');
le(1:n)=l/n;

%------------------ Mass and stiffness matrices for elements -------------

for i=1:n
    me(:,:,i)=(ro*A*le(i)/420)*[156 22*le(i) 54 -13*le(i);22*le(i) 4*le(i)^2 ...
        13*le(i) -3*le(i)^2;54 13*le(i) 156 -22*le(i); ...
        -13*le(i) -3*le(i)^2 -22*le(i) 4*le(i)^2];
    ke(:,:,i)=(E*I/le(i)^3)*[12 6*le(i) -12 6*le(i); ...
        6*le(i) 4*le(i)^2 -6*le(i) 2*le(i)^2; ...
        -12 -6*le(i) 12 -6*le(i);
        6*le(i) 2*le(i)^2 -6*le(i) 4*le(i)^2];
end

%----------------------------- assembly ---------------------------------
nodes=n+1;
dof=2*nodes;
K=[ke(:,:,1) zeros(4,dof-4);zeros(dof-4,dof)];
M=[me(:,:,1) zeros(4,dof-4);zeros(dof-4,dof)];
for i=1:n-1
    K=K+[zeros(2*i,dof);zeros(4,2*i) ke(:,:,i+1) zeros(4,dof-4-(2*i));zeros(dof-4-(2*i),dof)];
    M=M+[zeros(2*i,dof);zeros(4,2*i) me(:,:,i+1) zeros(4,dof-4-(2*i));zeros(dof-4-(2*i),dof)];
end

%---------------------------------- B.C. ---------------------------------

k_b=1000; %input('enter stiffness of spring for mounting :');
K(1,1)=K(1,1)+k_b;
K(dof-1,dof-1)=K(dof-1,dof-1)+k_b;

%-----------------------------mode shapes & frequency -------------------

[phi,fr2]=eig(K,M);
fr=sqrt(abs(fr2));
save phi_beam.mat phi
%-------------------------- plotting mode shapes -------------------------

k=1;
for j=1:ceil(dof/4)
    figure(j)
    for i=1:2
        subplot(4,1,2*i-1)
        plot((1:nodes),phi(1:2:dof,2*k-1)),grid
        subplot(4,1,2*i)
        plot((1:nodes),phi(2:2:dof,2*k-1)),grid
        k=k+1;
        if k>nodes
            break
        end
    end
end

close all


