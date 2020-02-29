This is a docker image for building Elixir projects. It is NOT designed for final deployed environment. If you are looking for a docker image for deployment, please try [docker-elixir-runner](https://github.com/qhwa/docker-elixir-runner) project instead.

This docker image contains following softwares:

* Elixir
* Erlang and OTP
* Nodejs
* docker
* kubectl
* hex
* rebar

They are used for CI/CD processes.

## Usage

```sh
docker pull qhwa/elixir-builder:latest
docker pull qhwa/elixir-builder:1.10
docker pull qhwa/elixir-builder:1.9
```

## License

This project is open source under MIT license.
