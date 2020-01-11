clear, clc, clf,close all;

% switch between matlab's filter() and my own myfilter()
use_myfilter=1;

% read waveform from file
[y, fs]=audioread('../song-8k.wav');
figure
subplot(511); specgram(y, 128, fs); axis('tight');
title('music');

% lowpass filter
bL = [0.0181351303083341,0.0373879040845632,0.0643479859940072,0.0915416322235321 ...
    0.111856034054809,0.119396228080149,0.111856034054809,0.0915416322235321 ...
    0.0643479859940072,0.0373879040845632,0.0181351303083341];
aL = [1 0 0 0 0 0 0 0 0 0 0];
[hL, wL] = freqz(bL,aL,128);
subplot(512);plot(wL/pi*4000,20*log10(abs(hL)));axis([0,4000,-60,5]); grid;
title('Lowpass filter');xlabel('Frequency (Hz)');ylabel('Magnitude (dB)');

% highpass filter
bH = [-0.0235051070803564,0.0484588020089321,-0.0834020090001404,0.118647940827637 ...
    -0.144977621519158,0.154750535468985,-0.144977621519158,0.118647940827637 ...
    -0.0834020090001404,0.0484588020089321,-0.0235051070803564];
aH = [1 0 0 0 0 0 0 0 0 0 0];
[hH, wH] = freqz(bH,aH,128);
subplot(513);plot(wH/pi*4000,20*log10(abs(hH)));axis([0,4000,-60,5]); grid;
title('Highpasss filter');xlabel('Frequency (Hz)');ylabel('Magnitude (dB)');

% Bandpass filter I
bP1 = [0.103624058449792,-0.0196250027252208,-0.168185578205692,-0.153051212152768 ...
    0.0653847312656460,0.203672389042179,0.0653847312656460,-0.153051212152768 ...
    -0.168185578205692,-0.0196250027252208,0.103624058449792];
aP1 = [1 0 0 0 0 0 0 0 0 0 0];
[hP1, wP1] = freqz(bP1,aP1,128);
subplot(514);plot(wP1/pi*4000,20*log10(abs(hP1)));axis([0,4000,-60,5]); grid;
title('Bandpass filter I');xlabel('Frequency (Hz)');ylabel('Magnitude (dB)');

% Bandpass filter II
bP2 = [-0.103624058449792,-0.0196250027252209,0.168185578205691,-0.153051212152768 ...
    -0.0653847312656459,0.203672389042178,-0.0653847312656459,-0.153051212152768 ...
    0.168185578205691,-0.0196250027252209,-0.103624058449792];
aP2 = [1 0 0 0 0 0 0 0 0 0 0];
[hP2, wP2] = freqz(bP2,aP2,128);
subplot(515);plot(wP2/pi*4000,20*log10(abs(hP2)));axis([0,4000,-60,5]); grid;
title('Bandpass filter II');xlabel('Frequency (Hz)');ylabel('Magnitude (dB)');


if use_myfilter==0
    outL = filter(bL, aL, y);
    outH = filter(bH, aH, y);
    outP1 = filter(bP1, aP1, y);
    outP2 = filter(bP2, aP2, y);
else
    outL = myfilter(bL, aL, y);
    outH = myfilter(bH, aH, y);
    outP1 = myfilter(bP1, aP1, y);
    outP2 = myfilter(bP2, aP2, y);
end

figure;
subplot(511); specgram(y, 128, fs); axis('tight');
subplot(512); specgram(outL, 128, fs); axis('tight');
title('After Lowpass filter');
subplot(513); specgram(outH, 128, fs); axis('tight');
title('After Highpass filter');
subplot(514); specgram(outP1, 128, fs); axis('tight');
title('After Bandpass filter I');
subplot(515); specgram(outP2, 128, fs); axis('tight');
title('After Bandpass filter II');
audiowrite('music_Lowpass_filter.wav', outL, fs);
audiowrite('music_Highpass_filter.wav', outH, fs);
audiowrite('music_Bandpass_filterI.wav', outP1, fs);
audiowrite('music_Bandpass_filterII.wav', outP2, fs);

% set equalizer parameters
gL = input('Gain for Lowpass filter=? ');
gH = input('Gain for Highpass filter=? ');
gP1 = input('Gain for Bandpass filter I=? ');
gP2 = input('Gain for Bandpass filter II=? ');

out = (gL*outL + gH*outH + gP1*outP1 + gP2*outP2)/(gL + gH + gP1 + gP2);
audiowrite('music_FIRs_equalizer.wav', out, fs);
figure;
subplot(211);specgram(y, 128, fs);axis('tight');
subplot(212);specgram(out, 128, fs);axis('tight');
title('After equalizer');
shg
