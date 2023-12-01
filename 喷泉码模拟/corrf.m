function corrf(image,flag)   %flag为 1是求横方向的相关性 flag是2时是求纵方向的相关性，flag是3是求对角方向的相关性 
A=imread(image);
%A=A(:,:,1);
A=double(A);
s=size(A);
h=0;
v=0;
d=0;
p=0;
sum=0;
for i=1:3000
       
   m=round(s(1)*rand);  %随机取点
   n=round(s(2)*rand); 
   if m==0  
       m=m+1;
   end
   if n==0
       n=n+1;
   end
   if m>=s(1)  
       m=m-100;
   end
   
   if n>=s(2)
       n=n-100;
   end
  
   P(i)=A(m,n);
     p=p+P(i);
   if flag==1
    H(i)=A(m,n+1);
    h=h+H(i);
   end
    if flag==2
      V(i)=A(m+1,n);
      v=v+ V(i);
    end
    if flag==3
    Dia(i)=A(m+1,n+1);
    d=d+Dia(i);
    end
  

end
p1=p/3000;  %E(x)值
h1=h/3000;  %横坐标的E值 
v1=v/3000;  %纵坐标的E值 
d1=d/3000;  %对角线上的E值 
num1=0;
num2=0;
num3=0;
for i=1:3000
     sum=sum+((P(i)-p1).^2);
     if flag==1
        num1=num1+((H(i)-h1).^2);
     end
      if flag==2
        num2=num2+((V(i)-v1).^2);
     end
      if flag==3
        num3=num3+((Dia(i)-d1).^2);
     end
end
Dx=sum/3000; %x的方差 
D1=num1/3000;% 横坐标上的方差
D2=num2/3000;%纵坐标上的方差
D3=num3/3000;%对角上的方差
sum1=0;
sum2=0;
sum3=0;
for i=1:3000
if flag==1
    sum1=sum1+(P(i)-p1)*(H(i)-h1);
end
if flag==2
    sum2=sum2+(P(i)-p1)*(V(i)-v1);
end
if flag==3
    sum3=sum3+(P(i)-p1)*(Dia(i)-d1);
end
end
    cov1=sum1/3000; %横坐标上的协方差 
    cov2=sum2/3000; %纵坐标上的协方差
    cov3=sum3/3000; %对角方向的协方差
h1;
%P1=reshape(P,50,40);
%r1=cov(P1,1)
%r2=std(P1,1,2)
%r=cov(P1,1)/(std(P1,1,2));
if flag==1
    R1=cov1/sqrt(Dx*D1);%横坐标的相关系数 
end
if flag==2
    R2=cov2/sqrt(Dx*D2);%纵坐标的相关系数 
end
  if flag==3
    R3=cov3/sqrt(Dx*D3);%对角方向的相关系数 
  end


for i=1:3000
  H1(i)=H(i);
end



subplot(1,2,1),plot(P,H1,'.'),axis([0 255 0 255]);

%subplot(1,2,2),plot(P,H1,'.'),axis([0 255 0 255]);

R1

%r
%for i=1:1000
 %   e=e+
%B=corrcoef(Pm(1,:)) 
