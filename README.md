# Article Tyk

## Prerequisites

- Docker >= 1.9
- Docker Compose >= 1.5

## Installation

Add to the hosts file:

```
127.0.0.1   bouchon.local # :9090
127.0.0.1   open.local # :9092

127.0.0.1   api.local # 8080
127.0.0.1   tyk_dashboard.tyk_dashboard.docker # 3000
```

## Execution

### Story 1

From the project root, launch:

```
./bin/start.sh
```

Add a basic auth key with these paramters:

user: user
pass: user123
