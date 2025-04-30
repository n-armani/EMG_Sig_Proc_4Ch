#-----------------------------------------------------------------------#
# File name        : EMG_Sig_Proc_4Ch
# Project          :
# Developer        : Nathan Armani
#-----------------------------------------------------------------------#
# Purpose          : Preprocess and analyze EMG signals from four channels 
#                   using R
#-----------------------------------------------------------------------#
# Created by       : Nathan Armani
# Created date     : Apr. 03, 2025
#-----------------------------------------------------------------------#
# Revised by       :
# Revised date     :
# Revision details : Added support for four EMG channels
# Notes:
#-----------------------------------------------------------------------#
# Load required libraries
library(signal)
library(seewave)

# Turn off warnings and set options
options(warn = -1,
        scipen = 999,
        error = traceback)

cat("\014")
rm(list = ls())

# Load EMG data
EMG_Data <- read.csv("C:/Users/natha/Desktop/EMG/Data/Jack D 225 w Belt.csv",
                     skip = 3)  # Skip first 3 rows, start from row 4,
#Remember, it would be different in different machines
# Always check the raw data first
Channel1 <- EMG_Data$Ultium.EMG.EMG.1.uV
Channel2 <- EMG_Data$Ultium.EMG.EMG.2.uV
Channel3 <- EMG_Data$Ultium.EMG.EMG.3.uV
Channel4 <- EMG_Data$Ultium.EMG.EMG.4.uV

# Define Sampling Frequency
Fs <- 1000 # Hz
Time <- seq(0, length(Channel1) - 1) / Fs # Assuming all electrodes have the same length

# High-pass filter (20 Hz) to remove movement artifacts
hpFilt <- butter(4,
                 20 / (Fs / 2),
                 type = "high")

EMG_hp1 <- filtfilt(hpFilt,
                    Channel1)

EMG_hp2 <- filtfilt(hpFilt,
                    Channel2)

EMG_hp3 <- filtfilt(hpFilt,
                    Channel3)

EMG_hp4 <- filtfilt(hpFilt,
                    Channel4)

# Low-pass filter (500 Hz) to remove high-frequency noise
lpFilt <- butter(4,
                 500 / (Fs / 2),
                 type = "low")

EMG_filtered1 <- filtfilt(lpFilt,
                          EMG_hp1)

EMG_filtered2 <- filtfilt(lpFilt,
                          EMG_hp2)

EMG_filtered3 <- filtfilt(lpFilt,
                          EMG_hp3)

EMG_filtered4 <- filtfilt(lpFilt,
                          EMG_hp4)

# Notch filter (50 Hz) to remove powerline interference
notchFilt <- butter(2,
                    c(49, 51) / (Fs / 2),
                    type = "stop")

EMG_notch1 <- filtfilt(notchFilt,
                       EMG_filtered1)

EMG_notch2 <- filtfilt(notchFilt,
                       EMG_filtered2)

EMG_notch3 <- filtfilt(notchFilt,
                       EMG_filtered3)

EMG_notch4 <- filtfilt(notchFilt,
                       EMG_filtered4)

# Rectification
EMG_rectified1 <- abs(EMG_notch1)
EMG_rectified2 <- abs(EMG_notch2)
EMG_rectified3 <- abs(EMG_notch3)
EMG_rectified4 <- abs(EMG_notch4)

# Smoothing using RMS
window_size <- 200 # Define window size

EMG_rms1 <- sqrt(stats::filter(EMG_rectified1^2,
                               rep(1/window_size,
                                   window_size),
                               sides = 2,
                               method = "convolution"))

EMG_rms2 <- sqrt(stats::filter(EMG_rectified2^2,
                               rep(1/window_size,
                                   window_size),
                               sides = 2,
                               method = "convolution"))

EMG_rms3 <- sqrt(stats::filter(EMG_rectified3^2,
                               rep(1/window_size,
                                   window_size),
                               sides = 2,
                               method = "convolution"))

EMG_rms4 <- sqrt(stats::filter(EMG_rectified4^2,
                               rep(1/window_size,
                                   window_size),
                               sides = 2,
                               method = "convolution"))

# Feature Extraction
# Mean Absolute Value (MAV)
MAV1 <- mean(EMG_rectified1)  
MAV2 <- mean(EMG_rectified2)
MAV3 <- mean(EMG_rectified3)
MAV4 <- mean(EMG_rectified4)

# Root Mean Square (RMS)
RMS1 <- sqrt(mean(EMG_rectified1^2))  
RMS2 <- sqrt(mean(EMG_rectified2^2))
RMS3 <- sqrt(mean(EMG_rectified3^2))
RMS4 <- sqrt(mean(EMG_rectified4^2))

# Zero-Crossings (ZC)
ZC1 <- sum(diff(sign(EMG_notch1)) != 0)  
ZC2 <- sum(diff(sign(EMG_notch2)) != 0)
ZC3 <- sum(diff(sign(EMG_notch3)) != 0)
ZC4 <- sum(diff(sign(EMG_notch4)) != 0)

# Waveform Length (WL)
WL1 <- sum(abs(diff(EMG_notch1)))  
WL2 <- sum(abs(diff(EMG_notch2)))
WL3 <- sum(abs(diff(EMG_notch3)))
WL4 <- sum(abs(diff(EMG_notch4)))

# Power Spectrum Density (PSD)
psd_result1 <- spectrum(EMG_notch1, plot = FALSE)
psd_result2 <- spectrum(EMG_notch2, plot = FALSE)
psd_result3 <- spectrum(EMG_notch3, plot = FALSE)
psd_result4 <- spectrum(EMG_notch4, plot = FALSE)

# Normalization using Maximum Voluntary Contraction (MVC)
MVC1 <- max(EMG_rectified1)
MVC2 <- max(EMG_rectified2)
MVC3 <- max(EMG_rectified3)
MVC4 <- max(EMG_rectified4)
EMG_normalized1 <- EMG_rectified1 / MVC1
EMG_normalized2 <- EMG_rectified2 / MVC2
EMG_normalized3 <- EMG_rectified3 / MVC3
EMG_normalized4 <- EMG_rectified4 / MVC4

# Create a data frame to display extracted features
feature_table <- data.frame(
  Feature = c("Mean Absolute Value (MAV)",
              "Root Mean Square (RMS)",
              "Zero Crossings (ZC)",
              "Waveform Length (WL)"),
  EMG1 = c(MAV1,
           RMS1,
           ZC1,
           WL1),
  EMG2 = c(MAV2,
           RMS2,
           ZC2,
           WL2),
  EMG3 = c(MAV3,
           RMS3,
           ZC3,
           WL3),
  EMG4 = c(MAV4,
           RMS4,
           ZC4,
           WL4))

# --- Plotting for Electrode 1 ---
layout(matrix(1:4, 
              nrow = 2, 
              byrow = TRUE))

plot(Time,
     Channel1,
     type = "l",
     main = "Raw EMG Channel 1",
     xlab = "Time (s)",
     ylab = "Amplitude")

plot(Time,
     EMG_notch1,
     type = "l",
     main = "Filtered EMG Channel 1",
     xlab = "Time (s)",
     ylab = "Amplitude")

plot(Time,
     EMG_rectified1,
     type = "l",
     main = "Rectified EMG Channel 1",
     xlab = "Time (s)",
     ylab = "Amplitude")

plot(Time,
     EMG_rms1,
     type = "l",
     main = "Smoothed (RMS) EMG Channel 1",
     xlab = "Time (s)",
     ylab = "Amplitude")

# --- Plotting for Electrode 2 ---
layout(matrix(1:4, 
              nrow = 2, 
              byrow = TRUE))

plot(Time,
     Channel2,
     type = "l",
     main = "Raw EMG Channel 2",
     xlab = "Time (s)",
     ylab = "Amplitude")

plot(Time,
     EMG_notch2,
     type = "l",
     main = "Filtered EMG Channel 2",
     xlab = "Time (s)",
     ylab = "Amplitude")

plot(Time,
     EMG_rectified2,
     type = "l",
     main = "Rectified EMG Channel 2",
     xlab = "Time (s)",
     ylab = "Amplitude")

plot(Time,
     EMG_rms2,
     type = "l",
     main = "Smoothed (RMS) EMG Channel 2",
     xlab = "Time (s)",
     ylab = "Amplitude")

# --- Plotting for Electrode 3 ---
layout(matrix(1:4, 
              nrow = 2, 
              byrow = TRUE))

plot(Time,
     Channel3,
     type = "l",
     main = "Raw EMG Channel 3",
     xlab = "Time (s)",
     ylab = "Amplitude")

plot(Time,
     EMG_notch3,
     type = "l",
     main = "Filtered EMG Channel 3",
     xlab = "Time (s)",
     ylab = "Amplitude")

plot(Time,
     EMG_rectified3,
     type = "l",
     main = "Rectified EMG Channel 3",
     xlab = "Time (s)",
     ylab = "Amplitude")

plot(Time,
     EMG_rms3,
     type = "l",
     main = "Smoothed (RMS) EMG Channel 3",
     xlab = "Time (s)",
     ylab = "Amplitude")

# --- Plotting for Electrode 4 ---
layout(matrix(1:4, 
              nrow = 2, 
              byrow = TRUE))

plot(Time,
     Channel4,
     type = "l",
     main = "Raw EMG Channel 4",
     xlab = "Time (s)",
     ylab = "Amplitude")

plot(Time,
     EMG_notch4,
     type = "l",
     main = "Filtered EMG Channel 4",
     xlab = "Time (s)",
     ylab = "Amplitude")

plot(Time,
     EMG_rectified4,
     type = "l",
     main = "Rectified EMG Channel 4",
     xlab = "Time (s)",
     ylab = "Amplitude")

plot(Time,
     EMG_rms4,
     type = "l",
     main = "Smoothed (RMS) EMG Channel 4",
     xlab = "Time (s)",
     ylab = "Amplitude")

# Plot Power Spectrum Density
par(mfrow = c(2, 2))
plot(psd_result1$freq, 10 * log10(psd_result1$spec),
     type = "l",
     main = "PSD Channel 1",
     xlab = "Frequency (Hz)",
     ylab = "Power (dB/Hz)")

plot(psd_result2$freq, 10 * log10(psd_result2$spec),
     type = "l",
     main = "PSD Channel 2",
     xlab = "Frequency (Hz)",
     ylab = "Power (dB/Hz)")

plot(psd_result3$freq, 10 * log10(psd_result3$spec),
     type = "l",
     main = "PSD Channel 3",
     xlab = "Frequency (Hz)",
     ylab = "Power (dB/Hz)")

plot(psd_result4$freq, 10 * log10(psd_result4$spec),
     type = "l",
     main = "PSD Channel 4",
     xlab = "Frequency (Hz)",
     ylab = "Power (dB/Hz)")
cat("\014")

# Print the table
# Mean Absolute Value (MAV)
# MAV is the average of the absolute values of the EMG signal.
# It represents the overall signal activity and muscle contraction intensity.

# Root Mean Square (RMS)
# RMS is a measure of the power of the signal, similar to standard deviation.
# It helps capture the signal’s amplitude while accounting for variations over time.

# Zero Crossings (ZC)
# ZC counts the number of times the EMG signal crosses the zero baseline.
# It gives an indication of muscle activation patterns and frequency content.

# Waveform Length (WL)
# WL is the sum of absolute differences between consecutive EMG signal values.
# It reflects the complexity and variations in the signal,
# useful for assessing muscle fatigue.

print(feature_table,
      row.names = FALSE)

