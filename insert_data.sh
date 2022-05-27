#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# year,round,winner,opponent,winner_goals,opponent_goals

# TRUNCATE 

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
if [[ $WINNER != "winner" ]]
  then
    # get WINNER and OPPONENT
    TEAM=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")

    # if not found
    if [[ -z $TEAM ]]
    then
      # insert NAME OF WINNER TEAM
      INSERT_NAME_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_NAME_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
	  fi

    # get OPPONENT
    TEAM2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    # if not found
    if [[ -z $TEAM2 ]]
    then
    # insert NAME OF OPPONENT TEAM
    INSERT_NAME_RESULT2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_NAME_RESULT2 == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi
	# get new team_id
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER' OR name='$OPPONENT'")
fi

if [[ $YEAR != "year" ]]
  then
    
    #get team_id
    TEAM_ID1=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    TEAM_ID2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    
    
    # get YEAR, ROUND, WINNER_ID, OPPONENT_ID, WGOLS, OGOLS
    GAME=$($PSQL "SELECT year, round, winner_id, opponent_id, winner_goals, opponent_goals FROM games WHERE year=$YEAR AND round='$ROUND' AND winner_id=$TEAM_ID1 AND opponent_id=$TEAM_ID2 AND winner_goals=$WGOALS AND opponent_goals=$OGOALS")

    # if not found
    if [[ -z $GAME ]]
    then
      # insert NAME OF WINNER TEAM
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID1, $TEAM_ID2, $WGOALS, $OGOALS)")
      if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into games, $YEAR, $ROUND, $WINNER, $OPPONENT, $WGOALS, $OGOALS
      fi
	  fi
fi
done