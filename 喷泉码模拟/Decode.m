function p = Decode(p1)
   len = size(p1,2);
for j=1:size(p1,1)
   for i = 1:2:len
    if p1(j,i) == 0 && p1(j,i+1) == 1
        p(j,(i+1)/2)='A';
    elseif p1(j,i) == 1 && p1(j,i+1) == 0
        p(j,(i+1)/2)='T';
    elseif p1(j,i) == 0 && p1(j,i+1) == 0
        p(j,(i+1)/2)='C';
    elseif p1(j,i) == 1 && p1(j,i+1) == 1
        p(j,(i+1)/2)='G';
    end
   end
end
