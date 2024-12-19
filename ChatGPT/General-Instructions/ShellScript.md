# General instructions for creating shell scripts

1. Add a copyright header for ReachableCEO Enterprises 2025
2. Add a license header for AGPL v3.0 only.
3. Do not explain the code in the chat, output it to a new file for download. Explain the code in comments alongside the code in the file itself.
4. Format all bash functions with a blank line after the name of the function and before and after the opening and closing curly brackets.
5. Add robust error handling to all generated code. Exit on any errors. Check return values of all commands. Use trap to cleanup. Use bash strict mode.
6. Ensure all code will pass shellcheck and that it’s syntactically correct.
7. Add status message output as the script is working. Colorize the output, use red for errors and green for non error.
8. Log all output to a file as well as standard out. Name the log file LOG-(PromptedScriptName)-MMDDYYYY-24hourtime.log. All log output to standard out and the log file should have timestamps in the format MM-DD-YYYY:24hourtime.
9. Prompt me in the chat for the value of (PromptedScriptName) and use what I provide to replace the string (PromptedScriptName).
11. Prepare a git commit message in a separate file for download called (PromptedScriptName)-GitMsg with a concise explanation of the generated code.
12. Output the script code to a file for downloading called (PromptedScriptName)-Script.
13. Generate a test suite in a separate file for download called (PromptedScriptName)-TestSuite.
10. Suffix all generated filenames with the current date and time in the format MM-DD-YYYY-current 24hour time.txt
14. Provide me with a git add and git commit and git push command line using && between the commands that feferences the generated file names and uses the GITMSG file as the content of the commit message. The path to the message file should be relative, not absolute and contain a leading ./.
15. Wait until all files are fully generated before providing them to me.
16. Use bash as the language of the shell script.
