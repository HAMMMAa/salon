#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c "

#welcome to salon
echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU(){
  echo -e "\nWelcome to My Salon, how can I help you?\n"
  #Show the service
  SHOW_SERVICE=$($PSQL "SELECT * FROM services")
  echo "$SHOW_SERVICE" | while read SERVICE_ID NAME
  do 
    echo $SERVICE_ID $NAME | sed 's/|/) /'
    done  
  read SERVICE_ID_SELECTED 
  if [[ $SERVICE_ID_SELECTED = [1-5] ]]
  then
    #name service
    NM_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    #get phone number
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    #if not found
    if [[ -z $CUSTOMER_ID ]]
    then
    #get name 
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
    #insert to customers
      INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    #get time for service
      echo -e "\nWhat time would you like your $NM_SERVICE, $CUSTOMER_NAME?"
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    #schedule for service
      read SERVICE_TIME
      echo -e "\nI have put you down for a $NM_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
      INSERT_APP=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
    else
      #get time for service
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID")
      echo -e "\nWhat time would you like your $NM_SERVICE, $CUSTOMER_NAME?"
    #schedule for service
      read SERVICE_TIME
      echo -e "\nI have put you down for a $NM_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
      INSERT_APP=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
      fi
  else
    MAIN_MENU
    fi
}

MAIN_MENU
