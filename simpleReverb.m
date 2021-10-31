% Basic Reverb Implementation
% Using Schroeder's reverb algorithm

[x, fs] = audioread('Gt_Riff.wav');

xVerb = reverb(x,0.8,0.75,fs);
sound(xVerb,fs);


function [output] = reverb(input,a,b,fs)
% Schroeder reverb algorithm
% Sum of 4 IIR comb filter put through 2 sequence of all-pass filter

% Make sure the filter is in functional range
if a < 0 || a >= 1
    disp("a has to be in range: 0 <= a < 1");
    return;
end

if b < 0 || b >= 1
    disp("b has to be in range: 0 <= b < 1");
    return;
end

len = length(input);

    function [output] = combfilt(input,delay,coeff)
        % Make sure the sample is int
        delaySamp = round(delay *fs);
        
        % Make sure the filter is in functional range
        if coeff >= 1
            disp("coefficient must be smaller than 1");
            return;
        elseif coeff < 0
            disp("coefficient must be larger than 0");
            return;
        end
        
        % Implement basic comb filter equation
        output = input;
        for i = (delaySamp + 1):len
            output(i) = input(i) + coeff * output(i - delaySamp);
        end
    end

% Calaulate the mean of parellel comb filters
comb1 = combfilt(input,0.02,0.5);
comb2 = combfilt(input,0.035,0.4);
comb3 = combfilt(input,0.04,0.2);
comb4 = combfilt(input,0.045,0.1);

combSum = (comb1 + comb2 + comb3 + comb4) / 4;

% Round to sample
delay1 = round(0.3 * fs);
delay2 = round(0.1 * fs);


% 2 sequenced all-pass filter
output = input;
for k = (delay1+1):len
    output(k) = a * combSum(k) + combSum(k - delay1) - a * output(k - delay1);
    output(k) = b * output(k) + output(k - delay2) - b * output(k - delay2);
end
end

