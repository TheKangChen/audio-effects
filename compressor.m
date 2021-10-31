function [output] = compressor(input,thresh,slope,gainMatch)

len = length(input);
gm = 'gainmatch';
off = ' off';
on = ' on';

%Retain signs of each sample
sigSign = sign(input);
absInput = abs(input);

%Setting the treshold of input signal
threshold = thresh * max(absInput);

%memory alocation
[rows,cols] = size(input);
comp = zeros(rows,cols);

%Compression calculation
for i = 1:len
    if absInput(i) > threshold
        comp(i) = absInput(i) * slope;
    else
        comp(i) = absInput(i);
    end
end

%compute compression amount for gain matching
compAmount = max(absInput) - max(comp);
compPortion = max(absInput) / max(comp);

%Auto gain matching on or off
if nargin == 3
    output = comp .* sigSign;
    onText = append(gm,off);
elseif nargin == 4 || gainMatch == gm
    output = (comp * compPortion) .* sigSign;
    onText = append(gm,on);
end

figure('Name','Compressor','NumberTitle','off');
hold on;
plot(input); plot(output); grid on;
xlabel('Time');
text(70000,-0.225,onText);
legend('Original','Compressed');
end

