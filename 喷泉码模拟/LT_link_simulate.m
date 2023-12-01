function [ send_packet,H_decode,code_decode,origin ] = LT_link_simulate(packet_num,packet_length,decode_tag,receive_packet_statistic,packet_loss)

        
        message_matrix = randi([0 1],packet_num,packet_length);

        %的随机二进制消息矩阵。
        origin=Decode(message_matrix);
        %初始化接收方的一些参数，包括秩的统计量，解码矩阵 H_decode 和编码矩阵 code_decode
        rank_statistic = [0]; 
        %统计量，秩反映出当前译码成功的数据包数
        H_decode = zeros(packet_num,packet_num);
        code_decode = zeros(packet_num,packet_length);

        receive_packet = 0;  %表示接收方译码成功时实际接收到的数据包
        send_packet = 0; %发送方发送的数据总数

      
        distribution_matrix_prob = robust_solition(packet_num);  
        %调用并得出对应的鲁棒孤波分布
        success_tag = 0;
        while(~success_tag)
            %根据鲁棒孤波分布得到本次发送度数
            send_degree = randsrc(1,1,[1:size(distribution_matrix_prob,2);distribution_matrix_prob]);           
            
            %编码初始化
            H = zeros(1,packet_num);
            code_encode = zeros(1,packet_length);
            message_encode_pos = [];

            %随机挑选度数个原始数据包   
            i = 1;
            while i <= send_degree
                i = i + 1;
                temp_pos = randi(size(message_matrix,1));
                if H(temp_pos) == 0
                    H(temp_pos) = 1;
                    message_encode_pos = [message_encode_pos temp_pos];
                else
                    i = i-1;
                end
            end    

            %对挑选出的原始数据包进行异或编码    
            for i = 1:size(message_encode_pos,2)            
                code_encode = Encode(error2(Decode(rem(code_encode+message_matrix(message_encode_pos(i),:),2))));
                %上一步模拟出了喷泉码对原始数据进行编码后产生的DNA错误
            end  

            %发送
            code_send{1,1} = code_encode; 
            code_send{1,2} = H;
            send_packet = send_packet + 1;
            %将编码结果 code_encode 和相应的编码矩阵 H 存储到 code_send
            

            %计算链路丢包
            packet_loss_tag = randsrc(1,1,[[0 1];[1 - packet_loss packet_loss]]);            
            if packet_loss_tag == 1
                rank_statistic = [rank_statistic rank_statistic(size(rank_statistic,2))]; 
                continue;
                %模拟链路丢包，如果丢包，跳过当前循环
            end

            if decode_tag == 1
                %BP译码
                receive_packet = receive_packet + 1; 
                [H_decode,code_decode,tag_decode] = LT_decode_BP(code_send{1,2},code_send{1,1},H_decode,code_decode);
                rank_statistic = [rank_statistic find_rank(H_decode)];
                
               
            elseif decode_tag == 2
                %高斯译码
                receive_packet = receive_packet + 1; 
                [H_decode,code_decode,tag_decode,rank_statistic] = LT_decode_Guassian(code_send{1,2},code_send{1,1},H_decode,code_decode,rank_statistic); 
                
            end
               
            if tag_decode == 1                       
                disp('decode success');
                disp('receive packet num is');
                disp(receive_packet);
                disp('send packet num is');
                disp(send_packet);
                if decode_tag == 1
                    %BP译码
                elseif decode_tag == 2
                    %高斯译码
                    receive_packet_statistic = [receive_packet_statistic receive_packet];
                end
                
                send_bit_total = receive_packet * packet_length;
                success_tag = 1;
%                 plot(rank_statistic / packet_num)  %错误率图像
                break;
                %如果译码成功，输出相关信息，记录统计数据，然后退出循环。
            end 
        end 

end

