#!/bin/bash

unique_email(){
    if grep -q "$1" users.txt; then
        echo "Email already used, please enter a new email"
        return 1
    else
        return 0
    fi
}

encryption(){
    encrypt=$(echo -n "$1" | base64)
}

while true; do
    echo "Welcome to Registration System"
    read -p "Enter your email : " email
    unique_email "$email" || continue
    read -p "Enter your username : " username
    read -p "Enter a security question: " sec_q
    read -p "Enter the answer of your security question: " sec_a
    while true; do
        read -s -p "Enter a password minimum 8 characters, at least 1 uppercase letter, 1 lowercase letter, 1 digit, 1 symbol, and not the same as username, birthdate, or name : " passwd
        echo

        if [[ ${#passwd} -lt 8 || ! "$passwd" =~ [[:upper:]] || ! "$passwd" =~ [[:lower:]] || ! "$passwd" =~ [[:digit:]] || ! "$passwd" =~ [[:punct:]] ]]; then
            echo "Password doesn't meet the requirements, please try again!"
            echo "$(date +%Y/%m/%d %h:%m:%s) REGISTER FAILED" >> auth.log	     
        else 
            break
        fi
    done

    encryption "$passwd"

    if [[ "$email" == *admin* ]]; then
        role="admin"
    else 
        role="user"
    fi

    echo "$email,$username,$sec_q,$sec_a,$encrypt,$role" >> users.txt
    echo "$(date +%Y/%m/%d %h:%m:%s) REGISTER SUCCESS" >> auth.log 
    echo "User registered successfully!"
    break
done
