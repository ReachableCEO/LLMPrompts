Write a bash script using functions that 

1. Reads the following environment variables from a file and ensures the values are not null 

JOPLIN_HOST
JOPLIN_PORT
JOPLIN_TOKEN
JOPLIN_SOURCE_NOTE_TITLE 
JOPLIN_TARGET_NOTEBOOK

2. Use the Joplin API and Find the ID of the JOPLIN_SOURCE_NOTE_TITLE . Make sure to handle the pagination of the API output. 
3. Make a clone of the body of the note to a new note in JOPLIN_TARGET_NOTEBOOK called DSR-MM-DD-YYYY