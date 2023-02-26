#!/bin/sh
# Tested on ubuntu 18.04
# Generating random number between $FPORT and $EPORT for port binding
FPORT=1025;
EPORT=9999;
RANDHTTP=$(( ( RANDOM % $FPORT )  + $EPORT ))
RANDSSL=$(( ( RANDOM % $FPORT )  + $EPORT ))
RANDDASH=$(( ( RANDOM % $FPORT )  + $EPORT ))
RANDDSTB=$(( ( RANDOM % $FPORT )  + $EPORT ))
RANDDAPI=$(( ( RANDOM % $FPORT )  + $EPORT ))
# Name of the Docker container provided in ARG $1
NAME=$1

check_port_availability () {

	HTTP_PORT_CHECK=$1
	SSL_PORT_CHECK=$2
	DASH_PORT_CHECK=$3
        STB_PORT_CHECK=$4

	if [ $HTTP_PORT_CHECK -eq $SSL_PORT_CHECK ] || [ $HTTP_PORT_CHECK -eq $DASH_PORT_CHECK ] || [ $SSL_PORT_CHECK -eq $DASH_PORT_CHECK ]; then
                printf "\n\nRandom Port Collision...Randomizing HTTP Port!\n\n"
                RANDHTTP=$(( ( RANDOM % $FPORT )  + $EPORT )) # Randomizing port
                exit
        fi

	if [ $SSL_PORT_CHECK -eq $DASH_PORT_CHECK ]; then
                printf "\n\nRandom Port Collision...Randomizing HTTP Port!\n\n"
                RANDSSL=$(( ( RANDOM % $FPORT )  + $EPORT )) # Randomizing port
                exit
        fi

	#for USED_PORT in $( netstat -ltn | sed -rne '/^tcp/{/:\>/d;s/.*:([0-9]+)\>.*/\1/p}' | sort -n | uniq ); do
        for USED_PORT in $( netstat -ltn | grep -E 'tcp|udp' | awk -F\  '{print $4}' | awk -F. '{print $5}'| sort -n | uniq ); do
                if [ $HTTP_PORT_CHECK -eq $USED_PORT ]; then
                        printf "\n\n$HTTP_PORT_CHECK conflicts with open port: $USED_PORT...Randomizing HTTP Port!\n\n"
                        RANDHTTP=$(( ( RANDOM % $FPORT )  + $EPORT ))
                        exit
                elif [ $SSL_PORT_CHECK -eq $USED_PORT ]; then
                        printf "\n\n$SSL_PORT_CHECK conflicts with open port: $USED_PORT...Randomizing HTTPS Port!\n\n"
                        RANDSSL=$(( ( RANDOM % $FPORT )  + $EPORT )) # Randomizing port
                	exit
                elif [ $DASH_PORT_CHECK -eq $USED_PORT ]; then
                        printf "\n\n$DASH_PORT_CHECK conflicts with open port: $USED_PORT...Randomizing Dashboard/API Port!\n\n"
                        RANDDASH=$(( ( RANDOM % $FPORT )  + $EPORT )) # Randomizing port
                        exit
                fi
        done

        return
}

port_sanity=$(check_port_availability $RANDHTTP $RANDSSL $RANDDASH $RANDDSTB $RANDDAPI)

# Port check and randomize
# Loop until all ports are random
if [ -z "$port_sanity" ]; then
        printf "\nWe will run the container with these randomly assigned ports:\nHTTP port $RANDHTTP\nHTTPS port $RANDSSL\nHealthy port $RANDDASH\nBasic status port $RANDDSTB\nAPI status port $RANDDAPI\n\n"
else
	port_sanity=$(check_port_availability $RANDHTTP $RANDSSL $RANDDASH $RANDDSTB $RANDDAPI)
fi

# Run container
# Make sure this Container is not running
printf "Make sure a Container with the designated name is not running..."
OUTPUT="$(docker stop $NAME)"
if echo "$OUTPUT" | grep -c "No such container"; then
        echo "A container with name, $NAME, was stopped. Good to proceed.."
else
	echo "No container with name, $NAME, exists. Good to proceed.."

fi

#printf "\nGoing to run:\ndocker run -d -p $RANDHTTP:80 -p $RANDSSL:443 -p $RANDDASH:90 -v '$(pwd)/test/etc/nginx/conf.d:/etc/nginx/conf.d' --name $NAME $NAME\n\n"
#printf "\nGoing to run:\ndocker run -d -p $RANDHTTP:80 -p $RANDSSL:443 -p $RANDDASH:90 -p $RANDDSTB:91 -p $RANDDAPI:92 --name $NAME $NAME\n\n"
printf "\nGoing to run:\ndocker run -d -p $RANDHTTP:80 -p $RANDSSL:443 -p $RANDDASH:90 -p $RANDDSTB:91  --name $NAME $NAME\n\n"

#docker run -d -p $RANDHTTP:80 -p $RANDSSL:443 -p $RANDDASH:8080 -v "$(pwd)/etc/nginx/conf.d:/etc/nginx/conf.d" --name $NAME $NAME
docker run -d -p $RANDHTTP:80 -p $RANDSSL:443 -p $RANDDASH:90  -p $RANDDSTB:91 --name $NAME $NAME
#docker run -d -p $RANDHTTP:80 -p $RANDSSL:443 -p $RANDDASH:90  -p $RANDDSTB:91 -p $RANDDAPI:92 --name $NAME $NAME

printf "\nGoing to run:\ndocker exec $NAME nginx -t\n\n"
docker exec $NAME nginx -t
printf "\nGoing to run:\ndocker exec $NAME curl -v -s http://0.0.0.0:90/nginx-health\n\n"
docker exec $NAME curl -v -s http://0.0.0.0:90/nginx-health
printf "\nGoing to run:\ndocker exec $NAME curl -v -s http://0.0.0.0:91/nginx-status\n\n"
docker exec $NAME curl -v -s http://0.0.0.0:91/nginx-status
exit
