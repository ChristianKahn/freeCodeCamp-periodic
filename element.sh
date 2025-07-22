#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# if no argument is given
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # if argument is given
  # parse argument and then get other info needed
  if [[ $1 =~ ^[0-9]+$ ]] # if integer
  then
    atomic_number_input=$1
    
    # get other variables and confirm an entry exists
    echo $($PSQL "select atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where atomic_number=$atomic_number_input") | while IFS='|' read atomic_number symbol name type atomic_mass melting_point_celsius boiling_point_celsius
    do
      if [[ -z $atomic_number ]]
      then
        echo "I could not find that element in the database."
      else
        # if entry exists, print information
        echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
      fi
    done

  elif [[ $1 =~ ^[a-zA-Z]$ || $1 =~ ^[a-zA-Z]{2}$ ]] # if symbol
  then
    symbol_input=$1

    # get other variables and confirm an entry exists
    echo $($PSQL "select atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where symbol ilike '$symbol_input'") | while IFS='|' read atomic_number symbol name type atomic_mass melting_point_celsius boiling_point_celsius
    do
      if [[ -z $atomic_number ]]
      then
        echo "I could not find that element in the database."
      else
        # if entry exists, print information
        echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
      fi
    done

  elif [[ $1 =~ ^[a-zA-Z]+$ ]] # if name
  then
    name_input=$1

    # get other variables and confirm an entry exists
    echo $($PSQL "select atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where name ilike '$name_input'") | while IFS='|' read atomic_number symbol name type atomic_mass melting_point_celsius boiling_point_celsius
    do
      if [[ -z $atomic_number ]]
      then
        echo "I could not find that element in the database."
      else
        # if entry exists, print information
        echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
      fi
    done

  else # if wrong type
    echo "I could not find that element in the database."
  fi

  # if not found

  # print output

fi
