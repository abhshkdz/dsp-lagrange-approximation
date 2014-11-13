function y=lagrange(x_actual, x_fitting, y_fitting)

n = size(x_fitting,2);

P = ones(n,size(x_actual,2));

if (size(x_fitting,2)~=size(y_fitting,2))
   fprintf(1,'\nx_fitting and y_fitting should have same size.\n');
   y=NaN;
else
   for i=1:n
      for j=1:n
         if (i~=j)
            P(i,:)=P(i,:).*(x_actual-x_fitting(j))/(x_fitting(i)-x_fitting(j));
         end
      end
   end
   y=0;
   for i=1:n
      y=y+y_fitting(i)*P(i,:);
   end
end