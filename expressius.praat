# This script goes through sound and TextGrid files in a directory,
# opens each pair of Sound and TextGrid, calculates the pitch maximum
# of each labeled interval, and saves results to a text file.
# To make some other or additional analyses, you can modify the script
# yourself... it should be reasonably well commented! ;)
#
# This script is distributed under the GNU General Public License.
# 4.7.2003 Mietta Lennes

# This script has been modified by Pere Garau Borràs (2022)

form Obtain data from corpus (Garau, 2022)
	comment Script for obtaining pitch, intensity and duration values from corpus.
	comment 
	text sound_directory ..\scripts 2022\audiosrondalles\
	sentence Sound_file_extension .wav
	comment Full path of the resulting text file:
	text resultfile ..\scripts 2022\results.csv
	comment Which tier do you want to analyze?
	sentence Tier sentence
	comment Pitch analysis parameters
	positive Time_step 0.01
	positive Minimum_pitch_(Hz) 75
	positive Maximum_pitch_(Hz) 300
endform

textGrid_directory$ = "..\scripts 2022\audiosrondalles\"
TextGrid_file_extension$ = ".TextGrid"

# Here, you make a listing of all the sound files in a directory.
# The example gets file names ending with ".wav" from D:\tmp\

Create Strings as file list... list 'sound_directory$'*'sound_file_extension$'
numberOfFiles = Get number of strings

# Check if the result file exists:
if fileReadable (resultfile$)
	pause The result file 'resultfile$' already exists! Do you want to overwrite it?
	filedelete 'resultfile$'
endif

# Write a row with column titles to the result file:
# (remember to edit this if you add or change the analyses!)

titleline$ = "Filename;Segment number;Text;Text net;Maximum pitch (Hz);Minimum pitch (Hz);Pitch difference (Hz);Maximum Intensity (dB);Minimum Intensity (dB);Intensity difference (dB);Segment duration (s);Words;Speech rate (w/s);Expressives'newline$'"
fileappend "'resultfile$'" 'titleline$'

# Go through all the sound files, one by one:

for ifile to numberOfFiles
	filename$ = Get string... ifile
	# A sound file is opened from the listing:
	Read from file... 'sound_directory$''filename$'
	# Starting from here, you can add everything that should be 
	# repeated for every sound file that was opened:
	soundname$ = selected$ ("Sound", 1)
	To Pitch... time_step minimum_pitch maximum_pitch
	select Sound 'soundname$'
		To Intensity: 100, 0, "no"
	# Open a TextGrid by the same name:
	gridfile$ = "'textGrid_directory$''soundname$''textGrid_file_extension$'"
	if fileReadable (gridfile$)
		Read from file... 'gridfile$'
		# Find the tier number that has the label given in the form:
		call GetTier 'tier$' tier
		numberOfIntervals = Get number of intervals... tier
		# Pass through all intervals in the selected tier:
		i = 1
		for interval to numberOfIntervals
			label$ = Get label of interval... tier interval
			if label$ <> "xxx"
				# if the interval has an unempty label, get its start and end:
				label$ = replace_regex$(label$, ";", ",", 0)
				start = Get starting point... tier interval
				end = Get end point... tier interval
				dur = end - start
				dur$ = string$(dur)
				dur$ = replace_regex$ (dur$, "\.", ",", 0)

				# get the Pitch maximum at that interval
				select Pitch 'soundname$'
				pitchmax = Get maximum... start end Hertz Parabolic
				# get the Pitch minimum at that interval
				select Pitch 'soundname$'
				pitchmin = Get minimum... start end Hertz Parabolic
				#get Pitch difference
				pitchdiff = pitchmax - pitchmin
				#printline 'pitchmax'    'pitchmin'	'pitchdiff'
				#get the Intensity maximum at that interval
				select Intensity 'soundname$'
				intensmax = Get maximum: start, end, "parabolic"
				#get the Intensity minimum at that interval
				intensmin = Get minimum: start, end, "parabolic"
				#printline 'intensmax'	'intensmin'
				#get Intensity difference
				intensdiff = intensmax - intensmin
				#Get interval number
				intnumb = interval

				pitchmax$ = string$(pitchmax)
				pitchmax$ = replace_regex$ (pitchmax$, "\.", ",", 0)
				pitchmin$ = string$(pitchmin)
				pitchmin$ = replace_regex$ (pitchmin$, "\.", ",", 0)
				pitchdiff$ = string$(pitchdiff)
				pitchdiff$ = replace_regex$ (pitchdiff$, "\.", ",", 0)
				intensmax$ = string$(intensmax)
				intensmax$ = replace_regex$ (intensmax$, "\.", ",", 0)
				intensmin$ = string$(intensmin)
				intensmin$ = replace_regex$ (intensmin$, "\.", ",", 0)
				intensdiff$ = string$(intensdiff)
				intensdiff$ = replace_regex$ (intensdiff$, "\.", ",", 0)

				# Save result to text file:
				resultline$ = "'soundname$';'intnumb';'label$';'pitchmax$';'pitchmin$';'pitchdiff$';'intensmax$';'intensmin$';'intensdiff$';'dur$''newline$'"				
				i = i+1
				fileappend "'resultfile$'" 'resultline$'

				select TextGrid 'soundname$'
			endif
		endfor
		# Remove the TextGrid object from the object list
		select TextGrid 'soundname$'
		Remove
	endif
	# Remove the temporary objects from the object list
	select Sound 'soundname$'
	plus Pitch 'soundname$'
	plus Intensity 'soundname$'
	Remove
	select Strings list
	# and go on with the next sound file!
endfor

Remove


#-------------
# This procedure finds the number of a tier that has a given label.

procedure GetTier name$ variable$
        numberOfTiers = Get number of tiers
        itier = 1
        repeat
                tier$ = Get tier name... itier
                itier = itier + 1
        until tier$ = name$ or itier > numberOfTiers
        if tier$ <> name$
                'variable$' = 0
        else
                'variable$' = itier - 1
        endif

	if 'variable$' = 0
		exit The tier called 'name$' is missing from the file 'soundname$'!
	endif

endproc