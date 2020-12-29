%%---FuncStart---
function KSPluckSound = KSPluck(Tone, Duration, Fs)
    %KSDrum - Description
    %
    % Syntax: KSDrumSound = KSDrum(PValue,Duration,Fs)
    % All parameters are optional!
    %
    %
    % Algorithm based on Kevin Karplus & Alexander Strong's
    % design - this method covers the Plucked string algorithm
    %
    % Setting default values, thereby allowing parameterless call of the function
    DEFAULT_TONE = 110; % A note
    DEFAULT_DURATION = 1;
    DEFAULT_SAMPLERATE = 20e3;

    %% Checking for parameter input
    if nargin < 1
        Tone = DEFAULT_TONE;
    end

    if nargin < 2
        Duration = DEFAULT_DURATION;
    end

    if nargin < 3
        Fs = DEFAULT_SAMPLERATE;
    end
    %%---ValidationEnd---

    %%---ToneStart---
    PValue = round(Fs / (Tone + 0.5));
    %%---ToneEnd---

    % Adding the initial conditions
    % A set of random integers with range [-1:1] - extra zeros added for duration addtion.
    %%---InitialStart---
    A = 1;
    u = (randi([0, 1], [1, PValue]) .* 2 - 1);
    AddDuration = round(Fs * Duration) - PValue;
    zeroAdd = zeros(1, AddDuration);
    x = [A * u, zeroAdd];
    %%---InitialEnd---
    y = zeros(1, numel(x));
    OutputLength = numel(y);
    disp(['Duration of sample: ', num2str(OutputLength / Fs), 'sec.'])

    %%---PluckStart---
    % Avoid the negative index at y(1)
    PrevValue = 0;
    % Using a 2-tap averagering algorithm
    % the output is created - note the offset of the index.
    % This way negative index is avoided.
    for idx = PValue + 1:PValue + OutputLength
        y(idx) = x(idx - PValue) + (y(idx - PValue) + PrevValue) / 2;
        PrevValue = y(idx - PValue);
    end

    %%---PluckEnd---

    %%---OutputStart---
    % Skip the initial condition
    y = y(PValue:end);
    %% Subtract the DC offset
    y = y - mean(y);
    %% Normalize the sound ; Range [0:1]
    y = y / max(abs(y)); % Normalization
    KSPluckSound = y;
    %%---OutputEnd---
end

%%---FuncEnd---
