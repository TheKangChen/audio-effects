function [y] = chorusFrac(input,coeff,delay,lfoFreq,lfoRange,weighting)

% Chorus with fraction delay

fs = 44100;
input = input(:,1);
len = length(input);

if weighting > 1 || weighting < 0
    disp('Weighting must be <= 1!');
    return;
end

% Convert millisecond in to samples
dlySamples = floor(delay * fs);

% Make sure delay sample doesn't exceed buffer size
bufferSize = (dlySamples + lfoRange + 1);
yBuffer = zeros(1,bufferSize);

for i = 1:len
    % lfo range
    lfo = round(lfoRange*sin(2*pi*lfoFreq*(i/fs)));
    % filter signal
    y(i) = input(i) + coeff*(weighting * yBuffer(dlySamples + lfo) + (1 - weighting) * yBuffer(dlySamples + 1 + lfo));
    
    % update delay line:
    for j = (length(yBuffer)-1):-1:1
        yBuffer(j+1) = yBuffer(j);
    end

    yBuffer(1) = y(i); % store current sample to delay buffer
end

end

