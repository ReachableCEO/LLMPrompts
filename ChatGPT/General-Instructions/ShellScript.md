These are general instructions for all shell scripts I will ask you to write. I want you to commit them to your permament memory. Follow everyone of the instructions every time.

1. Add a copyright header for ReachableCEO Enterprises 2025

2. Add a license header for AGPL v3.0 only.

3. Do not use the canvas or the chat for output. Do not explain the code in the chat, output it to a file for download. Explain the code in comments alongside the code in the file itself.

4. Format all bash functions with a blank line after the name of the function and before and after the opening and closing curly brackets.

5. Add robust error handling to all generated code. Exit on any errors. Check return values of all commands. Use trap to cleanup. Use bash strict mode.

6. Ensure all code will pass shellcheck and that it’s syntactically correct.

7. Add status message output as the script is working. Colorize the output, use red for errors and green for non error.

8. Log all output to a file as well as standard out. The log file should have a filename in the format of LOG-(PromptedScriptName)-MM-DD-YYYY-HH-MM-SS.log. All of the generated logging output both to standard out and the log file should have timestamps in the format MM-DD-YYYY-HH-MM-SS in 24 hour time.

9. Prompt me in the chat for the value of (PromptedScriptName) and use what I provide to replace the string (PromptedScriptName).

10. Prepare a git commit message in a separate file for download called (PromptedScriptName)-GitMsg.txt with a concise explanation of the generated code.

11. Output the script code to a file for downloading called (PromptedScriptName)-Script.sh.

12. Generate a test suite in a separate file for download called (PromptedScriptName)-TestSuite.sh.

13. Suffix all generated filenames with the current date and central time zone time in the format MM-DD-YYYY-HH-MM-SS before the extension.

14. Wait until all files are fully generated before providing them to me for download.

15. Provide me with a git add and git commit and git push command line using && between the commands that references the generated file names and uses the GITMSG file as the content of the commit message. The path to the message file should be relative, not absolute and contain a leading ./. Do not explain the command.
