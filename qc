#! env bash

set -e -u -x -o pipefail

site=$(curl -f https://questionablecontent.net/ | \
 perl -wne '/<img src="https:\/\/www\.questionablecontent\.net\/comics\/([0-9]+)\.(png|gif|jpg|jpeg)">/ && print($1);')
if [[ ${site:-unset} == unset ]]; then exit 1; fi

have=$(< have)
if [[ ${have:-unset} == unset ]]; then have=0; fi

ex=0

for (( i = $have + 1; i <= $site; i++ )); do
	base=https://questionablecontent.net/comics/$i
	if ! curl -O -f $base.png; then
		if ! curl -O -f $base.jpg; then
			if ! curl -O -f $base.gif; then
				ex=3
				break
			fi
		fi
	fi

	echo $i > have
done

exit $ex
