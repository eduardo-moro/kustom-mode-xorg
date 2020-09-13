#thanks Bob Copeland for this function! http://bobcopeland.com/blog/2012/10/goto-in-bash/ 
function jumpto
{
    label=$1
    cmd=$(sed -n "/$label:/{:a;n;p;ba};" $0 | grep -v ':$')
    eval "$cmd"
    exit
}  

function setDisplay(){
    w=$1;h=$2;s=$3;
    
    modo=`sudo cvt $w $h $s | grep Modeline`;
    modo=$(sed 's/[^ ]* //' <<< $modo); #remove trash stuff, we dont want trash
    name=$(sed 's/[ ].* //' <<< $modo);
    name=$(sed 's/+.*//' <<< $name);
    name=$(sed 's/-.*//' <<< $name);
    echo $modo
    echo $name
    
    xrandr --newmode $modo $s;
    echo list of avalilable displays:
    xrandr | grep connected
    
    read -r -p "which display you want to add your new profile: " display;
    
    read -r -p "Do you want to save the mode $name to $display? [y/n] " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY]|"")$ ]] 
        then sudo xrandr --addmode $display $name;
    fi
    read -r -p "Do you want to use the mode $name to $display? [y/n] (enter = n)" response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]] 
        then sudo xrandr --output $display $name
    fi
    
    echo "thank you for using my app :)"
}

width=480;heigth=320;sync=60.00;

clear;
echo "super custom resolution creator";
echo "initial values: "$width x $heigth / $sync;
echo"";

    start=${1:-"init"}
    jumpto $start;

init:
    read -r -p "enter custom width: " width;
    read -r -p "enter custom heigth: " heigth;
    read -r -p "enter custom refresh rate: " sync;


    if [ -z "$width" ]
        then width=480;
    fi
    if [ -z "$heigth" ]
        then heigth=320;
    fi
    if [ -z "$sync" ]
        then sync=60;
    fi

    echo "values: "$width x $heigth / $sync
    read -r -p "are you sure? [y/n] " response

    if [[ "$response" =~ ^([yY][eE][sS]|[yY]|"")$ ]]
    then
        setDisplay $width $heigth $sync;
    else
        jumpto $start;
    fi
    
#######END_OF_FILE#######

## made by eduardo moro in 2020 - 09 - 13
