#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m' # Reset to default
function wrong1 {
  echo
  echo -e "${RED}        O             ${RESET}"
  echo
  echo
  echo
  echo
  echo
}

function wrong2 {
  echo
  echo -e "${RED}         O            ${RESET}"
  echo -e "${RED}         |            ${RESET}"
  echo
  echo
  echo
  echo
  echo
}

function wrong3 {
  echo
  echo -e "${RED}         O            ${RESET}"
  echo -e "${RED}         |\           ${RESET}"
  echo
  echo
  echo
  echo
  echo
}

function wrong4 {
  echo
  echo -e "${RED}         O            ${RESET}"
  echo -e "${RED}        /|\           ${RESET}"
  echo
  echo
  echo
  echo
  echo
}

function wrong5 {
  echo
  echo -e "${RED}         O           ${RESET}"
  echo -e "${RED}        /|\          ${RESET}"
  echo -e "${RED}        /            ${RESET}"
  echo
  echo
  echo
  echo
}

function wrong6 {
  echo
  echo -e "${RED}         O            ${RESET}"
  echo -e "${RED}        /|\           ${RESET}"
  echo -e "${RED}        / \           ${RESET}"
  echo
  echo
  echo
  echo
}

function wrong7 {
  echo
  echo -e "${RED}         __________   ${RESET}"
  echo -e "${RED}         |        |   ${RESET}"
  echo -e "${RED}         O        |   ${RESET}"
  echo -e "${RED}        /|\       |   ${RESET}"
  echo -e "${RED}        / \       |   ${RESET}"
  echo -e "${RED}    ______________|___${RESET}"
  echo
}

function win {
  echo -e "${GREEN} *     * ******* *     *   *     *  *******  *    *  * ${RESET}"
  echo -e "${GREEN}  *   *  *     * *     *   *     *     *     **   *  * ${RESET}"
  echo -e "${GREEN}    *    *     * *     *   *  *  *     *     * *  *  * ${RESET}"
  echo -e "${GREEN}    *    *     * *     *   *  *  *     *     *  * *  * ${RESET}"
  echo -e "${GREEN}    *    *     * *     *    * * *      *     *   **    ${RESET}"
  echo -e "${GREEN}    *    ******* *******     * *    *******  *    *  * ${RESET}"
  echo -en "\n\n\n"
}

function display {
    DATA[0]=" #     #    #    #     #  #####  #     #    #    #     #  "
    DATA[1]=" #     #   # #   ##    # #     # ##   ##   # #   ##    #  "
    DATA[2]=" #     #  #   #  # #   # #       # # # #  #   #  # #   #  "
    DATA[3]=" ####### #     # #  #  # #  #### #  #  # #     # #  #  #  " 
    DATA[4]=" #     # ####### #   # # #     # #     # ####### #   # #  "
    DATA[5]=" #     # #     # #    ## #     # #     # #     # #    ##  "
    DATA[6]=" #     # #     # #     #  #####  #     # #     # #     #  " 
    echo

REAL_OFFSET_X=$(($((`tput cols` - 56)) / 2))
REAL_OFFSET_Y=$(($((`tput lines` - 6)) / 2))

draw_char() {
V_COORD_X=$1
V_COORD_Y=$2

tput cup $((REAL_OFFSET_Y + V_COORD_Y)) $((REAL_OFFSET_X + V_COORD_X))

printf %c ${DATA[V_COORD_Y]:V_COORD_X:1}
}
trap 'exit 1' INT TERM
tput civis
clear

tempp=8

while :; do

tempp=`expr $tempp - 8`

for ((c=1; c <= 7; c++)); do

tput setaf $c

for ((x=0; x<${#DATA[0]}; x++)); do

for ((y=0; y<=6; y++)); do

draw_char $x $y

done
done
done
sleep 1
clear
break
done
}

function check_file_validity {
  if [[ ! -f "$1" || ! -s "$1" ]]; then
    zenity --error --text="File not found or is empty: $1" --title="Error"
    return 1
  fi
  return 0
}

function resolve_file_path {
  local base_dir="/Users/mj/Downloads/UniXProject"
  if [[ -f "$1" ]]; then
    echo "$1"
  elif [[ -f "$base_dir/$1" ]]; then
    echo "$base_dir/$1"
  else
    echo ""
  fi
}

function choice() {
  local choose=$(zenity --list --radiolist \
    --title="Choose a topic" \
    --column="Select" --column="Topic" \
    TRUE "Hollywood Movies" FALSE "Bollywood Movies" FALSE "Fashion" FALSE "Cars" FALSE "English words" FALSE "Select a file" 2>/dev/null)

  # If nothing is selected, exit or retry
  if [[ -z "$choose" ]]; then
    zenity --error --text="No option selected. Exiting..." --title="Error" 2>/dev/null
    exit 1
  fi

  case $choose in
    "Hollywood Movies") filename=$(resolve_file_path "movies") ;;
    "Bollywood Movies") filename=$(resolve_file_path "bollywood") ;;
    "English words") filename=$(resolve_file_path "englishwords") ;;
    "Cars") filename=$(resolve_file_path "cars") ;;
    "Fashion") filename=$(resolve_file_path "makeup") ;;
    "Select a file")
      filename=$(zenity --file-selection --title="Select a file" 2>/dev/null)
      if [[ -z "$filename" ]]; then
        zenity --error --text="No file selected. Please try again." --title="Error" 2>/dev/null
        choice
        return
      fi
      ;;
    *)
      zenity --error --text="Invalid selection." --title="Error" 2>/dev/null
      choice
      return
      ;;
  esac

  if [[ -z "$filename" ]] || ! check_file_validity "$filename"; then
    choice
  fi
}

function menu() {
  local selection=$(zenity --list --radiolist \
    --title="Game Menu" \
    --column="Select" --column="Option" \
    TRUE "Play the game" FALSE "Exit" 2>/dev/null)

  # If nothing is selected, exit gracefully
  if [[ -z "$selection" ]]; then
    zenity --error --text="No option selected. Exiting..." --title="Error" 2>/dev/null
    exit 1
  fi

  case $selection in
    "Play the game") main ;;
    "Exit") exit ;;
    *)
      zenity --error --text="Invalid selection." --title="Error" 2>/dev/null
      menu
      ;;
  esac
}
function main() {
  a=()
  while IFS= read -r line; do
    a+=("$line")
  done < "$filename"

  if [[ ${#a[@]} -eq 0 ]]; then
    zenity --error --text="The file has no valid entries to play with!" --title="Error"
    menu
    return
  fi

  randind=$((RANDOM % ${#a[@]}))
  entry=${a[$randind]}
  
  # Separate the movie name and the hint
  movie=$(echo "$entry" | cut -d':' -f1 | tr -dc '[:alnum:] \n\r' | tr '[:upper:]' '[:lower:]')
  hint=$(echo "$entry" | cut -d':' -f2)

  guess=()
  guesslist=()
  guin=0
  len=${#movie}

  for ((i=0; i<$len; i++)); do
    guess[$i]="_"
  done

  mov=()
  for ((i=0; i<$len; i++)); do
    mov[$i]=${movie:$i:1}
  done

  for ((j=0; j<$len; j++)); do
    if [[ ${mov[$j]} == " " ]]; then
      guess[$j]=" "
    fi
  done

  wrong=0

  while [[ $wrong -lt 7 ]]; do
    case $wrong in
      0) echo " " ;;
      1) wrong1 ;;
      2) wrong2 ;;
      3) wrong3 ;;
      4) wrong4 ;;
      5) wrong5 ;;
      6) wrong6 ;;
    esac

    notover=0
    for ((j=0; j<$len; j++)); do
      if [[ ${guess[$j]} == "_" ]]; then
        notover=1
      fi
    done

    echo "Hint: $hint"
    echo "Guess List: ${guesslist[@]}"
    echo "Wrong guesses: $wrong"
    for ((k=0; k<$len; k++)); do
      echo -n "${guess[$k]} "
    done
    echo
    echo

    if [[ $notover -eq 1 ]]; then
      echo -n "Guess a letter: "
      read -n 1 -e letter
      letter=$(echo $letter | tr [A-Z] [a-z])
      guesslist[$guin]=$letter
      guin=$((guin + 1))
    fi

    f=0
    for ((i=0; i<$len; i++)); do
      if [[ ${mov[$i]} == $letter ]]; then
        guess[$i]=$letter
        f=1
      fi
    done

    if [[ f -eq 0 ]]; then
      wrong=$((wrong + 1))
    fi

    if [[ $notover -eq 0 ]]; then
      echo
      win
      zenity --title="Yayyyy!!!" --info --text="Congratulations! You won the game!" --width=300 --height=100 2>/dev/null
      echo $movie
      echo
      play_again
    fi
    clear
  done

  wrong7
  echo -e "${RED}You lost!${RESET}"
  zenity --title="Awwwwww!!!" --info --text="You lost :(" --width=300 --height=100 2>/dev/null
  echo "The word was: $movie"
  play_again
}

function display_instructions() {
  local icon_path="/Users/mj/Downloads/UniXProject/hangman.jpg" # Update this path to your icon file location

  zenity --info \
    --title="Game Instructions" \
    --text="Welcome to Hangman!\n\nInstructions:\n1. Select a topic of your choice.\n2. A random word will be chosen from the selected topic.\n3. Guess the letters in the word. You have 7 incorrect attempts.\n4. Use only alpha-numeric characters for guessing.\n5. Have fun and try to guess the word before the man is hanged!\n\nClick OK to start the game." \
    --width=500 --height=400 \
    --window-icon="$icon_path" 2>/dev/null
}

function play_again(){
  echo
  echo -n "Would you like to play again? (y/n) "
  read -n 1 choice
  case $choice in
    [yY]) clear; main ;;
    *) clear; echo "Thanks for playing!"; exit ;;
  esac
}

function init() {
  clear
  display
  display_instructions
  choice
  if [[ -z "$filename" ]]; then
    echo "No valid file selected. Exiting..."
    exit 1
  fi
  menu
}
init
