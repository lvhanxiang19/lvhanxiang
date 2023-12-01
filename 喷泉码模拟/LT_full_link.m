%主函数，模拟传输过程
clear;
clc;
%循环次数
loop_num = 1;
%统计数据
receive_packet_statistic = [];

speed = 100000;
%链路传输速率
send_bit_matrix_orig_mat = zeros(1,50);
send_bit_matrix_orig_mat1 = zeros(1,50);
%初始化两个矩阵用于存储发送比特数的统计信息

%译码算法--2为GE，1为BP
decode_tag = 1;


%误码率
ser_matrix = 1e-4;


packet_loss_num = 0;
dynamic_statistic = cell(1,loop_num);
% 初始化一些统计变量


code_send = cell(1,2);
send_bit_total = 0;
%初始化用于存储发送的编码包和总发送比特数的变量。
 
file_length = 100000;  %数据总长度
K_base = 100; %码长（喷泉码码长即原始数据的分包数）

w = 3000;
%仿真次数
for loop = 1:loop_num
%     ser_receive_packet_statisitc = [];
%     K_statistic = [];
%     ser_receive_packet_statisitc1 = [];
%     ser_receive_packet_statisitc2 = [];
%以上注释为可用的统计值，下面同理
    for p = ser_matrix 
        %在给定的误码范围内进行循环
        %发送信息参数 
        K = K_base; % 码长
        packet_num = K;%数据包数量
        packet_length = file_length/K;%数据包长度
%         K_statistic = [K_statistic K];%统计数据，带_statistic的均为统计数据，不影响实际传输过程
        packet_loss = compute_packet_loss( p,packet_length); %根据包长和误码率确定丢包率，也可以设定固定丢包率
        [send_packet,H_decode,code_decode,origin] =  LT_link_simulate(packet_num,packet_length,decode_tag,receive_packet_statistic,packet_loss); 
        after_decode=Decode(code_decode);
        o_decode=after_decode(1:100,1:500);
        o_compare=origin-o_decode;
        k=0;
        for i=1:size(o_compare,1)
            for j=1:size(o_compare,2)
                if(o_compare(i,j)~=0)
                    k=k+1;
                end
            end
        end
        k=k/(size(o_compare,1)*size(o_compare,2));
        % 进行 LT 码的链路传输仿真，得到发送的数据包数
        send_redudancy = send_packet*packet_length/file_length;
        % 计算冗余度，即发送的冗余比特数
%         ser_receive_packet_statisitc = [ser_receive_packet_statisitc send_redudancy];   
    end
%     dynamic_statistic{loop} = ser_receive_packet_statisitc;   
end


