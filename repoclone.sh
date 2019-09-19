#!/bin/bash
# r00tNepal \M/
USER="$1"
CURRENT_PATH=$(pwd)
if [ -z $USER ]; then
  	echo ""
	echo -e " [-] Usage: repoclone.sh <GITHUB-USERNAME>"
	exit
fi
createdir=$(mkdir -p "$CURRENT_PATH/tmp/")
for (( i=0; ; i++ ));
do
echo "Fetching"
req=$(curl --silent "https://api.github.com/users/$USER/repos?page=$i&per_page=100"  | jq '.[]|.full_name' | cut -d '/' -f 2 | tr -d '"' | tee -a $CURRENT_PATH/tmp/$USER.repo  )
len=$(curl --write-out '%{size_download}' "https://api.github.com/users/$USER/repos?page=$i&per_page=100" --silent -o /dev/null)
if [ $len -le 5 ]; then
echo "Finished Scraping"
break
fi
done
echo -e ""
file=$(cat $CURRENT_PATH/tmp/$USER.repo | sort -u | sponge $CURRENT_PATH/tmp/$USER.repo )
echo -e " Repo saved at: tmp/$USER.repo"
vcounter=$(cat $CURRENT_PATH/tmp/$USER.repo | wc -l )
echo -e "$RED   TOTAL REPOS : ${vcounter} , "
