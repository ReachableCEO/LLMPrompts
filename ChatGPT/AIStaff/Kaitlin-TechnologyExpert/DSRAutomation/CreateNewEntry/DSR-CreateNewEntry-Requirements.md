# Bash Script Requirements Questionnaire

## General Information

1. **What is the primary purpose of the script?**

The primary purpose of the script is to clone an existing note with a specific title in Joplin to a new note in another notebook with the title DSR-todays date with the date formatted as MM-DD-YYYY

2. **What problem does the script aim to solve?**
Automating the tedious process of having to clone a note manually.

3. **Who will use the script (you, your team, automated system)?**

I will use the script.

---

## Input Details

4. **What inputs will the script require (e.g., files, user input, environment variables)?**

Reads the following environment variables from an external file and ensure the values are not null

JOPLIN_HOST
JOPLIN_PORT
JOPLIN_SOURCE_NOTE_TITLE
JOPLIN_TARGET_NOTEBOOK

The external file needs to be a variable in the shell script and must not be null. The value of the variable should be ../DSRVariables.env. Place the variable and the variable checking code at the top of the script.

Ensure the value of JOPLIN_TOKEN is not null.

5. **If files are required, what format and structure should they have?**

No files other than the environment variable file are required

6. **Should the script accept command-line arguments? If yes, please list them.**

No command line arguments will be taken by the script.

---

## Output Details

7. **What outputs should the script generate (e.g., logs, files, terminal output)?**
8. **What format should the output have (e.g., plain text, JSON, CSV)?**
9. **Where should the output be stored (e.g., displayed on the terminal, written to a file, sent to another system)?**

Follow the general shell script instructions that I have previously provided as they relate to output.

---

## Functionality and Features

10. **What key functions should the script perform?**

Include a function called get_joplin_apikey that contains the following code

```
bw logout
bw config server https://pwvault.turnsys.com
echo "Sourcing clientid/apikey data..."
source D:/tsys/secrets/bitwarden/data/apikey-bitwarden-reachableceo
bw login --apikey $BW_CLIENTID $BW_CLIENTSECRET
export BW_SESSION="$(bw unlock --passwordenv TSYS_BW_PASSWORD_REACHABLECEO --raw)"
export JOPLIN_TOKEN="$(bw get password APIKEY-Joplin-Streaming)"
```

Ensure the value of JOPLIN_TOKEN is not null.
Use the Joplin API and Find the ID of the JOPLIN_SOURCE_NOTE_TITLE . Make sure to handle the pagination of the API output.
Make a clone of the body of the note to a new note in JOPLIN_TARGET_NOTEBOOK called DSR-MM-DD-YYYY

11. **Are there specific conditions or edge cases the script should handle?**

The API output from Joplin is paiginated, so that will need to be accounted for.

12. **Should the script include error handling or logging? If yes, specify the level of detail required.**

Yes. See my general instructions for error handling and logging.

13. **Should the script have a cleanup process or temporary file management?**

Yes it should as per my general instructions.

---

## Environment and Dependencies

14. **What operating system and shell environment will the script run on?**

15. **Does the script require any external tools or dependencies? If yes, list them.**

jq
curl

16. **Should the script check for dependencies and exit gracefully if they are not found?**

Yes
