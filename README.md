To learn about this sandbox and for instructions on how to run it please head over
to the [envoy docs](https://www.envoyproxy.io/docs/envoy/latest/start/sandboxes/front_proxy.html)
# envoy-front-proxy-sigsci

You must edit agent.conf and add your own SigSci accesskeyid and secretaccesskey values.

The contained Makefile contains some common tasks.

You can choose which versions of sigsci agent and envoy are used
by editing Makefile to uncomment the desired versions.

## Build containers with no cache option for the SigSci agent containers
make build

## Run docker-compose to start the containers and scale SigSci agent cluster containers
make start

## Stop the containers
make stop

## Display all container stdout logs
make log

## Run smoke test
make test

## Clean up thoroughly
make clean
