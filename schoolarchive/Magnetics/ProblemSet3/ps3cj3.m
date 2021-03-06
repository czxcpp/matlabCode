% Magnetic Induction due to Arbitrarily Oriented dipole.  Assume a coordinate 
% system that is x,y,z where x=mag north, y=east, z=down

clear all;
close all;

t2nt=1e09;

% dipole moment, m, declination D, inclination I
mm=6e7;
D=0;
I=90;
mvec=mm*[cosd(I)*cosd(D) cosd(I)*sind(D) sind(I)];

tic

vhalf=30;                   % spreading half-rate in km/Myr
pt=[0 0.78  1.5  2.5  5.5]; % Polarity timescale in Myr
ck95=[0 0.78 0.99 1.07 1.77,.....
    1.95 2.14 1.15 2.582 3.040,....
    3.11 3.22 3.33 3.58 4.18 4.29,....
    4.48 4.62 4.80 4.89 4.98 5.23];
py=vhalf*pt*1e03;           % polarity boundaries from MOR in m


    
% take observations at positions xp,yp,zp - these are now in km
ymax=150e03;
yinc=0.5e03;
xp=0;
yp=-ymax:yinc:ymax;         %E-W profile
zp=0;

% dipole positions, xq, yq, zq (zq doesn't change)
zq=3e03;                    %dipole at 3km depth (1/2 crustal thickness)
f1=5;
f2=30;
dxq=zq/f2;
dyq=zq/f2;

ZZ=(zp-zq)*ones(size(yp));

%normal polarity dec, inc
D=0;
I=60;

% set up vectors for summing bx, by, bz contributions from all dipoles
sbx=zeros(size(yp));
sby=zeros(size(yp));
sbz=zeros(size(yp));

% set up enough dipoles in y-direction to approximate infinite x-direction
nxd = f2*f1;                % f1 given by max distance = f1*zq 
                            % f2 from dxp=dyp=zq/f2 (convergence)   
nyd = round(ymax/dyq)+nxd;
for i=-nyd:nyd,
    yq=i*dyq;
    YY=yp-yq;               % dipole-observer y-vec
    if (yq>py(2) && yq<py(3)) || (yq>py(4) && yq<py(5)) || (yq<-py(2) && yq>-py(3)) || (yq<-py(4) && yq>-py(5))
        I=-60;
        D=180;
    else
        I=60;
        D=0;
    end
    mvec=mm*[cosd(I)*cosd(D) cosd(I)*sind(D) sind(I)];
    for j=-nxd:nxd          % make an "infinite slab" in x-direction
        xq=j*dxq;
        XX=xp-xq;           % dipole-observer x-vec
  
        [bx,by,bz]=dipm2b(XX,YY,ZZ,mvec);
        sbx=sbx+bx;
        sby=sby+by;
        sbz=sbz+bz;
    end
end


toc

sbx=sbx*t2nt;
sby=sby*t2nt;
sbz=sbz*t2nt;

figure(2)
plot(yp/1000,sbx,yp/1000,sby,yp/1000,sbz)
legend('Bx', 'By', 'Bz')
xlabel('y-distance (km)')
ylabel ('nT')
grid
title('Field due to infinite slab in x direction')


