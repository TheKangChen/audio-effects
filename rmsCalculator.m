function [output] = rmsCalculator(input,winSize)

len = length(input);
winTxt = num2str(winSize);

winNum = 1;
startPos = 1;
endPos = winSize;

% memory alocation
output = zeros(floor(len/winSize),1);

% Calculation: root, mean, square
for i = 1:winSize:len
    output(winNum) = (mean(input(startPos:endPos).^2)).^0.5;
    startPos = startPos + winSize;
    endPos = endPos + winSize;
    winNum = winNum +1;
    
    if endPos > len
        break;
    end
end

figure('Name','RMS','NumberTitle','off');

plot(output); grid on;
xlabel('Window Count');
overText = {['Window Size: ' winTxt]};
text(60,0.075,overText);
end

