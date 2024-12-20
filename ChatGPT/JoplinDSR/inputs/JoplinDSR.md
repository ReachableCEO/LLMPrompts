# Specific instructions for this shell script

Write a bash shell script using shell functions that:

Includes a function called get_joplin_apikey that contains the following code

```
bw logout
bw config server https://pwvault.turnsys.com
echo "Sourcing clientid/apikey data..."
source D:/tsys/secrets/bitwarden/data/apikey-bitwarden-reachableceo
bw login --apikey $BW_CLIENTID $BW_CLIENTSECRET
export BW_SESSION="$(bw unlock --passwordenv TSYS_BW_PASSWORD_REACHABLECEO --raw)"
export JOPLIN_TOKEN="$(bw get password APIKEY-Joplin-Streaming)"
```

Reads the following environment variables from an external file and ensure the values are not null

JOPLIN_HOST
JOPLIN_PORT
JOPLIN_SOURCE_NOTE_TITLE
JOPLIN_TARGET_NOTEBOOK

The external file needs to be a variable in the shell script and must not be null. The value of the variable should be set to ../DSRVariables.env. Place the variable and the variable checking code at the top of the script.

Ensure the value of JOPLIN_TOKEN is not null.
Use the Joplin API and Find the ID of the JOPLIN_SOURCE_NOTE_TITLE . Make sure to handle the pagination of the API output.
Make a clone of the body of the note to a new note in JOPLIN_TARGET_NOTEBOOK called DSR-MM-DD-YYYY
