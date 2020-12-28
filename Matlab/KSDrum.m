function KSDrumSound = KSDrum(PValue,b,Duration,Fs)

    DEFAULT_PValue = 200; % C note
    DEFAULT_B = 0.5;
    DEFAULT_DURATION = 0.4;
    DEFAULT_SAMPLERATE = 20e3;
    if nargin < 1
        PValue = DEFAULT_PValue;
    end

    if nargin < 2
        b = DEFAULT_B;
    end

    if nargin < 3
        Duration = DEFAULT_DURATION;
    end
    if nargin < 4
        Fs = DEFAULT_SAMPLERATE;
    end

    
    % Adding the initial conditions
    y = [randi([0, 1], [1, PValue]) zeros(1, Fs * Duration)];
    % y = [ones(1,Fs*Duration)];
    OutputLength = numel(y);


    randomValue = rand(1, OutputLength);

    PrevValue = 0; % Avoid the negative index at y(1)

for idx = PValue + 1:PValue + OutputLength

    if randomValue(idx - PValue) <= b
        y(idx) = (y(idx - PValue) + PrevValue) / 2;
    else
        y(idx) = -(y(idx - PValue) + PrevValue) / 2;
    end

    PrevValue = y(idx - PValue);
end

note = y;
%% Subtract the DC offset
note = note - mean(note);
%% Normalize the sound ; Range [0:1]
note = note / max(abs(note)); % Normalization

KSDrumSound = note;

end