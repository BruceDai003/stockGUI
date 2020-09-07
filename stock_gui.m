function [] = stock_gui()
% 1. ��ȡ��Ʊ����
files = dir('etfdata\');
f_names = {files.name};
f_names = f_names(3:end); % ��13�������ļ�
n_stocks = numel(f_names);

% ȥ���ļ��������.mat��׺��������ʾ
f_names_short = cell(n_stocks, 1);
for i = 1:n_stocks
    f_names_short{i} = f_names{i}(1:end-4);
end

% ��������
stocks = cell(n_stocks, 1);
for i = 1:n_stocks
    tmp = load(strcat('.\etfdata\', f_names{i}));
    stocks{i} = tmp.DataNew;
end

S.stocks = stocks;
% ����GUI
S.fh = figure('units','pixels',...
              'position',[50 50 860 800],...
              'menubar','none',...
              'name','GUI_14',...
              'numbertitle','off',...
              'resize','off');

% ���ڻ��۸�����
S.ax(1) = axes('units','pixels',...
            'position',[30 420 480 320]);

% ���ڻ��ɽ�����״ͼ
S.ax(2) = axes('units','pixels',...
            'position',[30 50 480 320]);          

% һ������������ѡ���Ʊ
S.pp = uicontrol('style','pop',...
                 'unit','pix',...
                 'position',[540 720 240 40],...
                 'backgroundc',get(S.fh,'color'),...
                 'fontsize',14,'fontweight','bold',... 
                 'string',f_names_short,'value',1);




% �ı��� ���ֵ������
S.tx(1) = uicontrol('style','text',...
                 'unit','pix',...
                 'position',[540 580 240 40],...
                 'string','���ֵ������',...
                 'fontsize', 14);       
             
% �ı���
S.tx(2) = uicontrol('style','text',...
                 'unit','pix',...
                 'position',[540 510 240 40],...
                 'string','0.3',...
                 'backgroundcolor','w',...
                 'fontsize', 14);

% �ı���
S.tx(3) = uicontrol('style','text',...
                 'unit','pix',...
                 'position',[540 440 240 40],...
                 'string','��Сֵ������',...
                 'fontsize', 14);
% �ı���
S.tx(4) = uicontrol('style','text',...
                 'unit','pix',...
                 'position',[540 370 240 40],...
                 'string','0.28',...
                 'backgroundcolor','w',...
                 'fontsize', 14);  

% �ı���, ƽ��������
S.tx(5) = uicontrol('style','text',...
                 'unit','pix',...
                 'position',[540 290 240 40],...
                 'string','ƽ��������',...
                 'fontsize', 14);
% �ı���
S.tx(6) = uicontrol('style','text',...
                 'unit','pix',...
                 'position',[540 210 240 40],...
                 'string','570000',...
                 'backgroundcolor','w',...
                 'fontsize', 14);  
             
% һ��ȷ�ϰ�ť�����ڸ��¼����ͼ
S.pb = uicontrol('style','push',...
                 'unit','pix',...
                 'position',[540 650 60 40],...
                 'fontsize', 14, ...
                 'string','ȷ��',...
                 'callback',{@pb_call,S});
end

function [] = pb_call(varargin)
% Callback for pushbutton, adds new string from edit box.
S = varargin{3};  % Get the structure.
P = get(S.pp,'val');
choice = get(S.pp, 'string');

stock = S.stocks{P};
% �������̼۵�10���ƶ���ֵ
n = length(stock);
ma10 = zeros(n-9, 1);
for i = 1:length(ma10)
    ma10(i) = mean(stock(i:i+9, 6));
end

% 30���ƶ���ֵ
ma30 = zeros(n-29, 1);
for i = 1:length(ma30)
    ma30(i) = mean(stock(i:i+29, 6));
end

% ��ȡ����
date = stock(:, 1);

% ����OHLC
cla(S.ax(1));
cla(S.ax(2));
plot(stock(:, 3), 'b-', 'Parent', S.ax(1));
hold(S.ax(1), 'on');
plot(stock(:, 4), 'r--', 'Parent', S.ax(1));
plot(stock(:, 5), 'g--', 'Parent', S.ax(1));
plot(stock(:, 6), 'c-', 'Parent', S.ax(1));
plot(10:n, ma10, 'k:', 'Parent', S.ax(1));
plot(30:n, ma30, 'm:', 'Parent', S.ax(1));
legend(S.ax(1), {'���̼�', '��߼�', '��ͼ�', '���̼�', 'MA10', 'MA30'}, ...
    'Location', 'Best');
title(S.ax(1), '�۸�ͼ');
xticks = floor(linspace(1, n, 5));
xtick_labels = date(xticks);

set(S.ax(1), 'XTick', xticks);
set(S.ax(1), 'XTickLabel', num2str(xtick_labels));

% �����ɽ���ͼ
bar(stock(:, end), 'Parent', S.ax(2));
title(S.ax(2), '�ɽ�����״ͼ');
set(S.ax(2), 'XTick', xticks);
set(S.ax(2), 'XTickLabel', num2str(xtick_labels));


% �������ֵ�Ĳ�����
ret1 = diff(log(stock(:,4)));
vol1 = std(ret1);
set(S.tx(2), 'string', vol1);

% ������Сֵ�Ĳ�����
ret2 = diff(log(stock(:,5)));
vol2 = std(ret2);
set(S.tx(4), 'string', vol2);

% ����ƽ��������
avg_vol = mean(stock(:, end));
set(S.tx(6), 'string', avg_vol);


end

