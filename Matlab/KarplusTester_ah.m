clear; clc; workspace;
%% Real guitar part
% %% Comparing open A notes from nylon guitar and synthesized
% % Load A note from nylon guitar and extract samplerate
[A, fs] = audioread('7398__kyster__notes-on-nylon-strings/117708__kyster__a.wav');
N = length(A);
A_fft = abs(fft(A(:, 1)'));
bins = [0:N - 1]; % Antal bins
time = (0:N - 1) / fs;
freq = bins * (fs / N); % Frekvensakse
figure(1); clf;
plot(time, A(:, 1))
title('Tonen A fra guitar')
xlabel('Tid [s]')
ylabel('Amplitude')
axis tight
%% NORMALIZING THE FFT
A_fft_norm = 2 * A_fft / N;

% Plot nylon guitar A note
guitarPlot = figure(2); clf
guitarPlot.Name = 'Guitar Plot'
semilogx(freq(1:0.5 * end), A_fft_norm(1:0.5 * end));
title('FFT at tonen A fra guitar')
grid on;
axis tight
xlabel('Frekvens [Hz]');
ylabel('Spænding [V]');

%%% Karplus strong part
%% Plucked string algorithm 
%% Create tone Structure
Tone.e = 82.41;
Tone.A = 110.00;
Tone.D = 146.83;
Tone.G = 196.00;
Tone.B = 246.94;
Tone.E = 329.63;

%% New sample rate 
% Synthesize the note - note plots will be added ;
A_synth = KarplusStrong_ah(Tone.A, fs);
% Looking at the note
A_synth_fft = abs(fft(A_synth));
N = numel(A_synth);
bins = [0:N - 1]; % Number of fft_bins
freq = bins * (fs / N); % Frekvensakse
time = (0:N - 1) / fs;
A_synth_fft_norm = 2 * A_synth_fft / N;


% % Plot synthesized A note
SynthPlot = figure(3); clf
SynthPlot.Name = 'FFT Karplus Strong';
semilogx(freq(1:0.5 * end), A_synth_fft_norm(1:0.5 * end), 'DisplayName', 'A synthesized');
legend('Location', 'best');
xlim([10 10000])

figure(4); clf
plot(time, A_synth);
% legend('location','best')
% Play A note and synthesized A note
% player = audioplayer([A(:,1); A_synth], fs);
player = audioplayer(A_synth, fs);
playblocking(player);

% %% Twinkle Twinkle
% Fs = 20e3;
% Duration = 0.5;
% PauseDuration = 0.5 * Duration;
% LongPauseDuration = Duration;
% C = KarplusStrong(261.626, Duration);
% D = KarplusStrong(293.665, Duration);
% E = KarplusStrong(329.628, Duration);
% F = KarplusStrong(349.228, Duration, 0.2);
% G = KarplusStrong(391.995, Duration, 0.1);
% A = KarplusStrong(440, Duration);
% B = KarplusStrong(493.883, Duration);
% Ch = KarplusStrong(2 * 261.626, 4 * Duration, 0.4);

% Default = KarplusStrong();

% playArray = [C; D; E; F; G; A;B;Ch];
% SoundPlayer = audioplayer(playArray, Fs)
% play(SoundPlayer)

% Twinkle = [C; C; G; G; A; A; G; zeros(PauseDuration * Fs, 1); F; F; E; E; D; D; C; zeros(PauseDuration * Fs, 1); G; G; F; F; E; E; D; zeros(PauseDuration * Fs, 1); G; G; F; F; E; E; D; zeros(LongPauseDuration * Fs, 1); C; C; G; G; A; A; G; zeros(PauseDuration * Fs, 1); F; F; E; E; D; D; Ch];

% TwinklePlayer = audioplayer(Twinkle, Fs);
% playblocking(TwinklePlayer)
