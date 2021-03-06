% Dispersion.

t     = 1:0.1:50;
x     = 0:0.01:4;
lamda = 0.2;
p     = 0.1;
w     = 1.5;
k     = 2*pi/lamda;
dw    = p*w;
dk    = p*k;
w1    = w - dw;
w2    = w + dw;
k1    = k - dk;
k2    = k + dk;

a=0;

if a == 1
    for ii = 1:length(t)
        
        figure(1)
        
        plot(x,cos(w1*t(ii) - k1*x) + cos(w2*t(ii) - k2*x))
        ylim([-2.1,2.1])
    end
else
    
    for ii = 1:length(x)
        figure(1)
        plot(t,cos(w1*t - k1*x(ii)) + cos(w2*t - k2*x(ii)))
        
    end
end