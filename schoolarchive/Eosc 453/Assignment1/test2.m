function outv
year=linspace(1850,2100,26);
co2_emission=e_GtC_yr(1:15);
year_data = t_yr(1:15);
co2_year=interp1(year_data,co2_emission,year);
t=(1850:10:2100);
n = length(t);
s = (t-1975)/125;
A = zeros(n);
A(:,end) = 1;
for j = n-1:-1:1, A(:,j) = s' .* A(:,j+1); end
c = A(:,n-3:n)\co2_year';

v = (1850:2150)';
x = (v-1975)/125;
w = (2150-1975)/125;
y = polyval(c,x);
z = polyval(c,w);

hold on
plot(v,y,'k-');
plot(2150,z,'ks');
hold off