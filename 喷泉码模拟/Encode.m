function p = Encode(p1)
   for i=1:size(p1,1)
       for j=1:size(p1,2)
          if p1(i,j)=='A'
          p(i,2 * j -1) = 0;
          p(2 * j) = 1;
          elseif p1(i,j)=='T'
          p(i,2 * j -1) = 1;
          p(i,2 * j) = 0;
          elseif p1(i,j)=='C'
          p(i,2 * j -1) = 0;
          p(i,2 * j) = 0;
          elseif p1(i,j)=='G'
          p(i,2 * j-1) = 1;
          p(i,2 * j) = 1;
         end
       end
   end
end