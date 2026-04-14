% Load the video
video = VideoReader('/Users/khadija/Downloads/input.mp4');

% Retrieve the number of frames and frame rate
numFrames = video.NumFrames;
frameRate = video.FrameRate;

% Create video writers to store output videos
AveragingOutput = VideoWriter('AveragingOutputVideo.mp4', 'MPEG-4');
GradientOutput = VideoWriter('GradientOutputVideo.mp4', 'MPEG-4');
LaplacianOutput = VideoWriter('LaplacianOutputVideo.mp4', 'MPEG-4');
NoisyOutput = VideoWriter('NoisyVideo.mp4', 'MPEG-4');
MedianOutput = VideoWriter('MedianFilterVideo.mp4', 'MPEG-4');

open(AveragingOutput);
open(GradientOutput);
open(LaplacianOutput);
open(NoisyOutput);
open(MedianOutput);

% Process each frame
for i = 1:numFrames
    frame = read(video, i);
    grayFrame = double(rgb2gray(frame));
    [row, col] = size(grayFrame);
    
    % Apply 5x5 averaging filter
    avgFrame = zeros(size(grayFrame));
    for x = 3:row-2
        for y = 3:col-2
            subimg = grayFrame(x-2:x+2, y-2:y+2);
            avgFrame(x, y) = round(sum(subimg(:)) / 25);
        end
    end
    writeVideo(AveragingOutput, uint8(avgFrame));
    
    % Apply Sobel filter
    sobelX = [-1 0 1; -2 0 2; -1 0 1];
    sobelY = [-1 -2 -1; 0 0 0; 1 2 1];
    sobelFrame = zeros(size(grayFrame));
    for x = 2:row-1
        for y = 2:col-1
            neighborhood = grayFrame(x-1:x+1, y-1:y+1);
            gradX = sum(sum(neighborhood .* sobelX));
            gradY = sum(sum(neighborhood .* sobelY));
            gradMag = sqrt(gradX^2 + gradY^2);
            sobelFrame(x, y) = gradMag;
        end
    end
    writeVideo(GradientOutput, uint8(sobelFrame));
    
    % Apply Laplacian filter
    laplacianFilter = [-1 -1 -1; -1 8 -1; -1 -1 -1];
    laplacianFrame = zeros(size(grayFrame));
    for x = 2:row-1
        for y = 2:col-1
            neighborhood = grayFrame(x-1:x+1, y-1:y+1);
            laplacianValue = sum(sum(neighborhood .* laplacianFilter));
            laplacianFrame(x, y) = laplacianValue;
        end
    end
    writeVideo(LaplacianOutput, uint8(laplacianFrame));

    % Observation
    % Sobel filter emphasizes stronger edges 
    % while laplacian filter produces thinner edges compared to Sobel.
    
    % Add salt-and-pepper noise to frames between 2 and 4 seconds
    currentTime = (i-1) / frameRate; % Current time in seconds
    if currentTime >= 2 && currentTime < 4
        noisyFrame = imnoise(uint8(grayFrame), 'salt & pepper', 0.4);
        writeVideo(NoisyOutput, noisyFrame);
    else
        noisyFrame = uint8(grayFrame);
        writeVideo(NoisyOutput, noisyFrame);
    end

    % Apply 7x7 median filter
    paddedFrame = padarray(noisyFrame, [3 3], 'replicate');
    medianFrame = zeros(size(noisyFrame));
    for x = 4:row+3
        for y = 4:col+3
            window = paddedFrame(x-3:x+3, y-3:y+3);
            medianFrame(x-3, y-3) = median(window(:));
        end
    end
    writeVideo(MedianOutput, uint8(medianFrame));

    % Larger filter size successfully removes all the noise but results in
    % loss of details. If a smaller filter like 3x3 or 5x5 is used,
    % it retains detail but the noise is not effectively removed.
end

% Close the writers
close(AveragingOutput);
close(GradientOutput);
close(LaplacianOutput);
close(NoisyOutput);
close(MedianOutput);
