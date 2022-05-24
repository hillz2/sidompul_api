#!/bin/sh

nomer_hp="$1"
email=""
file_output="/tmp/xl.json"

login() {
	echo "Login $email..."
	curl -sH 'x-dynatrace: MT_3_2_763403741_15-0_a5734da2-0ecb-4c8d-8d21-b008aeec4733_30_456_73' \
	-H 'accept: application/json' -H 'authorization: Basic ZGVtb2NsaWVudDpkZW1vY2xpZW50c2VjcmV0' \
	-H 'language: en' -H 'version: 4.1.2' -H 'user-agent: okhttp/3.12.1' \
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
	-H 'language: en' -H 'version: 4.1.2' -H 'user-agent: okhttp/3.12.1' \
	-X GET https://srg-txl-login-controller-service.ext.dp.xl.co.id/v2/auth/email/${email}/${otp}/000000000000000 \
	-o "$file_output"
	statusCode=$(cat $file_output | jq --raw-output '.statusCode')
	if [[ "$statusCode" == 200 ]]; then
		accessToken=$(cat $file_output | jq --raw-output '.result.data.accessToken')
		refreshToken=$(cat $file_output | jq --raw-output '.result.data.refreshToken')
		jq --null-input --arg at "$accessToken" --arg rt "$refreshToken" '{"accessToken": $at, "refreshToken": $rt}' > xl.token
		echo "OTP Verified..."
		echo "Access Token: $accessToken"
		echo "Refresh Token: $refreshToken"
	else
		statusDescription=$(cat $file_output | jq --raw-output '.statusDescription')
		echo "[$statusCode] $statusDescription"
		exit 100
	fi
}
refresh_token() {
	if [[ -f "xl.token" ]]; then
		echo "Refreshing token..."
		refreshToken=$(jq --raw-output '.refreshToken' xl.token)
		curl -sH 'x-dynatrace: MT_3_3_763403741_21-0_a5734da2-0ecb-4c8d-8d21-b008aeec4733_0_209_44' \
		-H 'accept: application/json' -H 'authorization: Basic ZGVtb2NsaWVudDpkZW1vY2xpZW50c2VjcmV0' \
		-H 'language: en' -H 'version: 4.1.2' -H 'content-type: application/x-www-form-urlencoded' \
		-H 'user-agent: okhttp/3.12.1' \
		-X POST https://srg-txl-login-controller-service.ext.dp.xl.co.id/v1/login/token/refresh \
		-d "grant_type=refresh_token&refresh_token=$refreshToken&imei=000000000000000" \
		-o "$file_output"
		statusCode=$(cat $file_output | jq --raw-output '.statusCode')
		if [[ "$statusCode" == 200 ]]; then
			accessToken=$(jq --raw-output '.result.accessToken' "$file_output")
			refreshToken=$(jq --raw-output '.result.refreshToken' "$file_output")
			jq --null-input --arg at "$accessToken" --arg rt "$refreshToken" '{"accessToken": $at, "refreshToken": $rt}' > xl.token
			echo "Token refreshed"
		else
			echo "Failed to refresh the token"
			statusDescription=$(cat $file_output | jq --raw-output '.statusDescription')
			echo "[$statusCode] $statusDescription"
			login
			send_otp
		fi
	else
		login
		send_otp
	fi
}
cek_kuota_data() {
	echo "Cek kuota $nomer_hp..."
	curl -sH 'x-dynatrace: MT_3_1_763403741_16-0_a5734da2-0ecb-4c8d-8d21-b008aeec4733_0_396_167' \
	-H 'accept: application/json' -H "authorization: Bearer $accessToken" \
	-H 'language: en' -H 'version: 4.1.2' -H 'user-agent: okhttp/3.12.1' \
	-X GET https://srg-txl-utility-service.ext.dp.xl.co.id/v2/package/check/${nomer_hp} \
	-o "$file_output"
	statusCode=$(cat $file_output | jq --raw-output '.statusCode')
	if [[ "$statusCode" == 200 ]]; then
		jq '.result.data' $file_output | awk -F '"' '{print $2 ": " $4}' | sed '/: $/d; /^: /d; s/^name/\nname/g' | awk '{print toupper($0)}'
	else
		statusDescription=$(cat $file_output | jq --raw-output '.statusDescription')
		echo "[$statusCode] $statusDescription"
		exit 100
	fi
}
logout_xl(){
	curl -H 'x-dynatrace: MT_3_4_763403741_22-0_a5734da2-0ecb-4c8d-8d21-b008aeec4733_0_284_143' \
	-H 'accept: application/json' -H "authorization: Bearer $accessToken" -H 'language: en' \
	-H 'version: 4.1.2' -H 'user-agent: okhttp/3.12.1' \
	-X POST https://srg-txl-login-controller-service.ext.dp.xl.co.id/v3/auth/logout \
	-o "$file_output"
	if [[ "$statusCode" == 200 ]]; then
		echo "Logout success"
	else
		statusDescription=$(cat $file_output | jq --raw-output '.statusDescription')
		echo "[$statusCode] $statusDescription"
		exit 100
	fi
}
refresh_token
cek_kuota_data
#logout_xl
