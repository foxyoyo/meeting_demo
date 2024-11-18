#!/bin/bash
LOG="/Users/foxyo/xxxxxxx/Result"
ARRAY_IPS=""
MATCH_IPS=""
INDEX=0
# SUBNET="10.0.2.0/24"

helpFunction()
{
   echo ""
   echo 'Usage: $0 check_IP_range.sh -c "10.0.2.0/24" -f ./IP_list '
   echo -e "\t -f: Your IP_list Path"
   echo -e "\t -c: Your Checking Subnet"
   exit 1 # Exit script after printing help
}

check_ip_in_subnet()
{
    while read -r line
    do
    #echo "$line"
    ARRAY_IPS[$INDEX]=$line
    INDEX=$(($INDEX+1))
    done < "$INPUT"

    for IP in ${ARRAY_IPS[@]}
    do
    # echo "Call grepcdir check ip = $IP in subnet = $SUBNET or not"
    OUTPUT_GREPCIDR=$(grepcidr ${SUBNET} <(echo ${IP}))
    if [[ ${OUTPUT_GREPCIDR} = ${IP} ]]
        then
            echo "${IP} is in ${SUBNET}" >> $LOG
            MATCH_IPS+=("${IP}")
        else
            echo "${IP} is not in ${SUBNET}" >> $LOG
    fi
    done
}

show_result()
{
    # echo "${MATCH_IPS[@]}"
    if [[ -z ${MATCH_IPS[@]} ]]; then
        echo "There are no any ip list in ($INPUT) in the ${SUBNET}"
    else    
        echo "==================="
        echo -e "The ip belong specifc subnet ($SUBNET) as below : "
        for IP in ${MATCH_IPS[@]}
            do
             echo -e "${IP}"
        done
    fi
}

#########
while getopts "f:c:" opt
do
   case "$opt" in
      f ) INPUT="$OPTARG" ;;
      c ) SUBNET="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$INPUT" ] || [ -z "$SUBNET" ]
   then 
        echo "Some or all of the parameters are empty";
        helpFunction
    else
        check_ip_in_subnet
        show_result
fi