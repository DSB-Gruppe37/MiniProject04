clear ; clc;

fs  = 8000;
ts = 1/fs;
maxFreq = 1e3;
samples = 1500;
Tone = 220
F = linspace(ts,maxFreq,samples);
x = zeros(fs * 4, 1);
delay = round((fs)/(Tone))
% b  = firls(900, [0 1/delay 2/delay 1], [0 0 1 1 ]);
b  = fir1(42, [1/delay 4/delay]);
figure(8)
freqz(b, 1, F, fs)

a = [1 zeros(1, floor(delay)) -0.5 -0.5];
figure(9)
freqz(b, a, F, fs)
figure(11)
impz(b, a, fs)
[H,W] = freqz(b, a, F, fs);

KarplusExPlot = figure(10);
KarplusExPlot.Name = 'Karplus Strong Example plot'
plot(W, 20 * log10(abs(H)));
title('Harmonics of an open A string');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');



zi = rand(max(length(b), length(a)) - 1, 1);
note = filter(b, a, x, zi);

note = note - mean(note);
note = note / max(abs(note));
figure(102)
plot(note)
xlim([0 1e3])
hplayer = audioplayer(note, fs); play(hplayer)
