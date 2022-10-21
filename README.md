# expressives_praat

©Pere Garau Borràs (2022). Universitat de les Illes Balears

According to the aim of the research (detecting acoustic correlates for expressives), there are three relevant values to be obtained from the corpus: pitch values, intensity values and speech rate values. Manual work in obtention of these values would represent an enormous effort and, maybe, a less precise data. The corpus implements two tools to collecting data: a Praat script, to collect all data referred to acoustic parameters; and a Python script to treat all the data, obtain speech rate values and mark the presence of potential expressives. 
	Last version of Lennes (2016) has been used as a base to build a Praat script to fulfil the purpose. Lennes’ original script is designed to collect maximum pitch data by going “through all the TextGrid files and the Sound files in a given folder, find sound-grid pairs that have the same name, open each pair, run through the TextGrid, collect data from labeled intervals and append the information to a simple tabulated text file (which you can later open in a statistical or spreadsheet program)” (Lennes, 2016). The resulting Praat script used here (henceforth, PS) allows the user to get, for each labelled segment, the values of maximum pitch, minimum pitch, pitch difference (i.e., maximum– minimum), maximum intensity, minimum intensity, intensity difference and segment duration. 
	The script loops between the files, which must had been saved in the same folder and by pairs of ‘wav’ audio files and TextGrids named the same. Every file pair is loaded to Praat. From the audio file a Pitch object  and an Intensity object  are created. For Pitch object creation time step value is 0.1 s (as the value set when bounding the segments), minimum pitch is set at 75 Hz, and maximum at 300 Hz, after having examined the pitch range of the audios. For Intensity object operation values are set to 75 Hz for minimum pitch, 0.1 s for time step and no mean value has been calculated. Once these two objects are created, a loop into the segments. If the segment is labelled with a pause marker (‘xxx’) is skipped. Only segments not marked with pause mark are contemplated for analysis. 
	For each segment, starting and ending time points and duration values are saved. Also, the script gets maximum and minimum pitch of the segment and calculates, by subtraction, pitch difference. The same procedure is used for intensity values. Moreover, the Script saves the file name, segment number and text label. File name is saved in order to locate the segment within the corpus. Segment number is stored to always maintain access to the segment reference and position. Text label is kept to postprocessing with Python script.
Finally, obtained values are saved separated by semicolons in a ‘csv’ file, allowing posterior work with any statistical or data manager software. Temporary files are deleted. The result from the use of the PS is a single csv file containing all values from pitch and intensity (maximum, minimum and difference), duration, file name, segment number and segment transcription. 

To cite: Garau, P. (2022). expressives_praat.praat, Praat script. Github.com. https://github.com/garaupere/expressives_praat
