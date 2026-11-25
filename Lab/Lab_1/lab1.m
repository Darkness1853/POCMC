% Вариант 16
% Задание 1 ( y(t) = 3sin(2pift+pi/8) f = 12)

t = 0:0.0005:1;
f = 12;
y = 3 * sin(2 * pi * f * t + pi / 8);

figure(1);
plot(t,y);
grid on;
xlabel('t, c');
ylabel('y(t)');
title('№1 Непрерывный сигнал y(t) = 3sin(2pift+pi/8)');

% Задание 2 Макс частота спектра 

fprintf('2) Макс частота в спектре данного сигнала f_max: %d\n', f);

% Задание 3 Мин частота дискретиз по Котельникову

F_s = f * 2;
fprintf('3) По формуле Котельникова F_s >= 2 * f_max \nОтвет %d Гц\n', F_s);

% Задание 4 Оцифровать сигнал с полученной частотой дискретизации

T_s = 1 / F_s;
t_sampled = 0:T_s:1;
y_sampled = 3 * sin(2 * pi * f * t_sampled + pi / 8);

hold on;
stem(t_sampled, y_sampled);
legend('Непрерывный сигнал', 'Отсчеты (Fs = 24 Гц)');

% Задание 5 прямое дискретное преобразование Фурье и оценка ширины спектра

N = length(y_sampled);
Y = abs(fft(y_sampled));
delta_f = F_s / N;
vector = (0:N-1) * delta_f;

fprintf('5) Оценка ширины спектра: пик на 12 Гц имеет ширину 1-2 Гц\n');
V = N * 8;
fprintf('Объем памяти массива = %d байт\n', V);

figure(2);
plot(vector, Y);
grid on;
xlabel('Частота, Гц');
ylabel('Амплитуда');
title('№5 Спектр дискретизированного сигнала (Fs = 24 Гц)');

% Задание 6 График восстановления

figure(3);
plot(t, y);
hold on;
plot(t_sampled, y_sampled);
grid on;
xlabel('t, c');
ylabel('y(t)');
title('№6 График восстановления (Fs = 24 Гц)');
legend('Исходный сигнал', 'Восстановленный');

% Задание 7 Увеличение частоты дискретизации в 4 раза

F_s2 = F_s * 4; % 96 Гц
T_s2 = 1 / F_s2;
t_sampled2 = 0:T_s2:1;
y_sampled2 = 3 * sin(2 * pi * f * t_sampled2 + pi / 8);

% Спектр для 4x частоты
N2 = length(y_sampled2);
Y2 = abs(fft(y_sampled2));
delta_f2 = F_s2 / N2;
vector2 = (0:N2-1) * delta_f2;

V2 = N2 * 8;
fprintf('7) Объем памяти массива при 4x F_s = %d байт\n', V2);

figure(4);
plot(vector2, Y2);
grid on;
xlabel('Частота, Гц');
ylabel('Амплитуда');
title('№7 Спектр при F_s = 96 Гц');

% График восстановления для 4x частоты
figure(5);
plot(t, y);
hold on;
plot(t_sampled2, y_sampled2);
grid on;
xlabel('t, c');
ylabel('y(t)');
title('№7 График восстановления при F_s = 96 Гц');
legend('Исходный сигнал', 'Восстановленный');

% Задание 9 Считывание аудиофайла
[audio, Fs_audio] = audioread('voice.wav');
audio = audio(:, 1); % берем один канал (моно)
N_audio = length(audio);
T_audio = N_audio / Fs_audio;
fprintf('\n9) Аудио: Fs = %d Гц, Отсчетов = %d, Длительность = %.3f с\n', Fs_audio, N_audio, T_audio);

% Задание 10 Определение частоты дискретизации
Fs_calc = N_audio / T_audio;
fprintf('10) Вычисленная Fs = %.1f Гц, из audioread = %d Гц\n', Fs_calc, Fs_audio);

% Задание 11 Прореживание и воспроизведение
audio_down = downsample(audio, 10);
Fs_down = Fs_audio / 10;
zvuk = audioplayer(audio_down, Fs_down);
% play(zvuk); % воспроизведение (stop(zvuk) для остановки)

figure(6);
plot(audio_down);
grid on;
title('№11 Прореженный сигнал во времени');
xlabel('Отсчеты');
ylabel('Амплитуда');

% Задание 12 Спектры оригинального и прореженного сигналов
% Спектр оригинала
N_a = length(audio);
X_a = abs(fft(audio));
f_a = (0:floor(N_a/2)) * (Fs_audio / N_a);
A_orig = X_a(1:floor(N_a/2)+1);
A_orig = A_orig / max(A_orig); % нормировка

% Спектр прореженного сигнала
N_d = length(audio_down);
X_d = abs(fft(audio_down));
f_d = (0:floor(N_d/2)) * (Fs_down / N_d);
A_down = X_d(1:floor(N_d/2)+1);
A_down = A_down / max(A_down); % нормировка

figure(7);
subplot(2,1,1);
plot(f_a, A_orig);
grid on;
xlabel('Частота, Гц');
ylabel('Амплитуда');
title(sprintf('№12 Спектр оригинала (Fs = %d Гц)', Fs_audio));
xlim([0, 8000]); % расширенный речевой диапазон

subplot(2,1,2);
plot(f_d, A_down);
grid on;
xlabel('Частота, Гц');
ylabel('Амплитуда');
title(sprintf('№12 Спектр прореженного сигнала (Fs = %d Гц)', Fs_down));
xlim([0, Fs_down/2]);

% Задание 13 Влияние разрядности АЦП (квантование по уровню)
bits = [3, 4, 5, 6];
y_in = y_sampled2; % отсчеты сигнала варианта при F_s = 96 Гц
y_min = min(y_in);
y_max = max(y_in);

figure(8);
for i = 1:length(bits)
    b = bits(i);
    levels = 2^b - 1;
    
    % Квантование отсчетов в диапазон 0..levels
    y_scaled = (y_in - y_min) / (y_max - y_min) * levels;
    y_q = round(y_scaled);
    y_q = min(max(y_q, 0), levels);
    
    % Восстановление к шкале для расчета ошибки
    y_deq = y_q / levels * (y_max - y_min) + y_min;
    
    % Средняя ошибка квантования
    mean_err = mean(abs(y_in - y_deq));
    fprintf('13) Разрядность %d бит (%d уровней): средняя ошибка = %.4f\n', b, levels+1, mean_err);
    
    % Спектр квантованного сигнала
    Y_q = abs(fft(y_deq));
    
    subplot(2, 2, i);
    plot(vector2, Y_q);
    grid on;
    title(sprintf('№13 Спектр %d бит (ошибка: %.4f)', b, mean_err));
    xlabel('Частота, Гц');
    ylabel('Амплитуда');
end
