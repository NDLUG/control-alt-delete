#!/bin/bash

# solution-josebrodriguez.sh

# Created by: Jose Rodriguez on 10/04/2021

KEY="UNIX"
DECRYPTED1=''
DECRYPTED2=''

read_line(){
  ID=$1
  A=$(read line ; echo $line | sed -nE "s/($ID: )([A-Z+])/\2/p")
  echo "$A"
}


decrypt_text(){
  KEY_CHAR=$1
  ENC_CHAR=$2
  
  ALPHABET="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  LETTER_BEFORE=''

  for i in $(seq 1 ${#ALPHABET}); do
    if [ ${ALPHABET:i-1:1} == $KEY_CHAR ]; then
      LETTER_BEFORE=$LETTER_BEFORE${ALPHABET:i-2:1}
    fi
  done

  echo $ENC_CHAR | tr "[$KEY_CHAR-ZA-$LETTER_BEFORE]" "[A-Z]"
}

decrypt_loop(){
  KEY=$1
  IDLINE=$2
  DEC_STRING=$3
  j=0
  for i in $(seq 1 ${#IDLINE});do
    j=$(($j+1))
    if [[ $j -eq ${#KEY} ]]; then
      j=0
    fi 
    DEC_STRING=$DEC_STRING$(decrypt_text ${KEY:j-1:1} ${IDLINE:i-1:1})
  done
  echo $DEC_STRING
}

USERLINE=$(read_line "Username")
PASSLINE=$(read_line "Password")
DECRYPTED1=$(decrypt_loop $KEY $USERLINE $DECRYPTED1)
DECRYPTED2=$(decrypt_loop $KEY $PASSLINE $DECRYPTED2)

echo "Username: "$DECRYPTED1
echo "Password: "$DECRYPTED2
