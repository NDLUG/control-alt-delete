#!/bin/bash

# solution-josebrodriguez.sh

# Created by: Jose Rodriguez on 10/04/2021

# Sets Decryption Key, Initializes strings for username and password
KEY="UNIX"
DECRYPTED1=""
DECRYPTED2=""

# Function to read a line in either the form:
#   Username: EXAMPLEUSERNAME
#   Password: EXAMPLEPASSWORD
# and extract the chosen string
read_line(){
  ID=$1
  A=$(read line ; echo $line | sed -nE "s/($ID: )([A-Z+])/\2/p")
  echo "$A"
}

# Function to decrypt the text using Viginere Cipher
# to decrypt a single character at a time
decrypt_text(){
  KEY_CHAR=$1 # Takes the current character in the key
  ENC_CHAR=$2 # Takes the current character in the encrypted text
  
  # Defines English alphabet for the function to use
  ALPHABET="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  LETTER_BEFORE=""

  # Finds the letter before the key character so that it can be used to trace
  # the key onto the alphabet
  for i in $(seq 1 ${#ALPHABET}); do
    if [ ${ALPHABET:i-1:1} == $KEY_CHAR ]; then
      LETTER_BEFORE=$LETTER_BEFORE${ALPHABET:i-2:1}
    fi
  done

  # Instead of beginning the alphabet with 'A', the decrypted text's alphabet begins
  # at the current key value. This trace call will reverse that process.
  echo $ENC_CHAR | tr "[$KEY_CHAR-ZA-$LETTER_BEFORE]" "[A-Z]"
}

# Function loops through each character in the string and runs the decrypt_text function
# to decrypt the current character.
decrypt_loop(){
  # Parameters: Decryption Key, Username or Password, Decrypted String (empty)
  KEY=$1
  IDLINE=$2
  DEC_STRING=$3

  # j keeps track of the number of iterations through key
  j=0
  for i in $(seq 1 ${#IDLINE});do
    j=$(($j+1))

    # Allows the key to wraparound when needed
    if [[ $j -eq ${#KEY} ]]; then
      j=0
    fi 

    DEC_STRING=$DEC_STRING$(decrypt_text ${KEY:j-1:1} ${IDLINE:i-1:1}) # builds decrypted string
  done

  # Return Decrypted String
  echo $DEC_STRING
}

# Reads in username and password
USERLINE=$(read_line "Username")
PASSLINE=$(read_line "Password")

# Decrypt the username and password
DECRYPTED1=$(decrypt_loop $KEY $USERLINE $DECRYPTED1)
DECRYPTED2=$(decrypt_loop $KEY $PASSLINE $DECRYPTED2)

# Print the decrypted username and password
echo "Username: "$DECRYPTED1
echo "Password: "$DECRYPTED2
