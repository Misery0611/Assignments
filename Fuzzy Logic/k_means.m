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
outVid = VideoWriter(strcat(motherPath, strcat("output\", strcat(fileName, "_km.mp4"))), 'MPEG-4');
outVid.Quality = 90;
outVid.FrameRate = video.FrameRate;
open(outVid);

% Number of frames for modeling
num_of_training_frames = 40;
count = 0;
% Allocate memory
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

count = 0;
tic
while hasFrame(video) % count < 300
    count = count + 1;
    frame = readFrame(video);
    luminance = mean(frame, 3);

    % Calculate difference matrix
    luminance = abs(luminance - single(bg_model));
    data = luminance(:);

    [idx,C] = kmeans(data, 2, 'Distance', 'cityblock', 'MaxIter', 20);

    idx = uint8(idx);

    if abs(C(1) - C(2)) < 10
        idx = bitand(idx, 0, 'uint8');
    elseif C(1) > C(2)
        idx = bitxor(idx, 3, 'uint8');
    end

    data = reshape(idx, [video.Height, video.Width]);
    data = (uint8(data) - 1) * 255;

    % Write to video
    writeVideo(outVid, data);
    fprintf("#%d Centers: %f %f\n", count, C(1), C(2));
end

fprintf("FPS: %f\n", toc / count);
close(outVid);

% Modeling: 8.569583 seconds
% FPS: 0.365557
% FPS: 0.562822