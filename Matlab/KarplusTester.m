clear; clc; workspace;

%% Comparing open A notes from nylon guitar and synthesized
% Load A note from nylon guitar
[A, fs] = audioread('7398__kyster__notes-on-nylon-strings/117708__kyster__a.wav');
N = length(A);

A_fft = abs(fft(A(:,1)'));
bins = [0:N - 1]; % Antal fft_bins
freq = bins * (fs / N); % Frekvensakse

%% NORMALIZING THE FFT
A_fft_norm = 2 * A_fft / N;

% Plot nylon guitar A note
figure(1);
semilogx(freq(1:0.5 * end), A_fft_norm(1:0.5 * end));
title('A')
grid on;
axis tight
xlabel('Frekvens [Hz]');
ylabel('Spænding [V]');
hold on;

% Synthesize A note
duration = length(A) / fs;
A_synth = KarplusStrong(110, duration, 0, fs);
A_synth_fft = abs(fft(A_synth));
A_synth_fft_norm = 2 * A_synth_fft / N;

% Plot synthesized A note
semilogx(freq(1:0.5 * end), A_synth_fft_norm(1:0.5 * end));
legend('A', 'A synthesized', 'Location', 'best');
xlim([10 10000])
hold off;

% Play A note and synthesized A note
player = audioplayer([A(:,1); A_synth], fs);
playblocking(player);

%% Twinkle Twinkle
Fs = 20e3;
Duration = 0.5;
PauseDuration = 0.5 * Duration;
LongPauseDuration = Duration;
C = KarplusStrong(261.626, Duration);
D = KarplusStrong(293.665, Duration);
E = KarplusStrong(329.628, Duration);
F = KarplusStrong(349.228, Duration, 0.2);
G = KarplusStrong(391.995, Duration, 0.1);
A = KarplusStrong(440, Duration);
B = KarplusStrong(493.883, Duration);
Ch = KarplusStrong(2 * 261.626, 4 * Duration, 0.4);

Default = KarplusStrong();

% playArray = [C; D; E; F; G; A;B;Ch];
% SoundPlayer = audioplayer(playArray, Fs)
% play(SoundPlayer)

Twinkle = [C; C; G; G; A; A; G; zeros(PauseDuration * Fs, 1); F; F; E; E; D; D; C; zeros(PauseDuration * Fs, 1); G; G; F; F; E; E; D; zeros(PauseDuration * Fs, 1); G; G; F; F; E; E; D; zeros(LongPauseDuration * Fs, 1); C; C; G; G; A; A; G; zeros(PauseDuration * Fs, 1); F; F; E; E; D; D; Ch];

TwinklePlayer = audioplayer(Twinkle, Fs);
playblocking(TwinklePlayer)