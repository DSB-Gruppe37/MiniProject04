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