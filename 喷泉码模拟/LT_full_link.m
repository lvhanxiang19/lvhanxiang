%��������ģ�⴫�����
clear;
clc;
%ѭ������
loop_num = 1;
%ͳ������
receive_packet_statistic = [];

speed = 100000;
%��·��������
send_bit_matrix_orig_mat = zeros(1,50);
send_bit_matrix_orig_mat1 = zeros(1,50);
%��ʼ�������������ڴ洢���ͱ�������ͳ����Ϣ

%�����㷨--2ΪGE��1ΪBP
decode_tag = 1;


%������
ser_matrix = 1e-4;


packet_loss_num = 0;
dynamic_statistic = cell(1,loop_num);
% ��ʼ��һЩͳ�Ʊ���


code_send = cell(1,2);
send_bit_total = 0;
%��ʼ�����ڴ洢���͵ı�������ܷ��ͱ������ı�����
 
file_length = 100000;  %�����ܳ���
K_base = 100; %�볤����Ȫ���볤��ԭʼ���ݵķְ�����

w = 3000;
%�������
for loop = 1:loop_num
%     ser_receive_packet_statisitc = [];
%     K_statistic = [];
%     ser_receive_packet_statisitc1 = [];
%     ser_receive_packet_statisitc2 = [];
%����ע��Ϊ���õ�ͳ��ֵ������ͬ��
    for p = ser_matrix 
        %�ڸ��������뷶Χ�ڽ���ѭ��
        %������Ϣ���� 
        K = K_base; % �볤
        packet_num = K;%���ݰ�����
        packet_length = file_length/K;%���ݰ�����
%         K_statistic = [K_statistic K];%ͳ�����ݣ���_statistic�ľ�Ϊͳ�����ݣ���Ӱ��ʵ�ʴ������
        packet_loss = compute_packet_loss( p,packet_length); %���ݰ�����������ȷ�������ʣ�Ҳ�����趨�̶�������
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
        % ���� LT �����·������棬�õ����͵����ݰ���
        send_redudancy = send_packet*packet_length/file_length;
        % ��������ȣ������͵����������
%         ser_receive_packet_statisitc = [ser_receive_packet_statisitc send_redudancy];   
    end
%     dynamic_statistic{loop} = ser_receive_packet_statisitc;   
end


