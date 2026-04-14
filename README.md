# Video Filtering and Edge Detection in MATLAB

## Overview
This project demonstrates fundamental image processing techniques by applying spatial filtering and edge detection on each frame of a video.

The goal was to understand how different filters behave dynamically over time rather than on static images.

---

## Why I Built This
I built this project to strengthen my understanding of:
- Manual convolution
- Edge detection techniques
- Noise simulation and removal in videos

It also helped me visualize how filtering impacts real-time data.

---

## Features
- Frame-by-frame video processing
- Grayscale conversion
- Implementations of:
  - 5×5 Averaging Filter (manual)
  - Sobel Edge Detection
  - Laplacian Filter
- Salt & Pepper Noise injection (2–4 sec interval)
- 7×7 Median Filter for denoising

---

## Outputs
The project generates 5 processed videos:
- Averaging Filter Output
- Sobel Edge Output
- Laplacian Output
- Noisy Video
- Median Filtered Video

---

## How to Run
1. Open MATLAB
2. Place the input video in the project folder
3. Run the main script:
   ```matlab
   main.m
