function [ H_in,code_in ] = Gussian( H_in,code_in )
    %高斯消元函数
    for col_index = 1:min(size(H_in,1),size(H_in,2))
        %这一行开始一个循环，迭代遍历 H_in 的每一列。使用 min(size(H_in,1), size(H_in,2)) 
        % 来迭代至 H_in 行数和列数的最小值。以保证是方阵处理
        row_pos = find(H_in(:,col_index) ~= 0);
        %记录正在循换的列中没有0的列数的索引
        if(isempty(row_pos))
            return;
            %如果全为0，则直接退出，不用算了
        end 
        if(H_in(col_index,col_index) == 0)
            % 这一行检查当前列的对角元素是否为零，若为零，表示需要进行行交换。 
            row_pos_below = find(H_in(col_index+1:size(H_in,1),col_index) ~= 0);
            %查找H_in 中从 col_index+1 行到矩阵末尾（size(H_in,1) 行）的、位于第 col_index
            %列的子矩阵中，是否有非零项
            if(isempty(row_pos_below))
                return;
            end            
            row_pointer = row_pos_below(1) + col_index;
            %第一个非零项的行索引+当前列数，这是下方第一个非零行。
            %因为右边的前者是子矩阵中的行索引，所以要加一个col_index。
            temp_H = H_in(row_pointer,:);
            %取出一个行向量
            H_in(row_pointer,:) = H_in(col_index,:);
          
            H_in(col_index,:) = temp_H;
            %将该行向量与第i行交换，其中i是当前循环的列数
            temp_code = code_in(row_pointer,:);
            %取出同行的生成矩阵中的行向量（之前处理的都是奇偶校验矩阵）
            code_in(row_pointer,:) = code_in(col_index,:);
       
            code_in(col_index,:) = temp_code;
            %对生成矩阵也进行同样的换行操作
            for row_index = row_pos'
                %这开始循环，遍历非零元素所在的行索引。
                if(row_index ~= row_pointer) 
                    %这一行检查当前行是否是进行了交换的行。
                    H_in(row_index,:) = rem(H_in(col_index,:) + H_in(row_index,:),2);
                    %不是，则对两行矩阵相加再进行模 2 操作，相当于异或。
                    code_in(row_index,:)  = rem(code_in(col_index,:) + code_in(row_index,:),2);
                end
            end 
        else
            for row_index = row_pos'
                if(row_index ~= col_index)
                    %是否当前行
                    H_in(row_index,:) = rem(H_in(col_index,:) + H_in(row_index,:),2);
                    code_in(row_index,:)  = rem(code_in(col_index,:) + code_in(row_index,:),2);
                    %不是则进行一次高斯消元
                end
            end                        
        end       
    end  
end

