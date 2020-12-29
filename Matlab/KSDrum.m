function KSDrumSound = KSDrum(PValue, b, Duration, Fs)
    %KSDrum - Description
    %
    % Syntax: KSDrumSound = KSDrum(PValue,b,Duration,Fs)
    % All parameters are optional!
    %
    %
    % Algorithm based on Kevin Karplus & Alexander Strong's
    % design - this method covers the drum algorithm
    %
    %

    % Setting default values, thereby allowing parameterless call of the function
    DEFAULT_PValue = 200;
    DEFAULT_B = 0.5;
    DEFAULT_DURATION = 0.5;
    DEFAULT_SAMPLERATE = 20e3;

    %% Checking for parameter input
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

    %%---InitialStart---
    % Initial condition
    y = [ones(1, Fs * Duration)];

    OutputLength = numel(y);

    %% Used for validating the blend factor
    randomValue = rand(1, OutputLength);
    %%---InitialEnd---

    %%---DrumStart---
    % Avoid the negative index at first run
    PrevValue = 0;

    for idx = PValue + 1:PValue + OutputLength
        % Validate the blend factor
        if randomValue(idx - PValue) <= b
            y(idx) = (y(idx - PValue) + PrevValue) / 2;
        else
            y(idx) = -(y(idx - PValue) + PrevValue) / 2;
        end

        % Assign the current value as the previous for next run.
        PrevValue = y(idx - PValue);
    end
    %%---DrumEnd---

    y = y(PValue:end);
    %% Subtract the DC offset
    y = y - mean(y);
    %% Normalize the sound ; Range [0:1]
    y = y / max(abs(y)); % Normalization

    KSDrumSound = y;

end
