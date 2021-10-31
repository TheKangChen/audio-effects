% FM Synthesis

fs = 44100;

% Signal duration
sec = 1;
duration = round(sec * fs); % Time in samples

% Carrier freq
fc = 1000;
% Modulator freq
fm = 440;


% AD envelope/function generator
% Function generator for FM modulation
envLenght = 100;
modAttackLen = 1;
modAttackTime = modAttackLen/envLenght * duration; % In samples
modDecayTime = (envLenght - modAttackLen)/100 * duration; % In samples

% Function generator for amplitude modulation
ampAttackLen = 1;
ampAttackTime = ampAttackLen/envLenght * duration; %In samples
ampDecayTime = (envLenght - ampAttackLen)/100 * duration; %In samples

modEnv = [linspace(0,1,modAttackTime) linspace(1,0,modDecayTime)];
ampEnv = [linspace(0,1,ampAttackTime) linspace(1,0,ampDecayTime)];


% FM Synthesis
z = fmSynth(fm,fc,modEnv,ampEnv,duration);
sound(z,fs);


function [output] = fmSynth(fm,fc,modEnv,ampEnv,duration)
fs = 44100;

% Carrier Amplitude
ac = 1;
% Modulator Amplitude
am = 5000;

for i=1:duration
    
    % Difference equation
    y(i) = ampEnv(i) * ac * cos(2 * pi * fc * i/fs + modEnv(i) * am/fm * sin(2 * pi * fm * i/fs));
end

output = y / max(abs(y));
end