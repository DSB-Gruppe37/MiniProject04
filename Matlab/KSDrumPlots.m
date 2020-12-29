Fs = 20e3;

PRange = [32, 64, 128, 256, 512, 1024];
bRange = [0, 0.25, 0.5, 0.75, 1];

for hdx = 1:numel(PRange)
    DrumSound1 = KSDrum(PRange(hdx), bRange(1));
    DrumSound2 = KSDrum(PRange(hdx), bRange(2));
    DrumSound3 = KSDrum(PRange(hdx), bRange(3));
    DrumSound4 = KSDrum(PRange(hdx), bRange(4));
    DrumSound5 = KSDrum(PRange(hdx), bRange(5));
    DrumList = [DrumSound1; DrumSound2; DrumSound3; DrumSound4; DrumSound5];
    figure(hdx * 1000);
    drumTile = tiledlayout(size(DrumList,1),1);
    drumTile.TileSpacing = 'compact';
    drumTile.Padding = 'compact';

    for idx = 1:size(DrumList, 1)
        N = length(DrumList(idx, :));
        bins = [0:(N - 1)]; % Antal fft_bins
        freq = bins * (Fs / N); % Frekvensakse
        drum_fft = abs(fft(DrumList(idx, :)));
        drum_fft_norm = 2 * drum_fft / N;
        nexttile
        semilogx(freq(1:0.5 * end), drum_fft_norm(1:0.5 * end));
        xlim([10 10000])
        title(['b = ',num2str(bRange(idx))])
        grid
    end

    ylabel(drumTile, 'Amplitude')
    xlabel(drumTile, 'Frekvens [Hz]')
    title(drumTile, {['FFT af syntesiserede med forskellige p og dertilhørende blendværdier.'], ['p = ',num2str(PRange(hdx))]})
    savefig(['DrumFFT_p_', num2str(PRange(hdx))])
end


%%%  Time plots

drumTileTime = tiledlayout(numel(PRange), 1);
drumTileTime.TileSpacing = 'compact';
drumTileTime.Padding = 'compact';

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
    filename = ['Drum_P_', num2str(PRange(idx)),'.wav'];
    audiowrite(filename, DrumList, Fs);
    clear DrumList
end

title(drumTileTime, {'Karplus Strong trommesyntese', ...
                ' Blend:[0, 1/4, 1/2, 3/4, 1]', ...
                ['Sample rate: ', num2str(Fs), 'Hz']
            })
xlabel(drumTileTime, 'Tid [s]')
ylabel(drumTileTime, 'Amplitude')

savefig('DrumPValueComparison')
