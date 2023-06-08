#!/bin/bash
set -e
shopt -s extglob

#  parse environment variable to gitinspector command param name and value
# environment variable extract param name
# 1. Remove prefix GITINSPECTOR_CONFIG_
# 2. Replace name an underscore (_) with dash (-).
# 3. Lower case
# 
function function_param_parse() {
    
    gitinspector_param_name=$1
    gitinspector_param_value=$2

    # remove prefix
    gitinspector_param_name=${gitinspector_param_name//GITINSPECTOR_CONFIG_/}

    if [[ "${gitinspector_param_name:0:1}" = "_" ]]; then
        # not param
        gitinspector_param_name=""
        gitinspector_param_value=""
    else
        # replace
        gitinspector_param_name="${gitinspector_param_name//_/-}"
        # upper case
        gitinspector_param_name="$( echo "$gitinspector_param_name" | tr '[:upper:]' '[:lower:]' )"
    fi

    _result_param_name="$gitinspector_param_name"
    _result_param_value="$gitinspector_param_value"
}


#  generation gitinspector command positional parameters 
# 1. Empty value not need append to result
function function_param_generation() {
    
    gitinspector_param_name=$1
    gitinspector_param_value=$2

    empty_value="false"
    # check value is empty
    [[ "${gitinspector_param_value/ /}" = "" ]] && empty_value="true"
    [[ "${gitinspector_param_value/:/}" = "" ]] && empty_value="true"

    # start dash (--) with name
    if [[ -z "$gitinspector_param_name" ]]; then
        command_param=""
    else
        command_param="--$gitinspector_param_name"
    fi

    # add quotation marks if spaces in param
    if [[ "${gitinspector_param_value/ /}" != "$gitinspector_param_value" ]]; then
        gitinspector_param_value="'$gitinspector_param_value'"
    fi

    # append value if need
    if [[ "$empty_value" != "true" ]]; then
        command_param="$command_param=$gitinspector_param_value"
    fi

    _result_param="$command_param"
}



#####init_variable

_engine_dir="/gitinspector/"
_command_name="gitinspector.py"
GITINSPECTOR_PATH_GIT=${GITINSPECTOR_PATH_GIT}
GITINSPECTOR_PATH_OUTPUT=${GITINSPECTOR_PATH_OUTPUT}
GITINSPECTOR_FILTER=${GITINSPECTOR_FILTER}

if [[ -n "$GITINSPECTOR_CONFIG_FORMAT" ]]; then
    _report_ext="$GITINSPECTOR_CONFIG_FORMAT"
else
    _report_ext="txt"
fi

if [[ -n "$GITINSPECTOR_FILTER" ]]; then
    GITINSPECTOR_FILTER="-x ${GITINSPECTOR_FILTER}"
fi

if [[ -z "$GITINSPECTOR_PATH_GIT" ]] && [[ -d "/git-projects/default" ]]; then
    GITINSPECTOR_PATH_GIT="/git-projects/default"
fi
if [[ -z "$GITINSPECTOR_PATH_OUTPUT" ]] && [[ -d "/output-reports/default" ]]; then
    GITINSPECTOR_PATH_OUTPUT="/output-reports/default/gitinspector.${_report_ext}"
fi

#####begin

# create command
_command_opt=
read -r -a _env_array <<< "$( echo "${!GITINSPECTOR_CONFIG_*}" )"
for _env in "${_env_array[@]}"; do
    function_param_parse "$_env" "${!_env}"
    function_param_generation "$_result_param_name" "$_result_param_value"

    if [[ -z "$_command_opt" ]]; then
        _command_opt="$_result_param"
    else
        _command_opt="$_command_opt $_result_param"
    fi
done
_command="$_engine_dir$_command_name $_command_opt ${GITINSPECTOR_FILTER} ${GITINSPECTOR_PATH_GIT} $@" 

# print and run command
if [[ -z "$GITINSPECTOR_PATH_OUTPUT" ]]; then
    echo "$_command"
    $_command
else
    echo "$_command > ${GITINSPECTOR_PATH_OUTPUT}"
    $_command > ${GITINSPECTOR_PATH_OUTPUT}
fi
code=$?

# done command
echo
if [[ $code -eq 0 ]]; then
    echo "Ok, run done"
else
    echo "Sorry, some error '$code' make failure"
fi
