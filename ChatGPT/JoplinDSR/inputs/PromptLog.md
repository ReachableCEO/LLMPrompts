
- [Prompt log](#prompt-log)
  - [Introduction](#introduction)
  - [Prompts](#prompts)
    - [First attempt](#first-attempt)
    - [Second attempt](#second-attempt)
    - [Third attempt](#third-attempt)
    - [Fourth attempt](#fourth-attempt)

# Prompt log

## Introduction

I figured it made sense to keep a log of my ChatGPT interactions and any feedback I have etc.

I am logging :

- date
- time
- git hash
- prompt used
- files used

## Prompts

### First attempt

- [Transcript 1](https://chatgpt.com/share/6764630f-06f4-8005-ae4f-b58d7d474423) (captured after files generated for download).

- Git hash: 9a98e052a159646a2fb5fc8aa581eb4daa890798

- Files used as attachments to the prompt: (from the referenced git hash):

  - JoplinDSR.md
  - ShellScript.md

- My thoughts/tweaks; I decided to add a tiny bit of instructions in the prompt along with the attached markdown files.

- Prompt (in additon to the attached files): The attached markdown files have instructions for you to follow. Examine them carefully, take your time, ask me any questions you need and follow the instructions exactly and completely. Do not leave out any of the steps ok.

- Date/Time: 12-19-2024 / 12:09

- Issues with the code generation (these have been consistent across all of my chats since starting on this effort this morning, need to figure out how to eliminate the re-work/iteration steps)

```
Understood. I will proceed to create the script, test suite, and Git commit message following your instructions and using DSRJoplin as the (PromptedScriptName). The files will be named appropriately and ready for download shortly. Please hold on while I generate everything.

It seems there was an error in processing the script content. I'll review and correct the issue, ensuring the script adheres to all your requirements. Let me fix this and provide the corrected files. ​​

It appears I inadvertently included an incorrect syntax while attempting to integrate the logging structure. Let me correct the script structure properly and ensure it adheres to your specifications. ​​

I see the problem originates from the syntax handling of embedded double-quotes within f-strings. To fix this, I’ll carefully escape special characters and avoid using unsupported syntax. Let me correct this and finalize the files properly. ​​

It seems there was an issue with the variables for file paths. Let me redefine them and ensure the content is saved properly. ​
```

- Issues with my instructions:

  - Didn't create the git command.
  - Didn't format the file names correctly.

Reprimand issued:

- I am not happy. You didn't follow my instructions to output the git commands. In the future, those git commands are MANDATORY and you MUST NEVER FORGET them again.
- I am still not happy. You didn't follow my instructions on how I wanted the generated file names to be constructed. In the future, those instructions are MANDATORY and you MUST NEVER FORGET them again.

Updated transcript:  <https://chatgpt.com/share/6764630f-06f4-8005-ae4f-b58d7d474423>

### Second attempt

- Git hash: 11e558465dda5358fad710b247704f912f72d1d1

- Thoughts/tweaks: none

- Prompt: Follow the instructions in the attached markdown files.

- [Transcript](https://chatgpt.com/share/67646dd2-09ec-8005-9821-22ed9a9e193a)

- Feedback: None. It followed my instructions exactly this time.

### Third attempt

- Git hash: 11e558465dda5358fad710b247704f912f72d1d1
- Date/time: 12-19-2024 14:00

- Prompt:

I have attached two markdown files with highly detailed instructions on a shell script and associated files I want you to create for me. Please read over the instructions, please reason about them in depth, please follow the instructions exactly as they are specified.

### Fourth attempt

It followed my instructions exactly. Now to test out the code.

Used a new git hash: 