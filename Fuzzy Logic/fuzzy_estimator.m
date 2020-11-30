function fuzzy_estimator()
    fis = getFISCodeGenerationData('fuzzy_fg_center_estimator.fis');

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
    outVid = VideoWriter(strcat(motherPath, strcat("output\", strcat(fileName, "_fe.mp4"))), 'MPEG-4');
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
    pivot = [70 170];

    count = 0;
    tic
    while hasFrame(video) % count < 300
        count = count + 1;
        frame = readFrame(video);
        luminance = mean(frame, 3);

        three_bin = [0.0 0.0 0.0];

        % Calculate difference matrix
        luminance = abs(luminance - single(bg_model));
        % Find initial centers
        u = [luminance(1, 1) luminance(1, 1)];

        for x = 1:1:video.Width
            for y = 1:1:video.Height
                if luminance(y, x) < pivot(1)
                    three_bin(1) = three_bin(1) + 1;
                elseif luminance(y, x) < pivot(2)
                    three_bin(2) = three_bin(2) + 1;
                else
                    three_bin(3) = three_bin(3) + 1;
                end

            end
        end

        u(1) = 2.5;
        rate = three_bin(2) / three_bin(3);
        if rate > 10
            u(2) = 88.575145631098050;
        else
            u(2) = evalfis(fis, rate);
        end

        for x = 1:1:video.Width
            for y = 1:1:video.Height
                d1 = abs(luminance(y, x) - u(1));
                d2 = abs(luminance(y, x) - u(2));

                luminance(y, x) = d2 < d1;

            end
        end

        writeVideo(outVid, uint8(luminance) * 255);
        fprintf("\n#%d    BG: %f, FG: %f\n", count, u(1), u(2));
    end

    fprintf("Average FPS: %f\n", count / toc);
    close(outVid);
    % Modelling:  7.306712
    % Average FPS: 11.304704
end