clear
format short g
% Fs = 44.1e3; % Sample frequency
% Fs = 44.1e3; % Sample frequency
Fs = 10e3; % Sample frequency
N = 4096; % 2^12 - number of samples
ToneC4 = 262% Setting tone frequency
ToneA4 = 440% Setting tone frequency
MaxFrequency = 5e3

x = zeros(Fs * 8, 1);


t_res = 1 / Fs; % Time resolution
f_res = Fs / N% Frequency resolution

% Create time axis
t_vek = linspace(t_res, MaxFrequency, N);

%% FFT Settings
bins = [0:N - 1]; % Antal fft_bins
f_vek = bins * f_res; % Frekvensakse

% What bin is C4 located at ?
C4Bin = round(Fs / ToneC4)
A4Bin = round(Fs / ToneA4)


%% Filter properties
filterOrder = 64;
% Normalizing the frequency for C4 - new range [0:1]
C4freqNorm = 1 / C4Bin; 
C5freqNorm = 2 / C4Bin;

% Normalizing the frequency for A4 - new range [0:1]

% process the first 
normFreqVector = [0, C4freqNorm, C5freqNorm, 1];
AmpVector = [0, 0, 1, 1];

% Create coefficients for the filter 
bCoeff = firls(filterOrder, normFreqVector, AmpVector);

% Include the first sample - exclude samples during the delay and mean the two samples lastly read 
aCoeff = [1, zeros(1, round(C4Bin)), -0.5, -0.5];

% [1 000000000000000000000000000000 -0.5,-0.5]
figure(1); clf
freqz(bCoeff, aCoeff, t_vek, Fs);
title('C Tone - Frequency domain');

[H, W] = freqz(bCoeff, aCoeff, t_vek, Fs);



figure(2); clf
plot(W, 20 * log10(abs(H)));
title('C Tone - Frequency domain');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
grid on

%%% Filter creation

noiseVektor = rand(max(length(aCoeff), length(bCoeff)) - 1, 1);

note = (filter(bCoeff,aCoeff,x,noiseVektor));
note = note - mean(note);
note = note / max(abs(note)); % Normalization
length(note)
time = 1:(length(note));
length(time)
figure(2);
plot(time*t_res,note)
xlabel('Time (s)')
hplayer = audioplayer(note, Fs); play(hplayer)



%% Tanke

%% Kort delay (~ 5-10 ms)
%% Filter med lowpass
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       ||| SIGNAL FLOW |||                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% | Noise burst | --(+)-------------------------------/---> |Karplus strong output|
%                   ^                               v
%                  |--<--|Filter| <-- |Delay|<-----|
% %%%%%%%%%%%%%%%%%%%%%%%%%%N%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DelayTime = 0.1e-3
% DelayIndex = floor(DelayTime * Fs)

% delayVector = [1; zeros(N - 1, 1)];
% delayVector(DelayIndex) = 1;

% KarplusVektor = conv(noiseVektor, delayVector);
% sound(KarplusVektor)

% NConv_vek = 0:numel(KarplusVektor) - 1;
% time_vektorConv = NConv_vek * Ts;

% figure(2); clf;
% subplot(2, 1, 1)
% plot(time_vektor * 1000, noiseVektor)
% subplot(2, 1, 2)
% plot(time_vektorConv * 1000, KarplusVektor)
% xlabel('Tid [ms]')
% % xlim([0 10 * noisePeriod])
