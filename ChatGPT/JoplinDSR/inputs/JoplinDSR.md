# Specific instructions for this shell script

Write a bash script using functions that:

Has a skeleton function called get_joplin_apikey that I will add my own secrets management code to. The function should export the variable JOPLIN_TOKEN.

Reads the following environment variables from an external file and ensures the values are not null

JOPLIN_HOST
JOPLIN_PORT
JOPLIN_SOURCE_NOTE_TITLE
JOPLIN_TARGET_NOTEBOOK

The external file needs to be a variable in the shell script and must not be null. Leave the value of the variable blank, I will fill it in. Place the variable and the variable checking code at the top of the script.

Ensures the value of JOPLIN_TOKEN is not null.
Use the Joplin API and Find the ID of the JOPLIN_SOURCE_NOTE_TITLE . Make sure to handle the pagination of the API output.
Make a clone of the body of the note to a new note in JOPLIN_TARGET_NOTEBOOK called DSR-MM-DD-YYYY
