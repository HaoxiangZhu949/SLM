function y=Laguerre(p,l,x)

y=zeros(p+1,1);
if p==0
    y=1;
else
    for m=0:p
        y(p+1-m)=((-1).^m.*(gamma(p+l+1)))./(gamma(p-m+1).*gamma(l+m+1).*gamma(m+1));
    end
end
y=polyval(y,x);
end