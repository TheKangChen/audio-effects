function biQuadGUI

[x,fs] = audioread('Gt_Riff.wav');

%GUI
figure('Name','Bi-Quad Wah-Wah Effect',...
       'NumberTitle','off',...
       'position',[700 400 400 300]);

comment = uicontrol('Style','text',...
                    'position',[20 270 360 20],...
                    'String','BI-QUAD WAH-WAH EFFECT (recommended setting)');

%Slider for frequency adjustment
cfText = uicontrol('Style','text',...
                   'position',[20 240 360 20],...
                   'String','Center Frequency (0 ~ fs/2 hz)');
cfSlider = uicontrol('Style','slider',...
                     'position',[20 220 360 20],...
                     'Value',0.09,...
                     'String','Center Frequency');

%Slider for Q value adjustment
qText = uicontrol('Style','text',...
                  'position',[20 190 360 20],...
                  'String','Q Value (0 ~ 1)');
qSlider = uicontrol('Style','slider',...
                    'position',[20 170 360 20],...
                    'Value',0.98,...
                    'String','Q Value');

%Slider for gain adjustment
gainText = uicontrol('Style','text',...
                     'position',[20 140 360 20],...
                     'String','Input Gain (x0 ~ x2)');
gainSlider = uicontrol('Style','slider',...
                     'position',[20 120 360 20],...
                     'Value',0.5,...
                     'String','Input Gain');

%Slider for wah wah speed
wahText = uicontrol('Style','text',...
                    'position',[20 90 360 20],...
                    'String','Wah Wah Speed (0 ~ 10 hz)');
wahSlider = uicontrol('Style','slider',...
                     'position',[20 70 360 20],...
                     'Value',0.25,...
                     'String','Wah Wah Speed');

%Run button to run bi-quad filter
runButton = uicontrol('position',[150 15 100 40],...
                      'String','Run');
runButton.Callback = @run;

    function run(h,evt)
        f0 = (cfSlider.Value) * fs/2;
        q = (qSlider.Value) * 0.999; %Make sure <1 so it doesn't feedback
        if q == 1
            disp('Q value needs to be smaller');
            return;
        end
        gain = (gainSlider.Value) * 2;
        lfoFreq = (wahSlider.Value) * 10;
        biQuad(x,f0,q,gain,lfoFreq,fs);
    end
end

function output = biQuad(input,f0,q,gain,lfoFreq,fs)

input = input(:,1);
len = length(input);

lfoRange = 500;

x = input * gain;
y = input;

for i = 3:len
    %LFO for automatic wah wah
    lfo = round(lfoRange * sin(2 * pi * lfoFreq * (i/fs)));
    %Frequency in radians
    wT = 2 * pi * (f0 + lfo) * 1/fs;
    
    %Difference equation
    y(i) = x(i) - x(i - 2) + 2 * q * cos(wT) * y(i - 1) - q^2 * y(i - 2);
end

output = y;
sound(y,fs);

%Difference equation coefficient
b = [1 0 -1];
a = [1 -2*q*cos(wT) q^2];
%Frequency and phase response
figure('Name','Frequency & Phase Response','NumberTitle','off');
freqz(b, a)
end
