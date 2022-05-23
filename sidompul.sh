#!/bin/sh

nomer_hp="$1"
email="YOUREMAILHERE@gmail.com"
file_output="/tmp/xl.json"

login() {
	echo "Login $email"
	curl -sH 'x-dynatrace: MT_3_2_763403741_15-0_a5734da2-0ecb-4c8d-8d21-b008aeec4733_30_456_73' \
	-H 'accept: application/json' -H 'authorization: Basic ZGVtb2NsaWVudDpkZW1vY2xpZW50c2VjcmV0' \
	-H 'language: en' -H 'version: 4.1.2' --compressed -H 'user-agent: okhttp/3.12.1' \
	-X POST https://srg-txl-login-controller-service.ext.dp.xl.co.id/v2/auth/email/${email} \
	-o "$file_output"
	statusCode=$(cat $file_output | jq --raw-output '.statusCode')
	if [[ "$statusCode" == 200 ]]; then
		echo "OTP Sent..."
	else
		statusDescription=$(cat $file_output | jq --raw-output '.statusDescription')
		echo "[$statusCode] $statusDescription"
		exit 100
	fi
}
send_otp() {
	read -p 'Insert OTP: ' otp
	curl -sH 'x-dynatrace: MT_3_2_763403741_15-0_a5734da2-0ecb-4c8d-8d21-b008aeec4733_30_456_73' \
	-H 'accept: application/json' -H 'authorization: Basic ZGVtb2NsaWVudDpkZW1vY2xpZW50c2VjcmV0' \
	-H 'language: en' -H 'version: 4.1.2' --compressed -H 'user-agent: okhttp/3.12.1' \
	-X GET https://srg-txl-login-controller-service.ext.dp.xl.co.id/v2/auth/email/${email}/${otp}/000000000000000 \
	-o "$file_output"
	statusCode=$(cat $file_output | jq --raw-output '.statusCode')
	if [[ "$statusCode" == 200 ]]; then
		accessToken=$(cat $file_output | jq --raw-output '.result.data.accessToken')
		echo "OTP Verified..."
		echo "Access Token: $accessToken"
	else
		statusDescription=$(cat $file_output | jq --raw-output '.statusDescription')
		echo "[$statusCode] $statusDescription"
		exit 100
	fi
}
cek_kuota_data() {
	echo "Cek Kuota Data..."
	curl -sH 'x-dynatrace: MT_3_1_763403741_16-0_a5734da2-0ecb-4c8d-8d21-b008aeec4733_0_396_167' \
	-H 'accept: application/json' -H "authorization: Bearer $accessToken" \
	-H 'language: en' -H 'version: 4.1.2' --compressed -H 'user-agent: okhttp/3.12.1' \
	-X GET https://srg-txl-utility-service.ext.dp.xl.co.id/v2/package/check/${nomer_hp} \
	-o "$file_output"
	statusCode=$(cat $file_output | jq --raw-output '.statusCode')
	if [[ "$statusCode" == 200 ]]; then
		packageName=$(cat $file_output | jq --raw-output '.result.data.packageInfo[2][].packages.name')
		expDate=$(cat $file_output | jq --raw-output '.result.data.packageInfo[2][].packages.expDate')
		bname=$(cat $file_output | jq --slurp --raw-output '.[].result.data.packageInfo[2][].benefits[] | select(.bname == "Unlimited").bname')
		quota=$(cat $file_output | jq --slurp --raw-output '.[].result.data.packageInfo[2][].benefits[] | select(.bname == "Unlimited").quota')
		remaining=$(cat $file_output | jq --slurp --raw-output '.[].result.data.packageInfo[2][].benefits[] | select(.bname == "Unlimited").remaining')
		#echo "Nomer HP: $nomer_hp"
		#echo "Package: $packageName"
		#echo "Exp: $expDate"
		#echo "App quota: $bname ($quota / $remaining left)"
		jq '.result.data' $file_output | awk -F '"' '{print $2 ": " $4}' | sed '/^: /d' | tr [:lower:] [:upper:]
	else
		statusDescription=$(cat $file_output | jq --raw-output '.statusDescription')
		echo "[$statusCode] $statusDescription"
		exit 100
	fi
}

login
send_otp
#accessToken="68c59a00-d5c7-48c5-b07e-fd5f27b6beca"
cek_kuota_data
