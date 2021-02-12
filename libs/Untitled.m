clc; clear; close all;

[spikeMat, tVec] = poissonSpikeGen(30, 10, 1);
figure; raster_plot1(spikeMat, tVec);