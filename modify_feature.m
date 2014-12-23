function modify_feature(PPG_weight, look_forward, look_width, normalize_flag)
% Format:
% modify_feature(PPG_weight, look_forward, look_width, normalize_flag)
% 
% This function will modify the existed features.mat
% use the following four var to decide how to modify the feature
% PPG_weight : multiply PPG feature with the number. If PPG_weight = 0, the
% PPG feature will be removed.
% look_forward : If look_foward = n, take window #(t-n)'s acc as window
% #t's feature
% look_width : If look_width = n, take (#(t-n+1) ~ #t)'s acc as window
% #t's feature 
% normalize_flag : 1 for normalize, 0 for not to.

    if exist('g_data_idxes', 'var') == 0
        g_data_idxes = 1:12;
    end

    filename = 'features.mat';
    load(filename);

    big_matrix = zeros(1768, 2+3*look_width, 27);
    count = 0;
    for i = g_data_idxes
        features_i = sprintf('features%d', i);

        eval(sprintf('tmp_matrix = %s;', features_i));
        j = size(tmp_matrix, 1);
        while j > 0
            for k = 1:look_width
                if j-look_forward-k+1 > 0
                    tmp_matrix(j, 3*k : 3*k+2, :) = tmp_matrix(j-look_forward-k+1, 3 : 5, :);
                else
                    tmp_matrix(j, 3*k : 3*k+2, :) = tmp_matrix(1, 3 : 5, :);
                end
            end
            j = j - 1;
        end

        big_matrix(count+1:count+size(tmp_matrix, 1), :, :) = tmp_matrix;
        count = count + size(tmp_matrix, 1);
    end

    for i = 1:size(big_matrix, 2)
        for j = 1:27
            tmp_mean = mean( big_matrix(:, i, j) );
            tmp_std = std( big_matrix(:, i, j) );
            if(normalize_flag)
                big_matrix(:, i, j) = (big_matrix(:, i, j) - tmp_mean ) / tmp_std;
            end
            if(i < 3)
                big_matrix(:, i, j) = big_matrix(:, i, j) * PPG_weight;
            end
        end
    end

    delete(filename);
    save(filename, 'g_data_idxes'); 
    count = 0;
    for i = g_data_idxes
        features_i = sprintf('features%d', i);
        
        if PPG_weight ~= 0
        eval(sprintf('%s = big_matrix(count+1:count+size(%s, 1), :, :);', features_i, features_i));
        else
        eval(sprintf('%s = big_matrix(count+1:count+size(%s, 1), 3 : size(%s, 2), :);', features_i, features_i, features_i));
        end
        
        eval(sprintf('count = count + size(%s, 1);', features_i));
        save(filename, features_i, '-append');
    end
end
    %clearvars tmp_filename i j big_matrix count filename PPG_weight normalize_flag k look_forward look_width tmp_mean tmp_std tmp_matrix features_i