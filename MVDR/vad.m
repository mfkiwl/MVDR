function [lamdav] = vad(Y)
%VAD �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
Y=Y(:,1:100);
  for l=1:1:100  
    delata=abs(Y(:,l)).^2;
    delata=sum(delata,1)/706;
  end
    lamdav=sum(delata,2)/100;
end

