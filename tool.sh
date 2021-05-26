#!/bin/bash

check_clerkb_files_exists(){
    local -a arr=( 
		"poa"  "state"
    ) 
	local path=`pwd`/test-result/scripts/clerkb
	check_multiple_files_exists "$path" "${arr[@]}"
}

check_scripts_files_exists(){
    local -a arr=( 
		"always-success"  "custodian-lock"   "eth-account-lock"   "meta-contract-generator"  "stake-lock"  "sudt-generator"  "withdrawal-lock" 	
		"challenge-lock"  "deposition-lock"  "eth-account-lock.debug"  "meta-contract-validator"  "state-validator"  "sudt-validator" 
	) 
    local path=`pwd`/test-result/scripts/godwoken-scripts
	check_multiple_files_exists "$path" "${arr[@]}"
}

check_polyjuice_files_exists(){
    local -a arr=( 
		"generator"        "generator_log"        "validator"        "validator_log"
        "generator.debug"  "generator_log.debug"  "validator.debug"  "validator_log.debug"
	) 
    local path=`pwd`/test-result/scripts/godwoken-polyjuice
    check_multiple_files_exists "$path" "${arr[@]}" 
}

check_multiple_files_exists(){
    local check_path=$1
    local -a arr=("$@")
    
    cd $check_path
	for i in "${arr[@]}" 
	do 
        if [ "$i" != "$check_path" ]; then # the first one is just the check_path.
	      [ -f "$i" ] || (echo "failed, $i not found"; exit 1) ;
        fi
    done 
}
