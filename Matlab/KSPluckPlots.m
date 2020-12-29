clear
Fs = 20e3;

PluckSound1 = KSPluck(82.41, 3); % e
PluckSound2 = KSPluck(110.00, 3); % A
PluckSound3 = KSPluck(146.83, 3); % D
PluckSound4 = KSPluck(196.00, 3); % G
PluckSound5 = KSPluck(246.94, 3); % B
PluckSound6 = KSPluck(329.63, 3); % E
PluckList = [PluckSound1, PluckSound2, PluckSound3, PluckSound4, PluckSound5, PluckSound6];

% filename = ['SynthesizedGuitarStrings_', num2str(Fs), 'Hz_.wav'];
% audiowrite(filename, PluckList, Fs);

time = ((0:numel(PluckList) - 1) / Fs);

figure(1000); clf;
plot(time, PluckList)
axis tight
grid on
xlabel('Tid [s]')
ylabel('Amplitude')
savefig('StringPlot')

clear PluckList
PluckList = [PluckSound1; PluckSound2; PluckSound3; PluckSound4; PluckSound5; PluckSound6];

figure(1500); clf;
PluckTile = tiledlayout(size(PluckList, 1), 1);
PluckTile.TileSpacing = 'compact';
PluckTile.Padding = 'compact';

for idx = 1:size(PluckList, 1)
    N = length(PluckList(idx, :));
    bins = [0:(N - 1)]; % Antal fft_bins
    freq = bins * (Fs / N); % Frekvensakse
    drum_fft = abs(fft(PluckList(idx, :)));
    drum_fft_norm = 2 * drum_fft / N;
    nexttile
    semilogx(freq(1:0.5 * end), drum_fft_norm(1:0.5 * end));
    xlim([10 10000])
    grid
end

ylabel(PluckTile, 'Amplitude')
xlabel(PluckTile, 'Frekvens [Hz]')
title(PluckTile, {'FFT af syntesiserede guitartoner.', 'Toner: eADGBE'})
savefig('StringFFTComparison')

%%% FFT COMPARE
clear all;
[A, fs_guitar] = audioread('7398__kyster__notes-on-nylon-strings/117708__kyster__a.wav');
N_guitar = length(A);

PluckSound = KSPluck(110.00, 12,fs_guitar); % A with 12 sec duration

N = length(PluckSound);
bins = [0:(N - 1)]; % Antal fft_bins
freq = bins * (fs_guitar / N); % Frekvensakse
pluck_fft = abs(fft(PluckSound));
pluck_fft_norm = 2 * pluck_fft / N;

figure(2500)
semilogx(freq(1:0.5 * end), pluck_fft_norm(1:0.5 * end), 'DisplayName', 'A fra algoritme');

hold on;


A_fft = abs(fft(A(:, 1)'));
bins_guitar = [0:N_guitar - 1]; % Antal fft_bins_guitar
freq_guitar = bins_guitar * (fs_guitar / N_guitar); % Frekvensakse
%% NORMALIZING THE FFT
A_fft_norm = 2 * A_fft / N;
% Plot nylon guitar A note
semilogx(freq_guitar(1:0.5 * end), A_fft_norm(1:0.5 * end),'DisplayName','A fra guitar');
hold off



grid on;
axis tight
xlim([10 10000])
legend('Location','Best')
xlabel('Frequency [Hz]');
ylabel('Magnitude');

sgtitle({'Sammenligning af tonen A (110Hz).',['Samplerate: ',num2str(fs_guitar)]});
savefig('aToneCompare') 







%%%% A tone compare time


time = ((0:numel(PluckSound) - 1) / fs_guitar);
time_guitar = ((0:N_guitar - 1) / fs_guitar);

figure(5000); clf;
plot(time, PluckSound)
axis tight
grid on
xlabel('Tid [s]')
ylabel('Amplitude')
hold on 
plot(time_guitar, A)
hold off
savefig('aToneCompareTime')
