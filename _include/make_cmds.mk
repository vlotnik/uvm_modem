## +-----------------------------------------------------------------------------------------------------------------------------+
## | base commands                                                                                                               |
## +-----------------------------------------------------------------------------------------------------------------------------+
    help:
	@sed -ne '/@sed/!s/## //p' $(MAKEFILE_LIST)

    clean: ##                       remove base generated data
	rm -rf transcript *.wlf def_lib modelsim.ini wlft* *.vstf _libs _result

    mkdir_result: ##                create folder for results
	mkdir _result

    build_done: ##                  create build_done.RESULT
	touch _result/build_done.RESULT

    rm_transcript: ##               delete transcript
	rm transcript