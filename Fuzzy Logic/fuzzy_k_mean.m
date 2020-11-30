[fileName, pathName] = uigetfile({'*.mp4;*.avi', 'Videos';
                              '*.*', 'All Files (*.*)'},...
                              'Select a Video');
% Truncate to find mother folder's path
br = 0;
for br = length(pathName) - 1:-1:1
    if (pathName(br) == '\')
        break;
    end
end
motherPath = pathName(1:br);
fullPath = strcat(pathName, fileName);
video = VideoReader(fullPath);
outVid = VideoWriter(strcat(motherPath, strcat("output\", strcat(fileName, "_fkm.mp4"))), 'MPEG-4');
outVid.Quality = 90;
outVid.FrameRate = video.FrameRate;
open(outVid);

% Number of frames for modeling
num_of_training_frames = 40;
count = 0;
% % Allocate memory
historgram = zeros(video.Height, video.Width, 256, 'uint32');
bg_model = zeros(video.Height, video.Width, 'uint8');
period = 7;
% Build histogram of each pixel
tic
while hasFrame(video) && count < num_of_training_frames
    frame = readFrame(video);
    period = bitand(period + 1, 247, 'uint8');
    if period > 0
        continue;
    end
    intensity = mean(frame, 3) + 1;
    for x = 1:1:video.Width
        for y = 1:1:video.Height
            bright = uint8(intensity(y, x));
            historgram(y, x, bright) = historgram(y, x, bright) + 1;
        end
    end
    count = count + 1;
end

% Find the frequent value
for x = 1:1:video.Width
    for y = 1:1:video.Height
        reg_frequency = zeros(1, 4, 'uint32');
        for v = 1:1:64
            reg_frequency(1) = reg_frequency(1) + historgram(y, x, v);
        end
        for v = 65:1:128
            reg_frequency(2) = reg_frequency(2) + historgram(y, x, v);
        end
        for v = 129:1:192
            reg_frequency(3) = reg_frequency(3) + historgram(y, x, v);
        end
        for v = 193:1:256
            reg_frequency(4) = reg_frequency(4) + historgram(y, x, v);
        end

        max = 1;
        for i = [2 3 4]
            if reg_frequency(i) > reg_frequency(max)
                max = i;
            end
        end

        count = 0;
        reg_frequency(max) = reg_frequency(max) / 2;
        for i = 64 * (max - 1) + 1 : 1 : 64 * max
            count = count + historgram(y, x, i);
            if count > reg_frequency(max)
                break;
            end
        end
        bg_model(y, x) = i;        
    end
end
toc

u = zeros(1, 2, 'single');  % center array for k-mean
u_new = zeros(1, 2, 'single');
total_iter = 0;
b = 1.25;   % overlapping factor
threshold = 10;

membership = zeros(video.Height, video.Width, 2, 'single');
temp_p = 0;

tic
count = 0;
while hasFrame(video) % count < 300
    count = count + 1;
    frame = readFrame(video);
    luminance = mean(frame, 3);

    % Calculate difference matrix
    luminance = abs(luminance - single(bg_model));
    % Find initial centers
    u = [luminance(1, 1) luminance(1, 1)];
    for x = 1:1:video.Width
        for y = 1:1:video.Height
            % Find min
            if luminance(y, x) < u(1)
                u(1) = luminance(y, x);
            end
            % Find max
            if luminance(y, x) > u(2)
                u(2) = luminance(y, x);
            end
        end
    end
    iter = 0;
    while true
        iter = iter + 1;
        % Evaluate membership
        for x = 1:1:video.Width
            for y = 1:1:video.Height
                d1 = abs(luminance(y, x) - u(1));
                d2 = abs(luminance(y, x) - u(2));

                if d2 == 0
                    membership(y, x, 1) = 0;
                else
                    membership(y, x, 1) = 1 / (1 + (d1 / d2) ^ (2 / (b - 1)));
                end
                if d1 == 0
                    membership(y, x, 2) = 0;
                else
                    membership(y, x, 2) = 1 / (1 + (d2 / d1) ^ (2 / (b - 1)));
                end

            end
        end

        % Update means
        temp_p = membership(:, :, 1) .^ b;
        denom = sum(sum(temp_p));
        temp_p = temp_p .* luminance;
        numer = sum(sum(temp_p));
        u_new(1) = numer / denom;

        temp_p = membership(:, :, 2) .^ b;
        denom = sum(sum(temp_p));
        temp_p = temp_p .* luminance;
        numer = sum(sum(temp_p));
        u_new(2) = numer / denom;

        % Stop condition
        differ = u_new - u;
        if norm(differ, inf) < threshold
            u = u_new;
            break;
        else
            u = u_new;
        end
    end
    temp_p = membership(:, :, 2) - membership(:, :, 1);
    writeVideo(outVid, uint8(temp_p > 0) * 255);
    fprintf("\n#%d Iter: %d,    BG: %f, FG: %f\n", count, iter, u(1), u(2));
 	total_iter = total_iter + iter;
end

fprintf("Average FPS: %f\t\tAverage iteration: %f\n", count / toc, total_iter / count);
close(outVid);
% Average FPS: 0.756913     Average iteration: 3.199122
% Average FPS: 0.625543     Average iteration: 3.994008
% Modeling: 8.309746 seconds