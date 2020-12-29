clear

Fs = 20e3
Octave = 1;
D = [KSPluck(146.83 * Octave, 0.5), zeros(1, 1.5 * Fs)];
S = [zeros(1, Fs * 0.5), KSPluck(153.56 * Octave, 0.5) zeros(1, Fs * 0.5)];
B = [zeros(1, Fs), KSPluck(123.47 * Octave, 0.5)];
DSBseq = D + S + B;
DSBPlayer = audioplayer(DSBseq, Fs);
playblocking(DSBPlayer);
filename = ['DSB.wav'];
audiowrite(filename, DSBseq, Fs);
