clear all

Fs = 44100;
A = 440; % The A string of a guitar is normally tuned to 110 Hz

F = linspace(1 / Fs, 1000, 2^12);

x = zeros(Fs * 4, 1);

delay = round(Fs / A);

b = firls(32, [0, 1 / delay, 2 / delay, 1], [0 0 1 1]);
a = [1, zeros(1, delay), -0.5, -0.5];

[H, W] = freqz(b, a, F, Fs);
plot(W, 20 * log10(abs(H)));
title('Harmonics of an open A string');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');



zi = rand(max(length(b), length(a)) - 1, 1);
note = filter(b, a, x, zi);

note = note - mean(note);
note = note / max(abs(note));
figure(2); 
plot(note)
hplayer = audioplayer(note, Fs); play(hplayer)


