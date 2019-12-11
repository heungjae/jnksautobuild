#!/bin/bash

cli_User=sybase
cli_User_pte_key="/Users/michael/.ssh/id_rsa-sybase"

if [[ "$OSTYPE" == "darwin"* ]]; then
readonly TMPFILE="/tmp/$(basename -s .sh "$0")-"$$".txt"
else
readonly TMPFILE="/tmp/$(basename "$0" .sh)-"$$".txt"   
fi

readonly numparms=1

[ $# -ne $numparms ] && { echo "Usage: $0 sky-ip (10.61.5.187) "; exit 1;  }

act_ip=$1

cat > $TMPFILE <<EOT

echo "-------------------------------------------------"
udsinfo lsworkflow -nohdr -delim ^ | while IFS="^" read -r -a wflow ; do 
echo " "
echo "name: \${wflow[4]}"
appname=\`udsinfo lsapplication -nohdr -filtervalue id=\${wflow[6]} -delim ^ | cut -d ^ -f11\`
echo "  AppName: \$appname"
echo "  status: \${wflow[10]}"
done
exit
EOT

ssh -p 22 -i $cli_User_pte_key $cli_User@$act_ip 2>/dev/null < $TMPFILE
