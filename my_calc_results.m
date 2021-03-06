function [mse, corr, avg_abs_err] = my_calc_results(labels_target, labels_out)
% my_calc_results calculates results according to the input files.
% input:
%     labels_target: target labels for prediction
%     labels_out: output labels 
% return:
%     mse: mean square error
%     corr: correlation coeffiecient^2
%     avg_abs_arr: = (sum(BPMest(i) - BPMtrue(e)) / N)

    error = 0;
    sump = 0;
    sumt = 0;
    sumpp = 0;
    sumtt = 0;
    sumpt = 0;
    total = 0;
    abserr = 0;
    
    for i = 1:size(labels_target, 1)
        labelt = labels_target(i);
        labelp = labels_out(i);
        
        error = error + (labelp - labelt)^2;
        sump = sump + labelp;
        sumt = sumt + labelt;
        sumpp = sumpp + labelp^2;
        sumtt = sumtt + labelt^2;
        sumpt = sumpt + labelp * labelt;
        total = total + 1;
        abserr = abserr + abs(labelt - labelp);
    end
    
    mse = error / total;
    corr = ((total * sumpt - sump * sumt)^2) / ((total * sumpp - sump^2) * (total * sumtt - sumt^2));
    avg_abs_err = abserr / total;
end