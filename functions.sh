temp_directory="$HOME/temp_for_memory"
desktop_directory="$HOME/Рабочий стол"

function clear_desk(){

    if [[ "$(ls -A "$desktop_directory")" ]]
    then
        find "$desktop_directory"/* -delete
    fi
    if [[ "$(ls -A "cats")" ]]
    then
        find "cats"/* -delete
    fi

    if [[ -d "$temp_directory" ]]
    then
        mv "$temp_directory"/* "$desktop_directory"
        rmdir "$temp_directory"
    fi
}

function type_time(){
    delta_time=$(($2-$1))
    hours=$(($delta_time/3600))
    minutes=$(($(($delta_time%3600))/60))
    seconds=$(($(($delta_time%3600))%60))
    if [[ $hours -lt 10 ]]
    then
        hours="0$hours"
    fi

    if [[ $minutes -lt 10 ]]
    then
        minutes="0$minutes"
    fi
    
    if [[ $seconds -lt 10 ]]
    then
        seconds="0$seconds"
    fi

    echo "$hours:$minutes:$seconds"
}

function create_desktop(){
    for ((i=1; i<=$((levels[$(($1))]*2)); i++))
    do
        mkdir "$desktop_directory"/"d$i"
    done
}
