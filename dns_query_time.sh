#!/bin/bash

# Check if both input arguments are provided
if [ $# -lt 2 ]; then
    echo "Please provide two arguments: <iterations> <IP>"
    exit 1
fi

# Check if the first input argument is a valid integer
re='^[0-9]+$'
if ! [[ $1 =~ $re ]]; then
    echo "Invalid input for iterations. Please provide a valid integer."
    exit 1
fi

# Parse the input arguments
iterations=$1
ip=$2
total_query_time=0

# Run the command X times and calculate the total query time
for ((i=1; i<=$iterations; i++))
do
    output=$( { time dig @"$ip" 2>&1; } 2>&1 )
    query_time=$(echo "$output" | grep -oE 'Query time: [0-9]+' | awk '{print $3}')
    
    if [ -n "$query_time" ]; then
        total_query_time=$((total_query_time + query_time))
    fi
done

# Calculate the average query time
average_query_time=$((total_query_time / iterations))

echo "Average query time over $iterations executions: $average_query_time ms"

