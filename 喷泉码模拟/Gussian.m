function [ H_in,code_in ] = Gussian( H_in,code_in )
    %��˹��Ԫ����
    for col_index = 1:min(size(H_in,1),size(H_in,2))
        %��һ�п�ʼһ��ѭ������������ H_in ��ÿһ�С�ʹ�� min(size(H_in,1), size(H_in,2)) 
        % �������� H_in ��������������Сֵ���Ա�֤�Ƿ�����
        row_pos = find(H_in(:,col_index) ~= 0);
        %��¼����ѭ��������û��0������������
        if(isempty(row_pos))
            return;
            %���ȫΪ0����ֱ���˳�����������
        end 
        if(H_in(col_index,col_index) == 0)
            % ��һ�м�鵱ǰ�еĶԽ�Ԫ���Ƿ�Ϊ�㣬��Ϊ�㣬��ʾ��Ҫ�����н����� 
            row_pos_below = find(H_in(col_index+1:size(H_in,1),col_index) ~= 0);
            %����H_in �д� col_index+1 �е�����ĩβ��size(H_in,1) �У��ġ�λ�ڵ� col_index
            %�е��Ӿ����У��Ƿ��з�����
            if(isempty(row_pos_below))
                return;
            end            
            row_pointer = row_pos_below(1) + col_index;
            %��һ���������������+��ǰ�����������·���һ�������С�
            %��Ϊ�ұߵ�ǰ�����Ӿ����е�������������Ҫ��һ��col_index��
            temp_H = H_in(row_pointer,:);
            %ȡ��һ��������
            H_in(row_pointer,:) = H_in(col_index,:);
          
            H_in(col_index,:) = temp_H;
            %�������������i�н���������i�ǵ�ǰѭ��������
            temp_code = code_in(row_pointer,:);
            %ȡ��ͬ�е����ɾ����е���������֮ǰ����Ķ�����żУ�����
            code_in(row_pointer,:) = code_in(col_index,:);
       
            code_in(col_index,:) = temp_code;
            %�����ɾ���Ҳ����ͬ���Ļ��в���
            for row_index = row_pos'
                %�⿪ʼѭ������������Ԫ�����ڵ���������
                if(row_index ~= row_pointer) 
                    %��һ�м�鵱ǰ���Ƿ��ǽ����˽������С�
                    H_in(row_index,:) = rem(H_in(col_index,:) + H_in(row_index,:),2);
                    %���ǣ�������о�������ٽ���ģ 2 �������൱�����
                    code_in(row_index,:)  = rem(code_in(col_index,:) + code_in(row_index,:),2);
                end
            end 
        else
            for row_index = row_pos'
                if(row_index ~= col_index)
                    %�Ƿ�ǰ��
                    H_in(row_index,:) = rem(H_in(col_index,:) + H_in(row_index,:),2);
                    code_in(row_index,:)  = rem(code_in(col_index,:) + code_in(row_index,:),2);
                    %���������һ�θ�˹��Ԫ
                end
            end                        
        end       
    end  
end

