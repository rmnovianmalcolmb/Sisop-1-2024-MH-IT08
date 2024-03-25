#!/bin/bash

login_user() {
    echo "Enter your email:"
    read email
    echo "Enter password:"
    read -s passwd
    echo

    if grep -q "^$email," users.txt; then
        stored_passwd=$(grep "^$email," users.txt | cut -d',' -f5)
        if [ "$passwd" = "$(echo "$stored_passwd" | base64 --decode)" ]; then
            echo "Login successful!"
            echo "$(date +%Y/%m/%d %h:%m:%s) LOGIN SUCCESS" >> auth.log
            if [[ "$email" == *admin* ]]; then
                admin
            else
                echo "You don't have admin previledge! Welcome!"
            fi
        else
            echo "Wrong email or password."
            echo "$(date +%Y/%m/%d %h:%m:%s) LOGIN FAILED" >> auth.log
        fi
    else
        echo "Wrong email or password."
        echo "$(date +%Y/%m/%d %h:%m:%s) LOGIN FAILED" >> auth.log
    fi
}

forgot() {
    read -p "Email: " email
    if grep -q "^$email," users.txt; then
        sec_q=$(grep "^$email," users.txt | cut -d',' -f3)
        echo "Security Question: $sec_q"
        read -p "Answer: " user_ans
        stored_ans=$(grep "^$email," users.txt | cut -d',' -f4)
        if [ "$user_ans" = "$stored_ans" ]; then
            stored_passwd=$(grep "^$email," users.txt | cut -d',' -f5)
            echo "Your password is: $(echo "$stored_passwd" | base64 --decode)"
        else
            echo "Wrong answer."
        fi
    else
        echo "Email not found."
    fi
}

admin() {
    echo "Admin Menu"
    echo "1. Add User"
    echo "2. Edit User"
    echo "3. Delete User"
    echo "4. Logout"
    read admin_choice
    case "$admin_choice" in
        "1") source register.sh ;;
        "2") edit_user ;;
        "3") delete_user ;;
        "4") exit ;;
        *) echo "Invalid option" ;;
    esac
}

edit_user() {
    cat users.txt
    echo "Enter the email of the user you want to edit:"
    read email_edit
    if grep -q "^$email_edit," users.txt; then
        read -p "New Username: " new_username
        read -p "New Security Question: " new_sec_q
        read -p "New Security Answer: " new_sec_a
        read -s -p "New Password: " new_password
        echo
        encrypted_password=$(echo -n "$new_password" | base64)

        sed -i "/^$email_edit,/c\\$email_edit,$new_username,$new_sec_q,$new_sec_a,$encrypted_password" users.txt
        echo "User has been edited!"
    else
        echo "Email not found."
    fi
}

delete_user() {
    cat users.txt
    echo "Enter the email of the user you want to delete:"
    read delete_email
    if grep -q "^$delete_email," users.txt; then
        sed -i "/^$delete_email,/d" users.txt
        echo "User has been deleted"
    else
        echo "Email not found."
    fi
}

echo "Welcome to Login System"
while true; do
    echo "1. Login"
    echo "2. Forgot Password"
    echo "3. Exit"
    read choice
    case "$choice" in
    "1") login_user ;;
    "2") forgot ;;
    "3") echo "Thank you!"; exit ;;
    *) echo "Invalid option" ;;
    esac
done

