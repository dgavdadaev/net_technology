% Формирование массива x:
x=-10:0.1:10;
% Формирование массива y.
y1=sin(x)+1/3*sin(3*x)+1/5*sin(5*x);
y2=cos(x)+1/3*cos(3*x)+1/5*cos(5*x);

% Построение графика функции:
plot(x,y1, "-ok; y1=sin(x)+ (1/3)*sin(3*x)+(1/5)*sin(5*x);","markersize",4)
hold on
plot(x,y2, "-k; y2=cos(x)+ (1/3)*cos(3*x)+(1/5)*cos(5*x);")

% Отображение сетки на графике
grid on;
% Подпись оси X:
xlabel('x');
% Подпись оси Y:
ylabel('y');
% Название графика:
title('y1 y2');
% Экспорт рисунка в файл .eps:
print ("plot-sin-cos.eps", "-mono", "-FArial:16", "-deps")
% Экспорт рисунка в файл .png:
print("plot-sin-cos.png");

