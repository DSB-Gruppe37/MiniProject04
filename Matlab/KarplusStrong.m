function KarplusSound = KarplusStrong(Tone, SampleRate, N, duration)
    %myFun - Description
    %
    % Syntax:  karplusStrong(Tone,SampleRate,N,Duration)
    %
    % Long description
    DEFAULT_TONE = 262; % C4
    DEFAULT_SAMPLERATE = 20e3;
    DEFAULT_N = 4096;
    DEFAULT_DURATION = 4;

    try

        if isempty(Tone)
            Tone = DEFAULT_TONE;
        end

    catch
        Tone = DEFAULT_TONE;
    end

    try

        if isempty(SampleRate)
            SampleRate = DEFAULT_SAMPLERATE;
        end

    catch
        SampleRate = DEFAULT_SAMPLERATE;
    end

    try

        if isempty(N)
            N = DEFAULT_N;
        end

    catch
        N = DEFAULT_N;
    end

    try

        if isempty(duration)
            duration = DEFAULT_DURATION;
        end

    catch
        duration = DEFAULT_DURATION;
    end




    F_nyquist = SampleRate / 2;
    x = zeros(SampleRate * duration, 1);

    t_res = 1 / SampleRate% Time resolution

    % Create time axis
    f_vek = linspace(t_res, F_nyquist, N);

    %%% TONE SELECTOR
    % What bin is Tone located at ?
    DelayBin = floor(SampleRate / Tone)

    %% Filter properties
    % Normalizing the frequency for tone - newr ange [0:1]
    freqNormalized = 1 / DelayBin;
    filterOrder = 20
    
    % process the first
    normFreqVector = [0, freqNormalized, 2*freqNormalized, 1];
    AmpVector = [0, 0, 1, 1];
 

    % Create coefficients for the filter
    bCoeff = firls(filterOrder, normFreqVector, AmpVector);

    Klang = 0.0;

    % Include the first sample - exclude samples during the delay and mean the two samples lastly read
    aCoeff = [1 zeros(1, DelayBin), -0.5 - Klang, -0.5 + Klang + 0.008];
    aCoeff = [1 zeros(1, DelayBin), -0.5, -0.45];

    % [1 000000000000000000000000000000 -0.5,-0.5]
    figure(1); clf
    freqz(bCoeff, aCoeff, f_vek, SampleRate);
    title('C Tone - Frequency domain');

    [H, W] = freqz(bCoeff, aCoeff, f_vek, SampleRate);

    figure(2); clf
    plot(W, 20 * log10(abs(H)));
    title('C Tone - Frequency domain');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    grid on

    %%% Filter creation

    noiseVektor = rand(max(length(aCoeff), length(bCoeff)) - 1, 1);


    note = (filter(bCoeff, aCoeff, x, noiseVektor));
    note = note - mean(note);
    note = note / max(abs(note)); % Normalization

    time = 1:(length(note));
    length(time)
    figure(2);
    plot(time * t_res, note)
    xlabel('Time (s)')
    KarplusSound = audioplayer(note, SampleRate); 
end
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
