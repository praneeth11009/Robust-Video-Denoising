clc;
%% Iterate over all patches
disp('Begin Denoising')
frames_denoise = zeros(res(1),res(2),res(3),K);
count = zeros(res(1),res(2),res(3),K);
for fr = 1:50
    disp(['Frame ',num2str(fr)])
    tic;
    for i =  1:4:res(1)-7
        disp(['Row Num ',num2str(i)]);
        for j = 1:4:res(2)-7
            for k = 1:3
                % Extract patches
                close_patches = zeros(64,250);
                patch_indices = zeros(2,250);
                pos_select = zeros(64,250); 
                cur_patch = frames_median(i:i+7,j:j+7,k,fr);
                cur_patch = cur_patch(:);
                win_size = 10;
                i_lo = max(1,i-win_size); i_hi = min(res(1),i+win_size);
                j_lo = max(1,j-win_size); j_hi = min(res(2),j+win_size);
                for itr = 1:50
                   all_patches = im2col(frames_median(i_lo:i_hi,j_lo:j_hi,k,itr),[8 8]);
                   all_pos = im2col(pos_unchanged(i_lo:i_hi,j_lo:j_hi,k,itr),[8 8]);
                   diff = abs(all_patches - cur_patch);
                   diff = -sum(diff,1);
                   [vals,indices] = maxk(diff,5);
                   close_patches(:,5*itr-4:5*itr) = all_patches(:,indices);
                   pos_select(:,5*itr-4:5*itr) = all_pos(:,indices);
                   orig_posns = zeros(2,5);
                   win_height = i_hi - i_lo + 1;
                   orig_posns(1,:) = i_lo + mod(indices-1,(win_height-7));
                   orig_posns(2,:) = j_lo + floor((indices-1)/(win_height-7));
                   patch_indices(:,5*itr-4:5*itr) = orig_posns;
                end
                % Now select missing elements 
                mean_patch = mean(close_patches,1);
                std_patch = std(close_patches);
                pos_2sig = abs(close_patches-mean_patch) < 2*std_patch ;
                pos_select = pos_select.*pos_2sig;
                
                % Fixed point iter
                mu = (8+sqrt(250))*sqrt(sum(pos_select(:))/(64*250))*(mean(std_patch));
                Q = fixed_pt_iter(close_patches,pos_select,0.001,1.5,mu,30);
                
                for itr = 1:50 
                    for z = 5*itr-4:5*itr
                        x0 = patch_indices(1,z);
                        y0 = patch_indices(2,z);
                        frames_denoise(x0:x0+7,y0:y0+7,k,itr) = frames_denoise(x0:x0+7,y0:y0+7,k,itr) + reshape(Q(:,z),[8 8]);
                        count(x0:x0+7,y0:y0+7,k,itr) = count(x0:x0+7,y0:y0+7,k,itr) + 1;
                    end
                end
                %break;
            end
            %break;
        end
        %break;
    end
    toc;
end
%frames_denoise(:,:,:,1) = frames_denoise(:,:,:,1)./count(:,:,:,1);
non_zero = frames_denoise(:,:,:,:) > 0;
frames_denoise(non_zero) = frames_denoise(non_zero)./count(non_zero);
%figure;
%imshow(uint8(reshape(frames_denoise(:,:,:,1),res)));