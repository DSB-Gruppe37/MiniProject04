function KSPluckSound = KSPluck(Tone, Duration, Fs)
  
  DEFAULT_TONE = 110; % C note
  DEFAULT_DURATION = 2;
  DEFAULT_SAMPLERATE = 20e3;
  
  if nargin < 1
    Tone = DEFAULT_TONE;
  end
  
  if nargin < 2
    Duration = DEFAULT_DURATION;
  end
  
  if nargin < 3
    Fs = DEFAULT_SAMPLERATE;
  end
  
  PValue = round(Fs / (Tone + 0.5));
  % Adding the initial conditions
  y = [(randi([0 1], [1, PValue]).*2 - 1) zeros(1, Fs * Duration)];
  % y = [ones(1,Fs*Duration)];
  OutputLength = numel(y);
  
  PrevValue = 0; % Avoid the negative index at y(1)
  
  for idx = PValue + 1:PValue + OutputLength
    y(idx) = (y(idx - PValue) + PrevValue) / 2;
    PrevValue = y(idx - PValue);
  end
  
  note = y;
  %% Subtract the DC offset
  note = note - mean(note);
  %% Normalize the sound ; Range [0:1]
  note = note / max(abs(note)); % Normalization
  
  KSPluckSound = note;
  
end
