%% Denoising with median filter
tic;
disp('Adaptive Median Filter')
frames_median = frames_noisy;
pos_unchanged = ones(res(1),res(2),res(3),K);
for i = 1:K 
    [frames_median(:,:,1,i), pos_unchanged(:,:,1,i)] = myMedianFilt(reshape(frames_noisy(:,:,1,i),[res(1),res(2)]));
    [frames_median(:,:,2,i), pos_unchanged(:,:,2,i)] = myMedianFilt(reshape(frames_noisy(:,:,2,i),[res(1),res(2)]));
    [frames_median(:,:,3,i), pos_unchanged(:,:,3,i)] = myMedianFilt(reshape(frames_noisy(:,:,3,i),[res(1),res(2)]));
end
toc;
figure;
imshow(uint8(reshape(frames_median(:,:,:,1),res)));


