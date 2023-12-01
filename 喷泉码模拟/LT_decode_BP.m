function [H_decode_after,code_decode_after,tag_decode] = LT_decode_BP(H_receive,code_receive,H_decode_before,code_decode_before)
    % 接受输入的接收校验矩阵 H_receive 和接收码字矩阵 code_receive，
    % 以及当前的译码状态 H_decode_before 和 code_decode_before。
    % 函数返回 更新后的译码校验矩阵 H_decode_after、译码码字矩阵 code_decode_after，
    % 以及一个指示是否成功译码的标志 tag_decode。
    tag_decode = 0;
    H_decode_after = [H_decode_before;
                      H_receive];
    code_decode_after = [code_decode_before;
                        code_receive];
     % 首先，将接收到的校验矩阵和码字矩阵添加到当前的译码状态之后               
    if size(find(H_receive == 1),2) == 1
        [H_decode_after,code_decode_after] = BP(H_decode_after,code_decode_after,size(H_decode_after,1));
        rank_H = find_rank(H_decode_after);
% 调用 Belief Propagation (BP) 的函数 BP，对度数为1的节点进行操作，更新译码校验矩阵和码字矩阵。
        if rank_H == size(H_decode_after,2)
            tag_decode = 1;
        end
        %计算译码后的秩，如果为满秩则译码成功，将tag_decode设定为1.
    end

end

