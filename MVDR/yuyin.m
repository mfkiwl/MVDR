%��˷������źŲ���
clear all
close all
clc
Fs=8000;
beta=[0 0 0 0 0 0];%����ϵ�� ����P24
source=[2 3.5 2]; %��Դ����
sink_1=[1 1.84 1];% ��˷�����
sink_2=[2 3.4 1];
sink_3=[3 2 1];
sink_4=[2 2.5 1];
room=[5 4 3];%�����С
LimAtten=30;%������Ӧ˥����ֵ
measT60=0;%����ʱ��
snr=20;%�����
c=345;
%�������˷紦����������Ӧ
%h_1=MakeIMResp(Fs,beta,sink_1,source,room,c,LimAtten,measT60);
%h_2=MakeIMResp(Fs,beta,sink_2,source,room,c,LimAtten,measT60);
%h_3=MakeIMResp(Fs,beta,sink_3,source,room,c,LimAtten,measT60);
%h_4=MakeIMResp(Fs,beta,sink_4,source,room,c,LimAtten,measT60);


[s1,FS]=audioread('���ش�����ѻ����.wav');%ԭʼ�ź�
[n,wn,beta]=kaiserord([0.065,0.085]*pi,[1,0],[0.01,0.01],2*pi);%�˳�300HZ��������
hh=fir1(n,wn,'high',kaiser(n+1,beta),'noscale');
s=filter(hh,1,s1(:,1));
s=s1(:,1);
%��˷紦�ź�

%������������
h_1=ATF(FS,sink_1,source);
h_2=ATF(FS,sink_2,source);
h_3=ATF(FS,sink_3,source);
h_4=ATF(FS,sink_4,source);

%x1=conv(h_1,s);
%x2=conv(h_2,s);
%x3=conv(h_3,s);
%x4=conv(h_4,s);
s=fft(s);
x1=h_1*s;
x1=ifft(x1);
x2=h_2*s;
x2=ifft(x2);
x3=h_3*s;
x3=ifft(x3);
x4=h_4*s;
x4=ifft(x4);

x_1=awgn(x1,snr,'measured');%����SNRΪ�����̬�ֲ�������������� ��Ŀǰ����Ҫ��
x_2=awgn(x2,snr,'measured');
x_3=awgn(x3,snr,'measured');
x_4=awgn(x4,snr,'measured');

x0=[2 1 2 3 2];%��άͼ����
y1=[3.5 1.84 1 2 2.5];
z1=[2 1 1 1 1];
c0 = [1 7 7 7 7]';
s0 = [100 100 100 100 100]';
figure;
scatter3(x0,y1,z1,s0,c0,'fills')

figure;
scatter3(x0,y1,z1,s0,c0,'fills')
view([0 90])
L=zeros(4,4);

for i=2:1:5 %�������˽ṹ
    for j=i+1:1:5
        if sqrt((x0(i)-x0(j))^2+(y1(i)-y1(j))^2 )<4 %ͨ�Ű뾶Ϊ4m
            line([x0(i),x0(j)],[y1(i),y1(j)])
            L(i-1,j-1)=-1;%������˹���Ӿ���
            L(j-1,i-1)=-1;
        end
    end
end

%%
%�����׹���
%4�ڵ�
lamda_d1=NoiseEstimation(x1);
lamda_d2=NoiseEstimation(x2);
lamda_d3=NoiseEstimation(x3);
lamda_d4=NoiseEstimation(x4);
%%

%%
%%�����γ��㷨
Y_1~=h_1

%%

%% һ�����㷨���ﷲ�����¡�
%%
x2(221415:221469,:)=0;
x3(221463:221469,:)=0;
x4(221433:221469,:)=0;
x = [x1 x2 x3 x4];
x = x';
p = L;
c = sum(p,2);
for i=1:4
    p(i,i)=-c(i,1);
end    
p = eye(4)-0.01*p;%һ����P����
for i=1:221369
    for j=1:400
        x(:,i)=p*x(:,i);
        y(:,i) = x(:,i); 
    end
end

figure;
subplot(411);
plot(y(1,:))
title('һ���Ը��½��')
subplot(412);
plot(y(2,:))
subplot(413);
plot(y(3,:))
subplot(414);
plot(y(4,:))
%%

figure;
subplot(511)
plot(s)
title('ԭʼ�ź�')
subplot(512)
plot(x1)
title('��˷�1���õ����ź�')
subplot(513)
plot(x2)
title('��˷�2���õ����ź�')
subplot(514)
plot(x3)
title('��˷�3���õ����ź�')
subplot(515)
plot(x4)
title('��˷�4���õ����ź�')
audiowrite('out1.wav',real(x5),FS);audiowrite('out2.wav',x2,FS);
