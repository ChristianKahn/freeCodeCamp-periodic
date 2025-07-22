#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# if no argument is given
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."

else # if argument is given
  # parse argument and then get other info needed
  if [[ $1 =~ ^[0-9]+$ ]] # if integer
  then
    # read variables in based on knowledge that input was an atomic number, use process sub so variables have scope outside of if
    IFS='|' read atomic_number symbol name type atomic_mass melting_point_celsius boiling_point_celsius \
    <<< $($PSQL "select atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where atomic_number=$1")

  elif [[ $1 =~ ^[a-zA-Z]$ || $1 =~ ^[a-zA-Z]{2}$ ]] # if symbol
  then
    # read variables in based on knowledge that input was a symbol, use process sub so variables have scope outside of if
    IFS='|' read atomic_number symbol name type atomic_mass melting_point_celsius boiling_point_celsius \
    <<< $($PSQL "select atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where symbol ilike '$1'")

  elif [[ $1 =~ ^[a-zA-Z]+$ ]] # if name
  then
    # read variables in based on knowledge that input was a name, use process sub so variables have scope outside of if
    IFS='|' read atomic_number symbol name type atomic_mass melting_point_celsius boiling_point_celsius \
    <<< $($PSQL "select atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where name ilike '$1'")
  fi

  # print output
  # check that a valid database entry was found
  if [[ ! -z $atomic_number ]]
  then
    echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
  else echo "I could not find that element in the database."
  fi

fi
