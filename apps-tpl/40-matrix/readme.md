This directory contains the Matrix application layer.

Target architecture:

  Element Web
  Synapse Main
  Client Reader
  Federation Reader
  Background Worker
  Media Worker
  Backup Worker

The Matrix application workloads are not yet implemented in the source
repository.

Data dependencies:

  PostgreSQL:
    database: synapse
    owner: matrix

  Redis:
    redis-auth

Future Matrix configuration will also consume:

  - TURN shared secret
  - media storage configuration
  - Redis credentials
  - PostgreSQL credentials
  - authentication / OIDC configuration
