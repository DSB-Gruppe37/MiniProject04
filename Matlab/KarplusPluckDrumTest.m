clear
Fs = 20e3;

% PluckSound1 = KSPluck(82.41, 1); % e
% PluckSound2 = KSPluck(110.00); % A
% PluckSound3 = KSPluck(146.83); % D
% PluckSound4 = KSPluck(196.00); % G
% PluckSound5 = KSPluck(246.94); % B
% PluckSound6 = KSPluck(329.63, 5); % E
% PluckList = [PluckSound1, PluckSound2, PluckSound3, PluckSound4, PluckSound5, PluckSound6];
% player = audioplayer(PluckList, Fs);
% playblocking(player);

PRange = [32, 64, 128, 256, 512, 1024];
drumTile = tiledlayout(numel(PRange), 1);
drumTile.TileSpacing = 'compact';
drumTile.Padding = 'compact';

for idx = 1:numel(PRange)
    DrumSound1 = KSDrum(PRange(idx), 0.0);
    DrumSound2 = KSDrum(PRange(idx), 0.25);
    DrumSound3 = KSDrum(PRange(idx));
    DrumSound4 = KSDrum(PRange(idx), 0.75);
    DrumSound5 = KSDrum(PRange(idx), 1);

    DrumList = [DrumSound1, DrumSound2, DrumSound3, DrumSound4, DrumSound5];

    time = ((0:numel(DrumList) - 1) / Fs);
    
    nexttile
    plot(time, DrumList)
    axis tight
    title(['p = ', num2str(PRange(idx))])
    filename = ['Drum_P_', num2str(PRange(idx)), '.wav'];
    audiowrite(filename, DrumList, Fs);
    clear DrumList
end
title(drumTile, {'Karplus Strong trommesyntese',...
            ' Blend:[0, 1/4, 1/2, 3/4, 1]', ...
                ['Sample rate: ', num2str(Fs),'Hz']
})
xlabel(drumTile, 'Tid [s]')
ylabel(drumTile, 'Amplitude')

savefig('PValueComparison')

% A_synth = KSDrum(400, 0.5, 0.5);
% % Looking at the note
% A_synth_fft = abs(fft(A_synth));
% N = numel(A_synth);
% bins = [0:N - 1]; % Number of fft_bins
% freq = bins * (Fs / N); % Frekvensakse
% time = bins / Fs;
% A_synth_fft_norm = 2 * A_synth_fft / N;
% % % Plot synthesized A note
% SynthPlot = figure(200); clf
% SynthPlot.Name = 'FFT Karplus Strong drum';
% semilogx(freq(1:0.5 * end), A_synth_fft_norm(1:0.5 * end), 'DisplayName', 'Drum');
% legend('Location', 'best');

% player = audioplayer(A_synth, Fs);
% playblocking(player);
