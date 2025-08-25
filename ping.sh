#!/bin/bash

# Path to your binary
BINARY="/home/x71c9/scripts/relay/target/release/internet-relais-schalter"
ARG="300"

# Counter for failed pings
fail_count=0

# Number of minutes to wait before triggering the binary
MAX_FAILS=5

RESUME_TIME=3600

while true; do
    if ping -c 1 -W 1 8.8.8.8 > /dev/null 2>&1; then
        # Reset counter if ping is successful
        fail_count=0
        echo "$(date): Ping successful"
    else
        # Increase counter if ping fails
        fail_count=$((fail_count + 1))
        echo "$(date): Ping failed ($fail_count/$MAX_FAILS)"
    fi

    # If fails for MAX_FAILS minutes, run binary
    if [ "$fail_count" -ge "$MAX_FAILS" ]; then
        echo "$(date): No internet for $MAX_FAILS minutes. Running binary..."
        $BINARY $ARG   # <-- this will block until it finishes
        echo "$(date): Binary finished"
        fail_count=0  # reset after running
        echo "Wait $RESUME_TIME seconds..."
        sleep $RESUME_TIME
    fi

    # Wait 1 minute before next check
    sleep 60
done

