# Hipparchus

Cache responces from Google Maps API.

Hipparchus queries Google Maps API for your geocoding requests and caches the results in a local Redis database. Speed up your projects and don't overuse Google Maps API service. Written in Crystal.

## Installation

### Fedora/CentOS/EPEL packages

This project comes with the official repositories for Fedora 23+/EPEL 6+. RPM packages come with a convenient systemd service file and properly stated system dependencies (e.g. Redis). This is the recommended way how to run Hipparchus in production.

Follow the installation instructions on the [Copr project page](https://copr.fedorainfracloud.org/coprs/jstribny/hipparchus/).

### Building the binary yourself

You can always build the binary yourself as any other Crystal project:

```
$ shards
$ crystal build --release src/hipparchus.cr
```

Afterwards you can just start Hipparchus server as:

```
$ ./hipparchus -b HOST -p PORT -e production
```

Please note that Hipparchus depends on Redis and needs a running Redis server listening on `127.0.0.1:6379`.

## Usage

### Running the server

To start the Hipparchus server:

```
$ sudo systemctl enable hipparchus
$ sudo systemctl start hipparchus
```

The server will by default listen on `127.0.0.1:3999`.

Alternatively run the binary directly:

```
$ ./hipparchus -b 127.0.0.1 -p 3999 -e production
```

### Quering the API

The get the latitude and longitude of a given `ADDRESS`, query `HOST:PORT/ADDRESS`.

Hipparchus returns succesfull response as a following JSON:

```
{ "location": { "lat": 49.9407, "lng": 17.8948 } }
```
or:
```
{ "error": "Some error message" }
```

See the `examples/` folder to see client usecases.

## Development

*Note: This requires you to have working installation of Crystal and its Shards dependency manager.*

To install project dependencies run:

```
$ shards
```

To run the tests:

```
$ crystal spec ./spec/**
```

## License

Copyright (c) 2016 Josef Strzibny. See LICENSE file.
