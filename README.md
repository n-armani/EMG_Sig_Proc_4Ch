EMG_Sig_Proc_4Ch
Developer: Nathan Armani
Created: April 3, 2025
Language: R
Purpose: Preprocessing and analysis of 4-channel EMG signals for feature extraction and visualization.

**Overview**
EMG_Sig_Proc_4Ch is an R-based script that performs preprocessing and analysis on electromyographic (EMG) signals recorded from four channels. The script includes signal filtering, rectification, smoothing (via RMS), and common feature extraction techniques such as MAV, RMS, Zero-Crossings, Waveform Length, and Power Spectral Density (PSD). It also provides a set of visualizations to examine signal behavior across all processing stages.

**Features**
**Support for 4 EMG channels**
**Filtering:**
  * High-pass (20 Hz) to remove movement artifacts
  * Low-pass (500 Hz) to remove high-frequency noise
  * Notch (50 Hz) to eliminate powerline interference
**Signal Processing:**
  * Full-wave rectification
  * RMS smoothing
**Feature Extraction:**
  * Mean Absolute Value (MAV)
  * Root Mean Square (RMS)
  * Zero Crossings (ZC)
  * Waveform Length (WL)
  * Power Spectrum Density (PSD)

**Normalization:** Using Maximum Voluntary Contraction (MVC)

**Visualization:** Multi-panel plots for each channel across raw, filtered, rectified, and RMS-processed signals, as well as PSD plots.

**Requirements**
Install the required R packages before running the script:
install.packages("signal")
install.packages("seewave")

**Usage**
1. Clone the repository:

bash
git clone https://github.com/your-username/EMG_Sig_Proc_4Ch.git

2. Edit the data path:

Modify the read.csv() path in the script to match your local EMG .csv file:
EMG_Data <- read.csv("path/to/your/EMG_data.csv", skip = 3)

3. Run the script in RStudio or R Console.

**Output**
A feature table including MAV, RMS, ZC, and WL for each channel
* Plots showing:
* Raw EMG signal
* Filtered EMG signal
* Rectified signal
* RMS-smoothed signal
* Power Spectrum Density

**Example Feature Table**

Feature	                  EMG1	EMG2	EMG3	EMG4
Mean Absolute Value (MAV)	...	  ...	  ...	  ...
Root Mean Square (RMS)	  ...	  ...	  ...	  ...
Zero Crossings (ZC)	      ...	  ...	  ...	  ...
Waveform Length (WL)      ...	  ...	  ...	  ...

Notes
* Filtering is performed using Butterworth filters via the signal package.
* EMG signal characteristics may vary based on placement, subject, and task. Always inspect raw signals prior to preprocessing.
* Adjust Fs, window_size, and filter parameters based on your acquisition setup and target analysis goals.

License
This project is licensed under the MIT License.
