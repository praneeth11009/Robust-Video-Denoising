function [out,pos] = myMedianFilt(inp)
% Adaptive Median filter RAMF (Ranked-order based Adaptive Median Filter)
    res = size(inp);
    out = inp;
    pos = ones(res(1),res(2));
    for i = 1:res(1)
        for j = 1:res(2)
            if ~(inp(i,j) == 0 || inp(i,j) == 255)
                continue;
            end
            for w = 1:5
                i_lo = max(1,i-w);
                i_hi = min(res(1),i+w);
                j_lo = max(1,j-w);
                j_hi = min(res(2),j+w);
                window = inp(i_lo:i_hi,j_lo:j_hi);
                xmed = median(window(:));
                xmin = min(window(:));
                xmax = max(window(:));
                % Level 1
                T_lo = xmed - xmin;
                T_hi = xmed - xmax;
                if ~(T_lo > 0 && T_hi < 0) 
                    continue;
                end
                % Level 2
                U_lo = inp(i,j) - xmin;
                U_hi = inp(i,j) - xmax;
                if ~(U_lo > 0 && U_hi < 0)
                    out(i,j) = xmed;
                    pos(i,j) = 0;
                end
                break;
            end
        end
    end
end

