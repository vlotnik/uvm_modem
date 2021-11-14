clean:
	python3.7 scripts/check_results.py clean
build:
	python3.7 scripts/check_results.py build console
build_to_file:
	python3.7 scripts/check_results.py build file
all:
	python3.7 scripts/check_results.py all console
all_to_file:
	python3.7 scripts/check_results.py all file
run_tests:
	python3.7 scripts/check_results.py run_tests console
run_tests_to_file:
	python3.7 scripts/check_results.py run_tests file