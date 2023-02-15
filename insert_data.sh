#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")


# read the games.csv file using cat and apply a while loop to read row by row
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

            #To insert the teams table data, we get the winning team name first;
    #exclude column names row
    if [[ $WINNER != "winner" ]]
    then
      #get team name
      TEAM1=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
      #if team name is not found we need to include the new team to the table
      if [[ -z $TEAM1 ]]
      then
        #insert new team
        INSERT_TEAM1=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        #echo call to let us know team was inserted
        if [[ $INSERT_TEAM1 == "INSERT 0 1" ]]
        then
          echo Inserted team, $WINNER
        fi
      fi
    fi

            #Secondily, we get the opponent team name.
    #exclude column names row
    if [[ $OPPONENT != "opponent" ]]
    then
      #get team name
      TEAM2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
      #if team name is not found we need to include the new team to the table
      if [[ -z $TEAM2 ]]
      then
        #insert new team
        INSERT_TEAM2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        #echo call to let us know team was inserted
        if [[ $INSERT_TEAM2 == "INSERT 0 1" ]]
        then
          echo Inserted team, $OPPONENT
        fi
      fi
    fi

            #To insert the games data table,

    #exclude column names row
    if [[ YEAR != "year" ]]
    then
      #get winner_id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      #get opponent_id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      #insert new games row
      INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
      #echo call to let us know what was added
      if [[ $INSERT_GAME == "INSERT 0 1" ]]
      then
        echo New game added: $YEAR, $ROUND, $WINNER_ID VS $OPPONENT_ID, score $WINNER_GOALS : $OPPONENT_GOALS
      fi
    fi
done