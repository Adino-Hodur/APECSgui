% Proprietary Algorithm and Software
% Version 1, Revised 01/05/2008
% Author:	Roman Rosipal, Ph. D.; rrosipal@pacdel.com
% (c) Pacific Development and Technology, LLC, 2007, 2008 www.pacdel.com

function [pxx, f_lines]= pwrSpecPwelch(data,param)

S=size(data); 

taper =[]; %%% already done

for t=1:S(2)
    [pxx(:,t), f_lines]= pwelch(data(:,t), taper, param.psdWinOverlap_pwelch, param.nFFT, param.sampleFreq);
end


