clear;
clc;

X = 987;
LOG_2 = log(2);

%Minimum and maximum x coordinates; Points are generated equally spaced
%between x_min and x_max
x_min = 1;
x_max = 20;

%Number of points for graph
N = 50;

%Degree of polynomial
D = 3;

%Number of subintervals
S = 10;

%Step size
s = D/10;

%Decrease factor
d = 0.9;

%Number of iterations
n = 10*D;

%Calculating values
%x_actual = linspace(x_min,x_max,N);
%y_actual = log(x_actual);

%x_fitting = linspace(x_min,x_max,D+1);
%y_fitting = log(x_fitting);

%Lagrange calculation
%y_interp = lagrange(x_actual, x_fitting, y_fitting);

%Error calculation
%y_error = y_interp - y_actual;

%figure();
%plot(x_actual, y_actual, x_actual, y_interp);

%y_error = abs(y_error);

%figure();
%plot(x_actual, y_error);

x_fitting = zeros(S, D+1);
y_fitting = zeros(S, D+1);

x_actual = zeros(S, N);
y_actual = zeros(S, N);

%Applying correction to x_fitting

for k=1:S
    x_min_subinterval = x_min + (k-1)*((x_max - x_min)/S);
    x_max_subinterval = x_min_subinterval + (x_max - x_min)/S;
    
    x_fitting(k,:) = linspace(x_min_subinterval, x_max_subinterval, D+1);
    y_fitting(k,:) = log(x_fitting(k,:));
    
    x_actual(k,:) = linspace(x_min_subinterval, x_max_subinterval, N);
    y_actual(k,:) = log(x_actual(k,:));
    
    %Lagrange calculation
    y_interp(k,:) = lagrange(x_actual(k,:), x_fitting(k,:), y_fitting(k,:));
    
    for i=1:n
        e = zeros(D+1,2);
        for i=2:D
            for j=1:N
                if (x_actual(k,j) > x_fitting(k,i-1) && x_actual(k,j) < x_fitting(k,i+1))
                    if (abs(y_actual(k,j) - y_interp(k,j)) > e(i,2))
                        e(i,1) = x_actual(k,j);
                        e(i,2) = abs(y_actual(k,j) - y_interp(k,j));
                    end
                end
            end
        end
        
        %Shifting points towards local error peak x coordinates
        x_fitting(k,:) = x_fitting(k,:) + s*(e(:,1)' - x_fitting(k,:));
    
        %Retaining endpoints
        x_fitting(k,1) = x_min_subinterval;
        x_fitting(k,D+1) = x_max_subinterval;
    
        %Plot graphs
        %figure();
        %plot(x_actual(k,:), y_actual(k,:), x_actual(k,:), y_interp(k,:));
    
        %y_error = y_interp(k,:) - y_actual(k,:);
    
        %figure();
        %plot(x_actual(k,:), y_error(k,:));
        %grid on;
    
        %Update step size
        s = s*d;
        
        y_interp(k,:) = lagrange(x_actual(k,:), x_fitting(k,:), y_fitting(k,:));
    end
end

%Normalize input - range reduction
n = 0;
temp = X;

if (X > x_max)
    while X > x_max
        X = X/2;
        n = n-1;
    end
elseif (X < x_min)
    while X < x_min
        X = X*2;
        n = n+1;
    end
end
    
%Identify subinterval
for k=1:S
    x_min_subinterval = x_min + (k-1)*((x_max - x_min)/S);
    x_max_subinterval = x_min_subinterval + (x_max - x_min)/S;
    if (X >= x_min_subinterval && X <= x_max_subinterval)
        break;
    end
end

%Find value
Y = lagrange(X, x_fitting(k,:), y_fitting(k,:));

if (n~=0)
    Y = Y - n * LOG_2;
end

X = temp;

sprintf('Input: %0.6f', X)
sprintf('Interpolated value: %0.10f', Y)
sprintf('Actual value: %0.10f', log(X))

figure();
%plot(x_actual(k,:), y_interp(k,:), x_actual(k,:), y_actual(k,:));
plot(reshape(x_actual', 1, N*S), reshape(y_interp', 1, N*S), reshape(x_actual', 1, N*S), reshape(y_actual', 1, N*S));
title('Actual Curve v/s Interpolated Curve');

figure();
%plot(x_actual(k,:), abs(y_interp(k,:) - y_actual(k,:)));
plot(reshape(x_actual', 1, N*S), abs(reshape(y_interp', 1, N*S) - reshape(y_actual', 1, N*S)));
title('Absolute Error Curve');