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

# Debugging

If something goes wrong (e.g. you have edited one of the .yaml files poorly) and 'make test' hangs, you can try fetching directly from each of the listeners in the system as follows.
In order from upstream to downstream:
```
$ docker exec envoy-front-proxy-sigsci_service2_1 curl http://localhost:8080/service/1
$ docker exec envoy-front-proxy-sigsci_service2_1 curl http://localhost:80/service/1
$ docker exec envoy-front-proxy-sigsci_front-envoy_1 curl http://localhost:80/service/1
$ curl http://localhost:8000/service/1
```

Here's what "make start" does, again from upstream to downstream:

Dockerfile-service is run twice; each instance runs start_service.sh,
- service.py, which serves a message on its localhost:8080/service/1 and localhost:8080/service/2
- envoy with service-envoy.yaml, which listens on port 80 and forwards requests to the above service on port 8080.

Dockerfile-frontenvoy runs envoy with front-envoy.yaml, which:
- has an ingress listener on its port 80, and routes /service/1 and /service/2 to port 80 of the two instances of service.

docker-compose.yml listens on your workstation's port 8000 and forwards that to the ingress listener's port 80.

If you want to use wasm filters, and envoy's wasmtime runtime instead of its stock wavm runtime,
you will need to build envoy yourself, e.g.
```
git clone https://github.com/envoyproxy/envoy ../envoy
cd ../envoy
./ci/run_envoy_docker.sh 'BAZEL_BUILD_EXTRA_OPTIONS="--define=wasm=wasmtime" ci/do_ci.sh bazel.dev //test/... --test_env=ENVOY_IP_TEST_VERSIONS=v4only'
cd -
cp ../envoy/src/envoy/linux/amd64/build_fastbuild/envoy envoy-wasmtime
```
and then uncomment the references to wasmtime in Dockerfile-frontproxy and front-envoy-v3.yaml before running ```make clean && make build```.
