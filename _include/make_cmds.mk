## +-----------------------------------------------------------------------------------------------------------------------------+
## | base commands
## +-----------------------------------------------------------------------------------------------------------------------------+
    help:
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

    clean: ##                           remove base generated data
	rm -rf transcript *.wlf def_lib modelsim.ini wlft* *.vstf _libs *.RESULT _result

    clean_log: ##                       remove log files
	rm -rf *.log

    build_done: ##                      create build_done.RESULT
	touch build_done.RESULT

    rm_transcript: ##                   delete transcript
	rm transcript

    clean_rest:
	rm -rf RESULT DSP/libraries/lib_c_math.h scripts/__pycache__