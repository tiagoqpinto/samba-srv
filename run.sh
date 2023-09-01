#!/bin/bash
CONFIG_FILE=/app/smb.conf

#LOGLEVEL env in docker_compose
[ -z "$LOG_LEVEL" ] && echo LOG_LEVEL=0

prep () {
    initialized=$(getent passwd | grep -c '^smbuser:')
    if [ "$initialized" = "0" ]; then
          useradd smbuser -M
    fi

    for i in $(seq 0 9)
    do
        prefix="SHARE_"
        var="$prefix$i"
        if [[ -n "${!var}" ]]
        then
            create_share "${!var}"
        fi
    done
}

create_share () {
    item="$1"
    arr=( ${item//:/ } )

    [ "${#arr[@]}" != "4" ] && echo error in CONF, exiting && exit

    sharename=${arr[0]}
    sharepath=${arr[1]}
    username=${arr[2]}
    password=$(cat /run/secrets/"$username")
    [ -z "$password" ] && echo No password && exit

    readwrite="${arr[3]}"

    printf "Creating a share -%s- with location -%s- for user -%s- with permissions -%s-\n $sharename $sharepath $username $readwrite"
    #echo $password

    useradd "$username" -M
    (echo "$password"; echo "$password") | smbpasswd -s -a "$username"

    echo "[$sharename]" >>"$CONFIG_FILE"
    chown smbuser "$sharepath"

    echo "path = \"$sharepath\"" >>"$CONFIG_FILE"

    if [[ "rw" = "$readwrite" ]] ; then
        echo "read only = no" >>"$CONFIG_FILE"
    else
        echo "read only = yes" >>"$CONFIG_FILE"
    fi

}

exec_smb () {
    exec ionice -c 3  smbd --configfile="$CONFIG_FILE" --debug-stdout -F --no-process-group --debuglevel="$LOG_LEVEL"
}

main () {
    prep
    exec_smb
}


main