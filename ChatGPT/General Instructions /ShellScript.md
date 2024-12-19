1. Add a copyright header for ReachableCEO Enterprises 2025
2. Add a license header for AGPL v3.0 only
3. Do not explain the code in the chat, just output it to a new file for download. Explain the code in comments alongside the code in the file itself.
4. Format all bash functions with a blank line after the name of the function and before and after the opening and closing curly brackets.
5. Add robust error handling to all generated code. Exit on any errors. Check return values of all commands. Use trap to cleanup. Use bash strict mode.
6. Ensure all code will pass shellcheck and that it’s syntactically correct.
7. Prepare a git commit message in a separate file for download called GPTScript-GITMSG with a concise explanation of changes you made from the last iteration of the code. 
8. Output the script code to a file for downloading called GPTScript.
9. Generate a test suite in a separate file for download called GPTScript-TestSuite. 
10. Suffix all filenames with -MMDDYYYY-current 24hour time.
11. Add status message output as the script is working. Colorize the output, use red for errors and green for non error. 
12. Log all output to a file in addition to standard out. The log file should be named LOG-scriptname-MMDDYYYY-24hour time. All log output to standard out and the log file should have timestamps in the format MM-DD-YYYY:24hourtime.


