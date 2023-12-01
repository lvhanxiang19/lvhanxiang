function [ distribution_matrix_prob ] = robust_solition( packet_num )
    %理想孤波分布生成函数
    %参数为包的数量，即packet_num。
    p_ideal = zeros(1,packet_num);
    %返回0组成的行向量，长度等于包的数量
    p_ideal(1) = 1/packet_num;
    %定义向量第一个值的大小
    for i = 2:packet_num
        p_ideal(i) = 1/(i*(i-1));
        %定义后面的值的大小，使得向量最终展现出包的理想孤波分布。
    end

    figure(2)
    bar(p_ideal)
    xlabel('Degree')
    ylabel('Frequency')
    axis([0 50 0 0.5])
    title('理想孤波分布')

    %利用bar函数画出鲁棒孤波分布
    %参数
    c = 0.05;
    delta = 0.05; 
    %保证译码成功概率为  1-delta
    p_robust = p_ideal;
    

    R = c*log(packet_num/delta)*sqrt(packet_num);
    degree_max = round(packet_num / R); %度数上限
    p = zeros(1,degree_max);  %度分布概率矩阵
    
       
    for i = 1:degree_max-1
        p(i) = R/(i*packet_num);
    end
    %这一部分计算鲁棒孤波分布的参数，并使用这些参数计算度分布概率矩阵 p。
    %参数包括 c 和 delta，以及通过它们计算的鲁棒性参数 R 和度数上限 degree_max
    p(degree_max) = R*log(R/delta)/packet_num;
    
    %鲁棒孤波分布为p与p_ideal相加然后归一化
    for i = 1:degree_max
        p_robust(i) = p_ideal(i) + p(i);
    end

    p_robust = p_robust/sum(p_robust);
    %将鲁棒孤波分布向量 p_robust 归一化，确保概率之和等于1。
    max_num = find(p_robust > (0.1/packet_num), 1, 'last' );
    %find 函数找到 p_robust 中大于 (0.1/packet_num) 的最后一个元素的索引，
    %即找到一个阈值，使得概率大于这个阈值的度数被保留
    distribution_matrix_prob = p_robust(1:max_num);
    %然后将 distribution_matrix_prob 截取为这个索引之前的部分。
    temp_sum = sum(distribution_matrix_prob);
    distribution_matrix_prob = distribution_matrix_prob .* (1/temp_sum);
    %这两行代码再次对截取后的分布进行归一化，确保概率之和等于1。
    real_degree_max = length(distribution_matrix_prob);
  
    
    figure(3)
    bar(distribution_matrix_prob)
    xlabel('Degree')
    ylabel('Frequency')
    title('鲁棒孤波分布')
    axis([0 50 0 0.5])
end
%变量 distribution_matrix_prob 包含了截取、归一化后的鲁棒孤波分布的概率值。


%最后，绘制鲁棒孤波分布的图表 
