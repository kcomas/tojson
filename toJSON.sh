#!/bin/bash

#The output of the command
output=''

#function to remove last selected charater from a file
remove_last_comma() {
    echo $1  | sed 's/,$//'
}

for var in "$@"
    do
    ##switch through the commands
    case $var in
        ifstat)
            output=$output"\"ifstat\":{"$(ifstat 1 1 | column -t | awk 'NR==3 {print "\"in\":"$1 ",\"out\":"$2}')"},"            
        ;;
        iostat)
            tmp="\"iostat\":{"$(iostat | column -t | awk '
            NR==3 {print "\"user\":"$1 ",\"nice\":"$2 ",\"system\":"$3 ",\"iowait\":"$4 ",\"steal\":"$5 ",\"idle\":"$6} 
            NR==4 {print ",\"devices\":["} 
            NR>=5 {print "{\"name\":\""$1"\"" ",\"tps\":"$2 ",\"kbrs\":"$3 ",\"kbws\":"$4 ",\"kbs\":"$5 ",\"kbw\":"$6"},"} 
            ')"]},"
            #remove the extra comma added
            tmp=$(echo $tmp | sed 's/},\]/}\]/')
            output=$output$tmp
        ;;
    esac
done

echo "{"$(remove_last_comma "$output")"}"
