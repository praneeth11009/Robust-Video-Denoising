function out = PSNR(orig,curr)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
diff = orig-curr;
diff = diff.^2;
res = size(diff);
mse = sum(diff(:))/(res(1)*res(2)*res(3));
maxi = max(orig(:));
out = 10*log10(maxi*maxi/mse);
end

