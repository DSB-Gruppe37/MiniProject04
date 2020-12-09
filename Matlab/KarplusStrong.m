format short g
clear
Fs = 44.1e3;

Ts = 1 / Fs; % Time resolution
noisePeriod = 2e-3; % 1 ms noise
viewPeriod = 1; % 1 ms output sample

N = floor(noisePeriod * Fs)
N_vek = 0:N - 1;

time_vektor = N_vek * Ts;
noiseVektor = 0.5 - rand(1, N);

sound(noiseVektor)

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
%%%%%%%%%%%%%%%%%%%%%%%%%%N%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DelayTime = 0.1e-3
DelayIndex = floor(DelayTime * Fs)

delayVector = [1;zeros(N-1, 1)];
delayVector(DelayIndex) = 1;


KarplusVektor = conv(noiseVektor, delayVector);
sound(KarplusVektor)


NConv_vek = 0:numel(KarplusVektor) - 1;
time_vektorConv = NConv_vek * Ts;


figure(2); clf;
subplot(2,1,1)
plot(time_vektor*1000, noiseVektor)
subplot(2,1,2)
plot(time_vektorConv*1000,KarplusVektor)
xlabel('Tid [ms]')
% xlim([0 10 * noisePeriod])