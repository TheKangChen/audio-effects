function [output] = quantizer(in, bits)

% Bit resolution inlcuding 0 is 2^bits
% Scaling needs to be 1 less than bit res. for quantizing
bitRes = 2^bits - 1;

% Shift everything to 0 and above
minIn = min(in);

if minIn < 0
    inShift = in - minIn;
elseif minIn > 0
    inShift = in - minIn;
end

len = length(in);

for i = 1:len
    
    quant(1,i) = round(inShift(1,i) / 2 * bitRes) / bitRes;
    
end

output = (quant - (max(quant) - min(quant)) / 2) * 2;

end
