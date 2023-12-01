function [ distribution_matrix_prob ] = robust_solition( packet_num )
    %����²��ֲ����ɺ���
    %����Ϊ������������packet_num��
    p_ideal = zeros(1,packet_num);
    %����0��ɵ������������ȵ��ڰ�������
    p_ideal(1) = 1/packet_num;
    %����������һ��ֵ�Ĵ�С
    for i = 2:packet_num
        p_ideal(i) = 1/(i*(i-1));
        %��������ֵ�Ĵ�С��ʹ����������չ�ֳ���������²��ֲ���
    end

    figure(2)
    bar(p_ideal)
    xlabel('Degree')
    ylabel('Frequency')
    axis([0 50 0 0.5])
    title('����²��ֲ�')

    %����bar��������³���²��ֲ�
    %����
    c = 0.05;
    delta = 0.05; 
    %��֤����ɹ�����Ϊ  1-delta
    p_robust = p_ideal;
    

    R = c*log(packet_num/delta)*sqrt(packet_num);
    degree_max = round(packet_num / R); %��������
    p = zeros(1,degree_max);  %�ȷֲ����ʾ���
    
       
    for i = 1:degree_max-1
        p(i) = R/(i*packet_num);
    end
    %��һ���ּ���³���²��ֲ��Ĳ�������ʹ����Щ��������ȷֲ����ʾ��� p��
    %�������� c �� delta���Լ�ͨ�����Ǽ����³���Բ��� R �Ͷ������� degree_max
    p(degree_max) = R*log(R/delta)/packet_num;
    
    %³���²��ֲ�Ϊp��p_ideal���Ȼ���һ��
    for i = 1:degree_max
        p_robust(i) = p_ideal(i) + p(i);
    end

    p_robust = p_robust/sum(p_robust);
    %��³���²��ֲ����� p_robust ��һ����ȷ������֮�͵���1��
    max_num = find(p_robust > (0.1/packet_num), 1, 'last' );
    %find �����ҵ� p_robust �д��� (0.1/packet_num) �����һ��Ԫ�ص�������
    %���ҵ�һ����ֵ��ʹ�ø��ʴ��������ֵ�Ķ���������
    distribution_matrix_prob = p_robust(1:max_num);
    %Ȼ�� distribution_matrix_prob ��ȡΪ�������֮ǰ�Ĳ��֡�
    temp_sum = sum(distribution_matrix_prob);
    distribution_matrix_prob = distribution_matrix_prob .* (1/temp_sum);
    %�����д����ٴζԽ�ȡ��ķֲ����й�һ����ȷ������֮�͵���1��
    real_degree_max = length(distribution_matrix_prob);
  
    
    figure(3)
    bar(distribution_matrix_prob)
    xlabel('Degree')
    ylabel('Frequency')
    title('³���²��ֲ�')
    axis([0 50 0 0.5])
end
%���� distribution_matrix_prob �����˽�ȡ����һ�����³���²��ֲ��ĸ���ֵ��


%��󣬻���³���²��ֲ���ͼ�� 
