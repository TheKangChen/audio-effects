function [y] = chorus(input,coeff,delay,lfoFreq,lfoRange)

fs = 44100;
input = input(:,1);
len = length(input);

% Convert millisecond in to samples
dlySamples = round(delay * fs);

% Make sure delay sample doesn't exceed buffer size
bufferSize = (dlySamples + lfoRange + 1);
yBuffer = zeros(1,bufferSize);

for i = 1:len
    % lfo range
    lfo = round(lfoRange*sin(2*pi*lfoFreq*(i/fs)));
    % filter signal
    y(i) = input(i) + coeff*(yBuffer(dlySamples + lfo) + yBuffer(dlySamples + lfo + 1));
    
    % update delay line:
    for j = (length(yBuffer)-1):-1:1
        yBuffer(j+1) = yBuffer(j);
    end

    yBuffer(1) = y(i); % store current sample to delay buffer
end

end

