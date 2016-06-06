function [Qe,d]=TS_GW(Bushu,R)
%************************************************************%
%                  GW算法仿真通式
%************************************************************%
%本程序可用来构造可逆的MA过程，求其参数和新息的方差
%有2个参数：迭代次数Bushu,ARMA过程相关函数
%返回值：Qe为新息方差，d为MA过程的参数
%************************************************************%
m=size(R,1) %得到维数
n=size(R,2)/m-1 %得到等价MA的阶数
R(:,m*(n+2):m*(Bushu+10))=zeros;
%************************************************************%
Rre(1:m,1:m)=R(:,1:m);
for t=1:Bushu-1;
    Rre(t*m+1:(t+1)*m,1:m)=R(:,t*m+1:(t+1)*m);
    for i=t-1:-1:0;
        sum=zeros(m,m);
        for s=i+1:min(n,t);
            sum=sum+Rre(t*m+1:(t+1)*m,(t-s)*m+1:(t-s+1)*m)*inv(Rre((t-s)*m+1:(t-s+1)*m,(t-s)*m+1:(t-s+1)*m))*Rre((t-i)*m+1:(t-i+1)*m,(t-s)*m+1:(t-s+1)*m)';
        end;
        Rre(t*m+1:(t+1)*m,(t-i)*m+1:(t-i+1)*m)=R(:,i*m+1:(i+1)*m)-sum;
    end;
end;
%************************************************************%
for i=1:Bushu;
      Qe(:,(i-1)*m+1:m*i)=Rre((i-1)*m+1:m*i,(i-1)*m+1:m*i);
end;
for j=1:n
    for t=1+j:Bushu;
        d((j-1)*m+1:j*m,(t-1)*m+1:t*m)=Rre((t-1)*m+1:t*m,(t-j-1)*m+1:(t-j)*m)*inv(Qe(:,(t-1)*m+1:m*t));
    end;
end;
