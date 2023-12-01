function p=RScode(p1,m)%p1为需要编码的数据
   p1_gf=gf(p1,m);
   p=rsenc(p1_gf,2^m-1,size(p1,2));
end
     