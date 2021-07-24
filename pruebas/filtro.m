close all
load chirp


%soundsc(y,Fs)

t = (0:length(y)-1)/Fs;

bhi = fir1(20,[0.2 0.5],'bandpass');
figure
freqz(bhi,1)



outlo = filter(bhi,1,y);

soundsc(outlo,Fs)

figure
subplot(2,1,1)
plot(t,y)
title('Original Signal')
ys = ylim;

subplot(2,1,2)
plot(t,outlo)
title('Lowpass Filtered Signal')
xlabel('Time (s)')
ylim(ys)