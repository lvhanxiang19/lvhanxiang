function [ packet_loss ] = compute_packet_loss( ser,length )
% 计算丢包率。
    packet_loss =1 - (1-ser)^length;
    % 计算丢包率的公式。这里使用的是二项分布的补充概率，其中 ser 是每个数据包的成功传输概率，
    % length 是传输的数据包数量。packet_loss 表示总体的丢包率
end

