# If you want to activate unit tests, uncomment the following set the
# UNITTEST_PROGRAM to the correct command
#test: selftest

# Or, of course, you could write whatever recipe you want for test

# Program *inside* the container that can be run to perform container
# self tests.  It should put a junit style XML test result in
# /test-results
UNITTEST_PROGRAM=/root/selftest
