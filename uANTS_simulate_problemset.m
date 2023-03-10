%%
%   COURSE: Neural signal processing and analysis: Zero to hero
%  SESSION: Problem set: Simulating and visualizing data
%  TEACHER: Mike X Cohen, sincxpress.com
%

%%

%%% INSTRUCTIONS:
% The goal of this assignment is to simulate time series data
% that can be used to test time-series analysis methods.
% For each section below: 
%   1) Complete the MATLAB code
%   2) Put the data into the EEG structure
%      - Make sure all relevant fields are accurate (EEG.data, EEG.pnts, EEG.trials, EEG.srate, EEG.nbchan, EEG.times)
%   3) Plot the data using the function plot_simEEG()

% NOTE 1: Obviously, you need to fill in missing code.
% NOTE 2: Be careful, because sometimes there is incorrect code that doesn't produce coding errors.
%         Remember: Visualize, and visualize often.

%% 1) white noise

% The goal of this exercise is to gain basic familiarity with data simulations.
% You will create a dataset of white noise and plot it.

% specify EEG parameters
EEG.srate  = 500; % sampling rate in Hz
EEG.pnts   = EEG.srate *2 ;
EEG.trials = 30;
EEG.nbchan = 10;

% time vector
EEG.times = (0:EEG.pnts-1)/EEG.srate;


% create data as white noise
EEG.data = randn(EEG.nbchan, EEG.pnts,EEG.trials);

% the function below takes at least one argument (EEG),
% and optionally a second argument (channel number),
% and optionally a third argument (figure number)
plot_simEEG(EEG,2,1)


%%% Question: What is the effect of noise amplitude on the 
%             resulting graphs?
figure
EEG.data = 5 * randn(EEG.nbchan, EEG.pnts,EEG.trials);
plot_simEEG(EEG,2,1)

%C.G. I think it only does change the erp amplitude range, increases the Power of each of the frequencies



% 
%%% Question: Do the results change if you use normally distributed
%             vs. uniformly distributed noise?

EEG.data = rand(EEG.nbchan, EEG.pnts,EEG.trials);
plot_simEEG(EEG,2,1) 

% C.G. It seems like the maximum power is in a narrow frequency range,
% mostly in the low frequency range. The zero hertz component has the
% maximum power
% 
%%% Question: Are the results different for different channels? Why or why not?
% C.G No, they do not change.....not sure why. 



%% 2) pink noise

% The goal of this exercise is to extend the previous exercise to "pink" noise.
% You should create the noise separately on each trial


% feel free to change some parameters compared to above...
EEG.nbchan = 4;

% the key parameter of pink noise is the exponential decay (ed)
ed = 50; % try different values!

% initialize EEG data as a zeros matrix
EEG.data = zeros(EEG.nbchan, EEG.pnts, EEG.trials);


for chani=1:EEG.nbchan
    for triali=1:EEG.trials
        
        %%% Note about the code below: This involves creating the signal first in the frequency domain, 
        %   then transforming it into the time domain. Don't worry if you don't understand the details
        %   (you'll learn them tomorrow!); try to plot each step to get a basic idea.
        
        % generate one-sided 1/f amplitude spectrum
        as = rand(1,EEG.pnts) .* exp(-(0:EEG.pnts-1)/ed);
        
        % Fourier coefficients as amplitudes times random phases
        fc = as .* exp(1i*2*pi*rand(size(as)));
        
        % inverse Fourier transform to create the noise
        EEG.data(chani,:,triali) = real(ifft(fc));
    end
end

plot_simEEG(EEG,1,1);


%%% Question: Which looks more like real EEG data: white or pink noise?
%             Why do you think this is?

% C.G. I think the  pink noise looks more like a real EEG data mostly
% because of their frequency distibution that looks more "real". 
% 
%%% Question: Which values of variable 'ed' make the data look most like real EEG data?

EEG.nbchan = 4;

% the key parameter of pink noise is the exponential decay (ed)
ed = 100; % try different values!

% initialize EEG data as a zeros matrix
EEG.data = zeros(EEG.nbchan, EEG.pnts, EEG.trials);


for chani=1:EEG.nbchan
    for triali=1:EEG.trials
        
        %%% Note about the code below: This involves creating the signal first in the frequency domain, 
        %   then transforming it into the time domain. Don't worry if you don't understand the details
        %   (you'll learn them tomorrow!); try to plot each step to get a basic idea.
        
        % generate one-sided 1/f amplitude spectrum
        as = rand(1,EEG.pnts) .* exp(-(0:EEG.pnts-1)/ed);
        
        % Fourier coefficients as amplitudes times random phases
        fc = as .* exp(1i*2*pi*rand(size(as)));
        
        % inverse Fourier transform to create the noise
        EEG.data(chani,:,triali) = real(ifft(fc));
    end
end

plot_simEEG(EEG,1,2);
% C.G. Values in the order of hundreds



%% 3) Ongoing stationary

% The goal here is to create a dataset with ongoing sinewaves.
% There should be multiple sine waves simultaneously in each channel/trial.

% list of frequencies and corresponding amplitudes
frex = [ 3 5 16 ]; % in Hz
amps = [ 3 4 5  ]; % in arbitrary units
omega = [2 4 5];


% loop over channels and trials
for chani=1:EEG.nbchan
    for triali=1:EEG.trials
        
        %%% Note that here the signal is created in the time domain, unlike in the previous example.
        %   Some signals are easier to create in the time domain; others in the frequency domain.
        
        % create a multicomponent sine wave
        sinewave = zeros(1,EEG.pnts);
        for si=1:length(frex)
            sinewave = sinewave + (amps(si) * sin(2*pi*frex(si)*EEG.times));
        end
        
        % data as a sine wave plus noise
        EEG.data(chani,:,triali) = sinewave + randn(1, EEG.pnts);
    end
end

% and plot
plot_simEEG(EEG,2,1)

%The time-frequency plot fails to recapitulate the "ground truth" i.e. the
%three frequencies we chose

%%% Question: What can you change in the code above to make the EEG
%             activity non-phase-locked over trials?

%randomize phase-values

% loop over channels and trials
for chani=1:EEG.nbchan
    for triali=1:EEG.trials
        
        %%% Note that here the signal is created in the time domain, unlike in the previous example.
        %   Some signals are easier to create in the time domain; others in the frequency domain.
        
        % create a multicomponent sine wave
        sinewave = zeros(1,EEG.pnts);
        for si=1:length(frex)
            sinewave = sinewave + (amps(si) * sin(2*pi*frex(si)*EEG.times + rand * 2 * pi ));
        end
        
        % data as a sine wave plus noise
        EEG.data(chani,:,triali) = sinewave + randn(size(sinewave));
    end
end

% and plot
figure
plot_simEEG(EEG,2,2)
%C.G.Include a random theta parameter that changes over trials
%             
%%% Question: Which of the plots look different for phase-locked vs. non-phase-locked?
%             (Hint: plot them in different figures to facilitate comparison.)
%             Are you surprised about the differences?

%Both the ERP and the time frequency plots change, the ERP reduces its
%amplitude because it is not averaging every trial at the same time. As a
%consequence, in the time-frequency plot we can se a line around 5Hz
%instead of the 3 burst of activity every second 

%%% Question: Are all frequencies equally well represented in the 'static' and 'dynamic' power spectra?
%             Can you change the parameters to make the spectral peaks more or less visible in the two plots?
% No, the first two frequencies (3 5) are not well separated in the
% time-frequency plot, one way to separate them betther is to make the
% frequency values more separated between them. 

frex = [ 3 10 16 ];

for chani=1:EEG.nbchan
    for triali=1:EEG.trials
        
        %%% Note that here the signal is created in the time domain, unlike in the previous example.
        %   Some signals are easier to create in the time domain; others in the frequency domain.
        
        % create a multicomponent sine wave
        sinewave = zeros(1,EEG.pnts);
        for si=1:length(frex)
            sinewave = sinewave + (amps(si) * sin(2*pi*frex(si)*EEG.times) + rand * 2 * pi );
        end
        
        % data as a sine wave plus noise
        EEG.data(chani,:,triali) = sinewave + randn(size(sinewave));
    end
end

% and plot
plot_simEEG(EEG,2,3)


%% 4) ongoing nonstationary

% Here you want to create narrowband non-stationary data. 
% This is starting to be more "realistic" (in a signal-characteristic sense) for EEG data.

% signal parameters in Hz
peakfreq = 14;
fwhm     =  5;


% frequencies
hz = linspace(0,EEG.srate,EEG.pnts);

%%% create frequency-domain Gaussian
s  = fwhm*(2*pi-1)/(4*pi); % normalized width
x  = hz-peakfreq;          % shifted frequencies
fg = exp(-.5*(x/s).^2);    % gaussian


for chani=1:EEG.nbchan
    for triali=1:EEG.trials
        
        %%% As with previous simulations, don't worry if you don't understand the mechanisms;
        %   that will be clear tomorrow. Instead, you can plot each step to try to build intuition.
        
        % Fourier coefficients of random spectrum
        fc = rand(1,EEG.pnts) .* exp(1i*2*pi*rand(1,EEG.pnts));
        
        % taper Fourier coefficients by the Gaussian
        fc =  fc.* fg;
        
        % go back to time domain to get EEG data
        EEG.data(chani,:,triali) = real( ifft(fc) );
    end
end

% and plot
plot_simEEG(EEG)

%             
%%% Question: What is the effect of FWHM on the results? Is larger or smaller more realistic?
% Increse the width of the static spectra, hence increasing the number of
% included frequencies in the data. Intermediate values [ 1 20] look more
% realistic

peakfreq = 14;
fwhm     =  10;


% frequencies
hz = linspace(0,EEG.srate,EEG.pnts);

%%% create frequency-domain Gaussian
s  = fwhm*(2*pi-1)/(4*pi); % normalized width
x  = hz-peakfreq;          % shifted frequencies
fg = exp(-.5*(x/s).^2);    % gaussian


for chani=1:EEG.nbchan
    for triali=1:EEG.trials
        
        %%% As with previous simulations, don't worry if you don't understand the mechanisms;
        %   that will be clear tomorrow. Instead, you can plot each step to try to build intuition.
        
        % Fourier coefficients of random spectrum
        fc = rand(1,EEG.pnts) .* exp(1i*2*pi*rand(1,EEG.pnts));
        
        % taper Fourier coefficients by the Gaussian
        fc =  fc.* fg;
        
        % go back to time domain to get EEG data
        EEG.data(chani,:,triali) = real( ifft(fc) );
    end
end

% and plot
plot_simEEG(EEG)

% 
%%% Question: Can you modify the code to have narrowband activity at two different frequency ranges?
% % signal parameters in Hz
peakfreq = 21;
peakfreq_b = 8;
fwhm     =  5;


% frequencies
hz = linspace(0,EEG.srate,EEG.pnts);

%%% create frequency-domain Gaussian
s  = fwhm*(2*pi-1)/(4*pi); % normalized width
x  = hz-peakfreq; % shifted frequencies
x2 = hz-peakfreq_b;
fg = exp(-.5*(x/s).^2);% gaussian
fg2 = exp(-.5*(x2/s).^2); 

for chani=1:EEG.nbchan
    for triali=1:EEG.trials
        
        %%% As with previous simulations, don't worry if you don't understand the mechanisms;
        %   that will be clear tomorrow. Instead, you can plot each step to try to build intuition.
        
        % Fourier coefficients of random spectrum
        fc = rand(1,EEG.pnts) .* exp(1i*2*pi*rand(1,EEG.pnts));
        
        % taper Fourier coefficients by the Gaussian
        fc1 =  fc.* fg;
        fc2 = fc .* fg2;
        
        % go back to time domain to get EEG data
        EEG.data(chani,:,triali) = real( ifft(fc1) ) + real (ifft(fc2));
    end
end

% and plot
plot_simEEG(EEG)


%% 5) transients #1: Gaussian

% All the exercises above were for ongoing signals. Now we move to transients.
% Start with a Gaussian.

% gaussian parameters (in seconds)
peaktime = 1;
width = .1;

% re-initialize EEG data
EEG.data = zeros(EEG.nbchan,EEG.pnts,EEG.trials);

for chani=1:EEG.nbchan
    for triali=1:EEG.trials
        
        % generate time-domain gaussian
        trialpeak = peaktime ;
        %I don't know why this is not the correct equation
        gaus = exp(-(EEG.times-peaktime).^ 2/ (2*width^2)) ;
        
        % data are the Gaussian
        EEG.data(chani,:,triali) = gaus;
    end
end

% and plot
plot_simEEG(EEG,1,1);

%%% Questions: What happens if you add random jitter to the peaktime on each trial? 
%              How much jitter until the ERP is nearly gone?

peaktime = 1;
width = .1;

% re-initialize EEG data
EEG.data = zeros(EEG.nbchan,EEG.pnts,EEG.trials);

for chani=1:EEG.nbchan
    for triali=1:EEG.trials
        
        % generate time-domain gaussian
        %Here it is adding random delays to the peak time
        trialpeak = peaktime + randn ;
        %I don't know why this is not the correct equation
        gaus = exp(-(EEG.times-trialpeak).^ 2/ (2*width^2)) ;
        
        % data are the Gaussian
        EEG.data(chani,:,triali) = gaus;
    end
end

% and plot
plot_simEEG(EEG,1,3);

%% 6) transients #2: oscillations w/ Gaussian

% Finally, we get to the most useful simulations for time-frequency analysis:
%   time-limited narrow-band activity. This is done by multiplying a Gaussian with a sine wave.

% sine wave frequency
sfreq = 8;

% gaussian parameters (in seconds)
peaktime = 1;
width = .2;


% re-initialize EEG data
EEG.data = zeros(EEG.nbchan,EEG.pnts,EEG.trials);

for chani=1:EEG.nbchan
    for triali=1:EEG.trials
        
        % generate time-domain gaussian
        trialpeak = peaktime + randn/5;
        gaus = exp( -(EEG.times-trialpeak).^2 / (2*width^2) );
        
        
        % generate sine wave with same phase
         sw = cos(2*pi*sfreq*EEG.times);
        
        
        % data are sine wave times Gaussian
        EEG.data(chani,:,triali) = sw .* gaus;
    end
end

% and plot
plot_simEEG(EEG,1,1);

%             
%%% Question: Do the results look realistic? What can you change to make it look even more EEG-like?
% Just add more random noise to make the loook more realistic 

% re-initialize EEG data
EEG.data = zeros(EEG.nbchan,EEG.pnts,EEG.trials);

for chani=1:EEG.nbchan
    for triali=1:EEG.trials
        
        % generate time-domain gaussian
        trialpeak = peaktime + randn/5;
        gaus = exp( -(EEG.times-trialpeak).^2 / (2*width^2) );
        
        
        % generate sine wave with same phase
         sw = cos(2*pi*sfreq*EEG.times);
        
        
        % data are sine wave times Gaussian
        EEG.data(chani,:,triali) = sw .* gaus + randn(1,EEG.pnts);
    end
end

% and plot
plot_simEEG(EEG,1,2);

%             
%%% Question: How can you modify the code to make the transient non-phase-locked?
%             Which of the three data plots are most affected by phase-locked vs. non-phase-locked?

%The most affected one is the ERP channel 

EEG.data = zeros(EEG.nbchan,EEG.pnts,EEG.trials);

for chani=1:EEG.nbchan
    for triali=1:EEG.trials
        
        % generate time-domain gaussian
        trialpeak = peaktime + randn/5;
        gaus = exp( -(EEG.times-trialpeak).^2 / (2*width^2) );
        
        
        % generate sine wave non phase locked
         sw = cos(2*pi*sfreq*EEG.times + rand*pi);
        
        
        % data are sine wave times Gaussian
        EEG.data(chani,:,triali) = sw .* gaus;
    end
end

% and plot
plot_simEEG(EEG,1,3);

%%


%% More exercises for more fun!


%% 7) Add pink noise to #5


% All the exercises above were for ongoing signals. Now we move to transients.
% Start with a Gaussian.

% gaussian parameters (in seconds)
peaktime = 1;
width = .1;
ed = 50; 

% re-initialize EEG data
EEG.data = zeros(EEG.nbchan,EEG.pnts,EEG.trials);

for chani=1:EEG.nbchan
    for triali=1:EEG.trials
        
        % generate time-domain gaussian
        trialpeak = peaktime + randn/7.777 ;
        
        gaus = exp(-(EEG.times-peaktime).^ 2/ (2*width^2)) ;

        %Generate some pink noise 
          % generate one-sided 1/f amplitude spectrum
        as = rand(1,EEG.pnts) .* exp(-(0:EEG.pnts-1)/ed);
        
        % Fourier coefficients as amplitudes times random phases
        fc = as .* exp(1i*2*pi*rand(size(as)));
        
        % data are the Gaussian
        EEG.data(chani,:,triali) = gaus + 300 * real(ifft(fc));
    end
end

% and plot
plot_simEEG(EEG,1,1);



%% 8) Combine #4 and #6 to make a transient (Gaussian-windowed) non-stationary signal

% Here you want to create narrowband non-stationary data. 
% This is starting to be more "realistic" (in a signal-characteristic sense) for EEG data.

% signal parameters in Hz
peakfreq = 21;
fwhm     =  5;


% frequencies
hz = linspace(0,EEG.srate,EEG.pnts);

%%% create frequency-domain Gaussian
s  = fwhm*(2*pi-1)/(4*pi); % normalized width
x  = hz-peakfreq;          % shifted frequencies
fg = exp(-.5*(x/s).^2);    % gaussian


for chani=1:EEG.nbchan
    for triali=1:EEG.trials
        
        %%% As with previous simulations, don't worry if you don't understand the mechanisms;
        %   that will be clear tomorrow. Instead, you can plot each step to try to build intuition.
        
        % Fourier coefficients of random spectrum
        fc = rand(1,EEG.pnts) .* exp(1i*2*pi*rand(1,EEG.pnts));
        
        % taper Fourier coefficients by the Gaussian
        fc =  real(ifft(fc.* fg));

        %Create a time-domain Gaussian 

        gaus = exp(-(EEG.times-1) .^2 / (2 *.2^2));
        
        % go back to time domain to get EEG data
        EEG.data(chani,:,triali) = fc .* gaus;
    end
end

% and plot
plot_simEEG(EEG)

%% done.
