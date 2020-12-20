function KarplusSound = KarplusStrong_ah(Tone, SampleRate, duration)

    %KarplusStrong - Description
    %
    % Syntax:  KarplusStrong(Tone,SampleRate,N,Duration)
    %
    % Long description
    % All parameters are optional.
    % If none given:
    % KarplusStrong(110,20e3,4096,0.25)

    DEFAULT_TONE = 110; % C note
    DEFAULT_SAMPLERATE = 48000;
    DEFAULT_DURATION = 1;

    if nargin < 1
        Tone = DEFAULT_TONE;
    end

    if nargin < 2
        SampleRate = DEFAULT_SAMPLERATE;
    end

    if nargin < 3
        duration = DEFAULT_DURATION;
    end

    F_nyquist = SampleRate / 2;

    N = 4096
    %% Create time vector
    f_res = SampleRate / N

    % Create frequency axis
    f_vek = linspace(f_res, F_nyquist, N);

    %%% TONE SELECTOR
    % What bin is Tone located at ?

    PValue = ceil(SampleRate / (Tone + 0.5));
    disp(['The value p: ', num2str(PValue)])

    wavetable = [randi([0, 1], [1, PValue])];

    inputVector = [wavetable ...
                    zeros(1, round(PValue^3/8^2)) ...% Stop at the 8 th harmonic
                ];

    %% Filter properties
    % Normalizing the frequency for tone - newr ange [0:1]
    freqNormalized = 1 / PValue;
    filterOrder = 52;
    %%%%
    normFreqVector = [0 ...
                        freqNormalized ...
                        16 * freqNormalized ...
                        1];
    ampVektor = [0 0 1 1 ];
    % Create coefficients for the filter
    bCoeff = fir2(filterOrder, normFreqVector, ampVektor);

    bCoeffFreqz = figure(8); clf
    bCoeffFreqz.Name = 'B Coeffiecients Freqz view';
    freqz(bCoeff, 1, f_vek, SampleRate)

    % bCoeff = firls(filterOrder, normFreqVector, AmpVector);
    aCoeff = [1 zeros(1, floor(PValue)) -0.5 -0.5];
    % aCoeff = [1 zeros(1, floor(PValue)) -0.5 -0.5];

    abCoeffFreqz = figure(9); clf;
    abCoeffFreqz.Name = 'A & B Coefficients Freqz view';
    freqz(1, aCoeff, f_vek, SampleRate);
    abCoeffImpz = figure(10); clf;
    abCoeffImpz.Name = 'A & B Coefficients impz view';
    impz(bCoeff, aCoeff, SampleRate);

    weightVector = rand(max(length(bCoeff), length(aCoeff)) - 1, 1); %%

    % note = filter(bCoeff, aCoeff,[inputVector zeros(1,round(PValue^3/4))] );
    note = filter(bCoeff, aCoeff, inputVector, weightVector);

    %% Subtract the DC offset
    note = note - mean(note);
    %% Normalize the sound ; Range [0:1]
    note = note / max(abs(note)); % Normalization
    %% Return the Karplus sound
    KarplusSound = note;
end
