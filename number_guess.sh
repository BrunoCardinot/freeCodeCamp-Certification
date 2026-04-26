#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USER

USERNAME=$($PSQL "SELECT username FROM users WHERE username='$USER'")

if [[ -z $USERNAME ]]
then
  INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES ('$USER')")
  echo "Welcome, $USER! It looks like this is your first time here."
else
  ID=$($PSQL "SELECT user_id FROM users WHERE username='$USER'")
  GAMES_PLAYED=$($PSQL "SELECT COUNT(user_id) FROM games WHERE user_id=$ID")
  BEST_GAME=$($PSQL "SELECT MIN(tries_number) FROM games WHERE user_id=$ID")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

NUMBER=$(((RANDOM % 1000)+1))
echo "Guess the secret number between 1 and 1000:"
read GUESS
if [[ ! $GUESS =~ ^[0-9]+$* ]]
then 
  echo "That is not an integer, guess again:"
  read GUESS
fi
count=1
while [[ $NUMBER -ne $GUESS ]] 
do
  if [[ $NUMBER -gt $GUESS ]]
  then 
    echo "It's higher than that, guess again:"
  else
    echo "It's lower than that, guess again:"
  fi
  ((count++))
  read GUESS 
done
echo "You guessed it in $count tries. The secret number was $NUMBER. Nice job!"
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USER'")
INSERT_GAME=$($PSQL "INSERT INTO games(user_id, tries_number) VALUES ($USER_ID,$count)")
