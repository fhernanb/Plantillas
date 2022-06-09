#!/bin/bash
# wrapper script for project Flow123d in docker environment
# usage is same as flow123d usage (from user's perspestive)

# default directory where solve yaml file will be mounted
CONT_SOLVE=/mount/solve/
# default input dir (-i argument of flow123d)
CONT_INPUT=/mount/input
# default input dir (-i argument of flow123d)
CONT_OUTPUT=/mount/output
# location of flow123d binary in image
CONT_BINARY=echo


# build up command for invoking container containing flow123d
# main purpose is to correctly mount dirs with resource files
# e.g. solve, input and output dirs
CMD=""
# ARG variable builds up command passed to flow123d binary
ARG=""
# additional arguments passed to flow123d
REST=""
# variable debug will only prints key variables but do not execute main command
DEBUG=0


# set up default comamnd prefix
CMD="docker run -ti --rm --privileged"

function usage {
    echo "Allowed options:"
    echo "  --help                            produce help message"
    echo "  -s [ --solve ] arg                Main input file to solve."
    echo "  -i [ --input_dir ] arg (=input)   Directory for the \${INPUT} placeholder in"
    echo "                                    the main input file."
    echo "  -o [ --output_dir ] arg (=output) Directory for all produced output files."
    echo "  --version                         Display version and build information and"
    echo "                                    exit."
    echo "  --no_log                          Turn off logging."
    echo "  --no_profiler                     Turn off profiler output."
    # echo "  --JSON_machine arg                Writes full structure of the main input"
    # echo "                                    file as a valid CON file into given file"
    # echo "  --petsc_redirect arg              Redirect all PETSc stdout and stderr to"
    # echo "                                    given file."
    echo "  --yaml_balance                    Redirect balance output to YAML format too"
    echo "                                    (simultaneously with the selected balance"
    echo "                                    output format)."
}

function parse_solve {
    SOLVE_DIR=$SOLVE
    SOLVE_NAME="$(basename $SOLVE)"
    SOLVE_DIR="$(readlink -f $SOLVE_DIR)"
    SOLVE_DIR="$(dirname $SOLVE_DIR)" 
    CMD="$CMD -v $SOLVE_DIR:$CONT_SOLVE"
    ARG="$ARG -s $CONT_SOLVE$SOLVE_NAME"
}

function parse_input {
    # if input dir was set process it
    if [[ $INPUT != "" ]]; then
        INPUT_DIR=$INPUT
        INPUT_DIR="$(readlink -f $INPUT_DIR)"
        CMD="$CMD -v $INPUT_DIR:$CONT_INPUT"
        ARG="$ARG -i $CONT_INPUT"
    fi
}

function parse_output {
    # if output dir was set process it
    if [[ $OUTPUT != "" ]]; then
        OUTPUT_DIR=$OUTPUT
        OUTPUT_DIR="$(readlink -f $OUTPUT_DIR)"
        CMD="$CMD -v $OUTPUT_DIR:$CONT_OUTPUT"
        ARG="$ARG -o $CONT_OUTPUT"
    fi
}

while [[ $# -gt 0 ]] ; do
    key="$1"
    case $key in
        -s|--solve)
            SOLVE="$2"
            # parse_solve
            shift
        ;;
        -i|--input|--input_dir)
            INPUT="$2"
            # parse_input
            shift
        ;;
        -o|--output|--output_dir)
            OUTPUT="$2"
            # parse_output
            shift
        ;;
        
        
        --version) ARG="$ARG --version";;
        --no_log) ARG="$ARG --no_log";;
        --no_profiler) ARG="$ARG --no_profiler";;
        --yaml_balance) ARG="$ARG --yaml_balance";;
        
        -d|--debug)
            DEBUG=1
        ;;
        --help)
            usage
            exit 0
        ;;
        --)
            shift
            REST="$REST $@"
            break
        ;;
        *)
            echo "Invalid argument $key"
            exit 1
        ;;
    esac
    shift
done

# append image name
CMD="$CMD ubuntu"
# append arguments and additional arguments
CMD="$CMD $CONT_BINARY $ARG $REST"

# execute command
if [[ DEBUG -eq 1 ]]; then
    echo "SOLVE  = $SOLVE"
    echo "INPUT  = $INPUT"
    echo "OUTPUT = $OUTPUT"
    echo "ARG    = $ARG"
    echo "REST   = $REST"
    echo "CMD    = $CMD"
else
    $CMD
fi
