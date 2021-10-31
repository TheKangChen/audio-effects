% Karplus Strong String Synthesis

fs = 44100;

y = kpsSynth(440,0.99,0.5,fs);
sound(y,fs);

function [output] = kpsSynth(freq,amp,weighting,fs)

% Noise ping
% Noise duration
sec = 0.02;
duration = round(sec * fs); % Time in samples
noise = (rand(1,duration) - 0.5) * 2;

len = length(noise);

% Input zero padding to let string ring out
outLen = len * 3000;
inputPad = [noise (zeros(1, outLen - len))];

% Make sure the sample is int
delay = floor(fs/freq);

output = inputPad;
for i = (delay + 2):outLen
    % Difference equation
    output(i) = inputPad(i) + amp * (weighting * output(i - delay) + (1 - weighting) * output(i - delay - 1));
end
end