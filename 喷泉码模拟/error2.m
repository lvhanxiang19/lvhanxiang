function p=error2(p1)%本函数用于模拟DNA在进行拷贝写入读取测序时出现的，单个DNA链
                    %的碱基替换错误
  %替换错误
  p=p1;
  for i=1:size(p1,1)
      for j=1:size(p1,2)
          k=randi(1000);%模拟大约千分之一的碱基错误（第二代测序技术的错误率）
          if(k<=1)
          m=randi([1,4]);
          if(m==1)
              p(i,j)='A';
          elseif(m==2)
              p(i,j)='G';
          elseif(m==3)
              p(i,j)='C';
          else
              p(i,j)='T';
          end
          else
              continue;
          end
      end
  end
end

  