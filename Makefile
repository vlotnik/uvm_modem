## +-----------------------------------------------------------------------------------------------------------------------------+
## | makefile                                                                                                                    |
## +-----------------------------------------------------------------------------------------------------------------------------+

include _include/make_cmds.mk

    clean_all: ##                   make clean
	python3.7 scripts/check_results.py clean
    all: ##                         make all
	python3.7 scripts/check_results.py all console
    all_to_file: ##                 make all, write data to file
	python3.7 scripts/check_results.py all file
    build: ##                       make build
	python3.7 scripts/check_results.py build console
    build_to_file: ##               make build, write data to file
	python3.7 scripts/check_results.py build file
    run_tests: ##                   make run_tests
	python3.7 scripts/check_results.py run_tests console
    run_tests_to_file: ##           make run_tests, write data to file
	python3.7 scripts/check_results.py run_tests file