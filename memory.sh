#!/bin/bash
. ./functions.sh

temp_directory="$HOME/temp_for_memory"
desktop_directory="$HOME/Рабочий стол"

if [[ "$(ls -A "$desktop_directory")" ]]
then
    mkdir -p "$temp_directory"
    mv "$desktop_directory"/* "$temp_directory"
fi

levels=(2 9 18 27 36 45 54 63)

while true
do
    read -p "Выберите уровень игры (от 0 до 7): " what_level

    while [ -z "$(echo $what_level | awk '/^[0-7]$/{print $1}')" ]
    do
        if [[ "$what_level" == "exit" ]]
        then
            clear_desk
            exit 0
        else
            echo "Некоректный ввод, попробуйте ещё раз! Ожидается число от 1 до 7."
            read -p "Выберите уровень игры (от 1 до 7): " what_level
        fi
    done

    cards=()
    for ((i=1; i<=levels[$(($what_level))]; i++))
    do
        cards+=("$i")
        cards+=("$i")
        curl -o cats/$i.png https://cataas.com/cat
    done

    cards=( $(shuf -e "${cards[@]}") )
    # echo ${cards[@]}


    create_desktop $what_level

    count=""
    start_time=$(date +%s)
    steps=0

    clear

    while [[ "$(ls -A "cats")" ]]
    do
        read -p "Введите номера двух карточек через пробел: " user_choice
        if [[ "$user_choice" == "exit" ]]
        then
            clear_desk
            exit 0
        fi

        while true
        do
            IFS=' ' read card1 card2 <<< $user_choice
            is_num1=
            if [[ "$user_choice" == "exit" ]]
            then
                clear_desk
                exit 0
            elif [[ -z $card1 || -z $card2 || -z "$(echo $card1 | awk '/^[0-9]+$/{print $1}')" || -z "$(echo $card2 | awk '/^[0-9]+$/{print $1}')" ]]
            then
                echo "Что-то не так."
            elif [[ "$card1" == "$card2" ]]
            then
                echo "Карточки не могут быть одинаковыми!"
            elif [[ -f "cats/${cards[$(($card1-1))]}.png" && -f "cats/${cards[$(($card2-1))]}.png" ]]
            then
                break
            fi
            read -p "Попробуйте ввести номера ещё раз: " user_choice
        done

        steps=$(($steps+1))

        cat1="${cards[$(($card1-1))]}.png"
        cat2="${cards[$(($card2-1))]}.png"

        if [[ "$cat1" == "$cat2" ]]
        then
            find "$desktop_directory"/"d$card1" -delete
            count+="!"
            mv cats/"$cat1" "$desktop_directory"/"НАЙДЕНО$count"
            find "$desktop_directory"/"d$card2" -delete
            cp "$desktop_directory"/"НАЙДЕНО$count" cats/$cat1
            count+="!"
            mv cats/"$cat1" "$desktop_directory"/"НАЙДЕНО$count"
            echo "Пара найдена!"
            continue
        fi

        mv "$desktop_directory"/"d$card1" cats
        mv cats/"$cat1" "$desktop_directory"
        sleep 1
        mv "$desktop_directory"/"d$card2" cats
        mv cats/"$cat2" "$desktop_directory"

        sleep 10

        mv "$desktop_directory"/"$cat1" cats
        mv cats/"d$card1" "$desktop_directory"
        sleep 1
        mv "$desktop_directory"/"$cat2" cats
        mv cats/"d$card2" "$desktop_directory";
    done

    end_time=$(date +%s)
    delta_time=$(type_time $start_time $end_time)
    echo "Было потрачено времени: $delta_time"
    echo "Было потрачено ходов: $steps"

    read -p "Хотите сыграть ещё раз? (д/н): " next
    if [[ -z "$(echo $next | awk '/^[YyДд]$/{print $1}')" ]]
    then
        break
    fi

    clear;
    find "$desktop_directory"/* -delete;
done

clear
echo "Спасибо за игру! <3"
clear_desk
