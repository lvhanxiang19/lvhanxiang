function [result]=qubu(h,d)
len1=length(h)
len2=length(d)
if len1~=len2
    error('���г��Ȳ�ͬ���ܽ���������')
end
for i=1:len1
    if h(i)==1
        p(i)=seqcomplement(d(i));
    else
        p(i)=d(i);
    end
end
result=p;
        
    