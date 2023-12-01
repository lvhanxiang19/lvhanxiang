function [ H_decode_after,code_decode_after,tag_decode,rank_statistic ] = LT_decode_Guassian( H_receive,code_receive,H_decode_before,code_decode_before,rank_statistic)
   %高斯译码函数
   %输入进参数：
   % H_receive：接收到的奇偶校验矩阵。
   %code_receive：接收到的编码后的数据。
   %H_decode_before：先前的奇偶校验矩阵。
   %code_decode_before：先前的编码后的数据。
   %rank_statistic：用于统计秩的向量。
   %输出参数：

   %H_decode_after：更新后的奇偶校验矩阵。
   %code_decode_after：更新后的编码后的数据。
   %tag_decode：标记，指示译码是否成功。
   %rank_statistic：更新后的秩统计向量。
    tag_decode = 0;
    %是否完成译码的标志
    H_decode_after = [H_decode_before;
                      H_receive];
    code_decode_after = [code_decode_before;
                        code_receive];
    %  将接收到的奇偶校验矩阵和编码数据附加到先前的数据的后面获得新的数据             
    [H_decode_after,code_decode_after] = Gussian(H_decode_after,code_decode_after);
    %执行之前设置好的高斯消元
    rank_H = find_rank(H_decode_after);
    rank_statistic = [rank_statistic rank_H];
    %更新矩阵的秩的值
    if rank_H == size(H_decode_after,2)
        tag_decode = 1;
        %奇偶校验矩阵的秩等于列数，那么 tag_decode 被设为 1，表示译码成功。
    end


end

