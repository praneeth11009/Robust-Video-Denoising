clear; clc;
disp('Loading Data')
tic;
mov = yuv4mpeg2mov('../input/akiyo_qcif.y4m');

%% Pre-processing
res = size(mov(1).cdata); % resolution of each frame
K = 50; % Number of frames
frames = zeros(res(1),res(2),res(3),K);
for i = 1:50 
    frames(:,:,:,i) = mov(i).cdata;
end
%figure;
%imshow(uint8(reshape(frames(:,:,:,1),res)));

%% Noise Addition
disp('Create noisy frames')
% Params
sigma_gauss = 20;
k_poisson = 5;
s_impulse = 0.3;
thres_impulse = 100*(1-(1-s_impulse)^(1/3));

% Generate Noisy frames
noise_g = sigma_gauss*randn(size(frames));
noise_p = poissrnd(k_poisson*frames);
noise_p = noise_p - k_poisson*frames;
frames_noisy = frames + noise_g + noise_p;
%frames_noisy = frames + noise_p;

impulse_pos = randi(100,res(1),res(2),res(3),K);
noise_pos = impulse_pos <= thres_impulse;
correct_pos = impulse_pos > thres_impulse;
impulses = randi([0,1],res(1),res(2),res(3),K)*255.0;
frames_noisy = frames_noisy.*correct_pos + noise_pos.*impulses;

toc;
figure;
imshow(uint8(reshape(frames_noisy(:,:,:,1),res)));
