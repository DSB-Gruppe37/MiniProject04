clear; close all;
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
savefig('Pluck_AllStrings')

clear PluckList
PluckList = [PluckSound1; PluckSound2; PluckSound3; PluckSound4; PluckSound5; PluckSound6];

figure(1500); clf;
set(gcf, 'PaperUnits', 'centimeters', 'PaperSize', [14 20], 'PaperPosition', [0 0 14 20]);
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
savefig('Pluck_FFTComparison')

%%% FFT COMPARE
clear; clc;
%% Comparing open guitar string notes from nylon guitar and synthesized
Notes = {};

% Load A2 note from nylon guitar
[samples, fs] = audioread('7398__kyster__notes-on-nylon-strings/117708__kyster__a.wav');
N = length(samples);
Notes{1,1} = struct(...
  'name', 'A2', 'harmonic', 110, ...
  'samples', ((samples(:, 1) + samples(:, 2)) / 2)', ... % Stereo to mono
  'fs', fs, 'N', N);

% Load D3 note from nylon guitar
[samples, fs] = audioread('7398__kyster__notes-on-nylon-strings/117713__kyster__d.wav');
N = length(samples);
Notes{1,2} = struct(...
  'name', 'D3', 'harmonic', 147, ...
  'samples', ((samples(:, 1) + samples(:, 2)) / 2)', ... % Stereo to mono
  'fs', fs, 'N', N);

% Load G3 note from nylon guitar
[samples, fs] = audioread('7398__kyster__notes-on-nylon-strings/117693__kyster__1-oct-g.wav');
N = length(samples);
Notes{1,3} = struct(...
  'name', 'G3', 'harmonic', 196, ...
  'samples', ((samples(:, 1) + samples(:, 2)) / 2)', ... % Stereo to mono
  'fs', fs, 'N', N);

for idx = 1:numel(Notes)
  note = Notes{1,idx};
  N = note.N;
  fs = note.fs;

  % FFT of the note
  note_fft = abs(fft(note.samples));
  bins = [0:N - 1]; % Antal fft_bins
  freq = bins * (fs / N); % Frekvensakse

  %% NORMALIZING THE FFT
  note_fft_norm = 2 * note_fft / N;

  % Plot nylon guitar A note
  figure(2500 + idx);
  semilogx(freq(1:0.5 * end), note_fft_norm(1:0.5 * end), 'LineWidth', 2);
  grid on;
  axis tight
  xlabel('Frequency [Hz]');
  ylabel('Magnitude');
  hold on;

  % Synthesize A note
  duration = N / fs;
  note_synth = KSPluck(note.harmonic, duration, fs);
  note_synth = note_synth(1:N);
  note_synth_fft = abs(fft(note_synth));
  note_synth_fft_norm = 2 * note_synth_fft / N;

  % Plot synthesized A note
  semilogx(freq(1:0.5 * end), note_synth_fft_norm(1:0.5 * end));
  legend([note.name, ' nylon string'], [note.name, ' synthesized'], 'Location', 'best');
  xlim([10 10000])
  hold off;

  title({['Sammenligning af tonen ', note.name, ' (', num2str(note.harmonic), 'Hz).'],['Samplerate: ',num2str(fs)]});
  savefig(['Pluck_Compare_', note.name,'_FFT']);

  %%%% Time comparison of tones
  time = ((0:numel(note_synth) - 1) / fs);
  time_guitar = ((0:N - 1) / fs);

  figure(5000 + idx); clf;
  plot(time, note_synth)
  axis tight
  grid on
  xlabel('Tid [s]')
  ylabel('Amplitude')
  hold on 
  plot(time_guitar, note.samples)
  hold off
  savefig(['Pluck_Compare_', note.name, '_Time'])
end


