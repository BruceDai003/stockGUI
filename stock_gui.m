function [] = stock_gui()
% 1. 读取股票数据
files = dir('etfdata\');
f_names = {files.name};
f_names = f_names(3:end); % 共13个数据文件
n_stocks = numel(f_names);

% 去掉文件名后面的.mat后缀，用于显示
f_names_short = cell(n_stocks, 1);
for i = 1:n_stocks
    f_names_short{i} = f_names{i}(1:end-4);
end

% 加载数据
stocks = cell(n_stocks, 1);
for i = 1:n_stocks
    tmp = load(strcat('.\etfdata\', f_names{i}));
    stocks{i} = tmp.DataNew;
end

S.stocks = stocks;
% 构建GUI
S.fh = figure('units','pixels',...
              'position',[50 50 860 800],...
              'menubar','none',...
              'name','GUI_14',...
              'numbertitle','off',...
              'resize','off');

% 用于画价格曲线
S.ax(1) = axes('units','pixels',...
            'position',[30 420 480 320]);

% 用于画成交量柱状图
S.ax(2) = axes('units','pixels',...
            'position',[30 50 480 320]);          

% 一个下拉框，用于选择股票
S.pp = uicontrol('style','pop',...
                 'unit','pix',...
                 'position',[540 720 240 40],...
                 'backgroundc',get(S.fh,'color'),...
                 'fontsize',14,'fontweight','bold',... 
                 'string',f_names_short,'value',1);




% 文本框， 最大值波动率
S.tx(1) = uicontrol('style','text',...
                 'unit','pix',...
                 'position',[540 580 240 40],...
                 'string','最大值波动率',...
                 'fontsize', 14);       
             
% 文本框
S.tx(2) = uicontrol('style','text',...
                 'unit','pix',...
                 'position',[540 510 240 40],...
                 'string','0.3',...
                 'backgroundcolor','w',...
                 'fontsize', 14);

% 文本框
S.tx(3) = uicontrol('style','text',...
                 'unit','pix',...
                 'position',[540 440 240 40],...
                 'string','最小值波动率',...
                 'fontsize', 14);
% 文本框
S.tx(4) = uicontrol('style','text',...
                 'unit','pix',...
                 'position',[540 370 240 40],...
                 'string','0.28',...
                 'backgroundcolor','w',...
                 'fontsize', 14);  

% 文本框, 平均交易量
S.tx(5) = uicontrol('style','text',...
                 'unit','pix',...
                 'position',[540 290 240 40],...
                 'string','平均交易量',...
                 'fontsize', 14);
% 文本框
S.tx(6) = uicontrol('style','text',...
                 'unit','pix',...
                 'position',[540 210 240 40],...
                 'string','570000',...
                 'backgroundcolor','w',...
                 'fontsize', 14);  
             
% 一个确认按钮，用于更新计算和图
S.pb = uicontrol('style','push',...
                 'unit','pix',...
                 'position',[540 650 60 40],...
                 'fontsize', 14, ...
                 'string','确认',...
                 'callback',{@pb_call,S});
end

function [] = pb_call(varargin)
% Callback for pushbutton, adds new string from edit box.
S = varargin{3};  % Get the structure.
P = get(S.pp,'val');
choice = get(S.pp, 'string');

stock = S.stocks{P};
% 计算收盘价的10次移动均值
n = length(stock);
ma10 = zeros(n-9, 1);
for i = 1:length(ma10)
    ma10(i) = mean(stock(i:i+9, 6));
end

% 30次移动均值
ma30 = zeros(n-29, 1);
for i = 1:length(ma30)
    ma30(i) = mean(stock(i:i+29, 6));
end

% 获取日期
date = stock(:, 1);

% 画出OHLC
cla(S.ax(1));
cla(S.ax(2));
plot(stock(:, 3), 'b-', 'Parent', S.ax(1));
hold(S.ax(1), 'on');
plot(stock(:, 4), 'r--', 'Parent', S.ax(1));
plot(stock(:, 5), 'g--', 'Parent', S.ax(1));
plot(stock(:, 6), 'c-', 'Parent', S.ax(1));
plot(10:n, ma10, 'k:', 'Parent', S.ax(1));
plot(30:n, ma30, 'm:', 'Parent', S.ax(1));
legend(S.ax(1), {'开盘价', '最高价', '最低价', '收盘价', 'MA10', 'MA30'}, ...
    'Location', 'Best');
title(S.ax(1), '价格图');
xticks = floor(linspace(1, n, 5));
xtick_labels = date(xticks);

set(S.ax(1), 'XTick', xticks);
set(S.ax(1), 'XTickLabel', num2str(xtick_labels));

% 画出成交量图
bar(stock(:, end), 'Parent', S.ax(2));
title(S.ax(2), '成交量柱状图');
set(S.ax(2), 'XTick', xticks);
set(S.ax(2), 'XTickLabel', num2str(xtick_labels));


% 计算最大值的波动率
ret1 = diff(log(stock(:,4)));
vol1 = std(ret1);
set(S.tx(2), 'string', vol1);

% 计算最小值的波动率
ret2 = diff(log(stock(:,5)));
vol2 = std(ret2);
set(S.tx(4), 'string', vol2);

% 计算平均交易量
avg_vol = mean(stock(:, end));
set(S.tx(6), 'string', avg_vol);


end

