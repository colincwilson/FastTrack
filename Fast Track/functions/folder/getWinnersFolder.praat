include folder/getWinnersFolder1.praat

procedure getWinnersFolder
  .winners = Read Table from comma-separated file: folder$ + "/winners.csv"
  .file_info = Read Table from comma-separated file: folder$ +"/file_information.csv"
  .nfiles = Get number of rows
  .basename$ = Get value: 1, "file"

  createDirectory: folder$ + "/images_winners"
  createDirectory: folder$ + "/formants_winners"
  
  ##############################################################################
  ## get information about previous analysis using the first info file
  .info = Read Strings from raw text file: folder$ + "/infos/" + .basename$-".wav" + "_info.txt"
  .tmp$ = Get string: 3
  number_of_steps = number (.tmp$)

  .tmp$ = Get string: 5
  stringToVector_output# = zero#(number_of_steps)
   @stringToVector: .tmp$
  .cutoffs# = stringToVector_output#

  .tmp$ = Get string: 7
  number_of_coefficients_for_formant_prediction = number (.tmp$)

  .tmp$ = Get string: 9
  number_of_formants = number (.tmp$)

  .tmp$ = Get string: 13
  @stringToVector: .tmp$
  .totalerror# = stringToVector_output#
  removeObject: .info
  ##############################################################################
	
  ## these will collect the winning coefficients to write to the info file
  winf1coeffs# = zero# (number_of_coefficients_for_formant_prediction+1)
  winf2coeffs# = zero# (number_of_coefficients_for_formant_prediction+1)
  winf3coeffs# = zero# (number_of_coefficients_for_formant_prediction+1)
  winf4coeffs# = zero# (number_of_coefficients_for_formant_prediction+1)
		
  ## counters involved in prediction of process duration
  daySecond = 0
  @daySecond
  .startSecond = daySecond

  ## if formant bounds have been specified, these are read in, in addition to information about alternate
	## available analyses
	bounds_specified = 0
	if fileReadable ("../dat/formantbounds.csv")
		.formant_bounds = Read Table from comma-separated file: "../dat/formantbounds.csv"	
		.all_errors = Read Table from comma-separated file: folder$ +"/infos_aggregated/all_errors.csv"
		.all_f1s = Read Table from comma-separated file: folder$ +"/infos_aggregated/all_f1s.csv"
		.all_f2s = Read Table from comma-separated file: folder$ +"/infos_aggregated/all_f2s.csv"
		.all_f3s = Read Table from comma-separated file: folder$ +"/infos_aggregated/all_f3s.csv"
		bounds_specified = 1		
	endif

	#############################################################################################################
	#############################################################################################################
	### MAIN LOOP

  for .counter from 1 to .nfiles  
    nocheck @getWinnersFolder1
	endfor

	## END MAIN LOOP
  #############################################################################################################
	#############################################################################################################

  ## write out updated winners file and remove created Praat objects
  selectObject: .winners
	Save as comma-separated file: folder$ + "/winners.csv"
	removeObject: .winners, .file_info
	nocheck removeObject: .all_f1s, .all_f2s, .all_f3s, .all_errors
endproc


