clear

DrumSound1 = KSDrum(); 
DrumSound2 = KSDrum(200,0.1); 
DrumSound3 = KSDrum(200,0.5); 
DrumSound4 = KSDrum(200,0.9); 
Pluck = KSPluck();

Fs = 20e3;

player = audioplayer([DrumSound1 DrumSound2 DrumSound3 DrumSound4], Fs);
% player = audioplayer([DrumSound Pluck], Fs);
% player = audioplayer([DrumSound Pluck], Fs);
% player = audioplayer([DrumSound Pluck], Fs);
playblocking(player);
