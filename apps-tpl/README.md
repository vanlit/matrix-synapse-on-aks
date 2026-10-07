# CAUTION
Never edit .yaml, only edit yaml.tpl, unless there is no yaml.pl, then just edit the yaml.
The pre-commit hook under /flow/ must be enabled so
.tpl files will be converted on-commit to .yaml files, embedding the values from /cfg.sh


# apps-tpl

This directory is the source of truth for the Argo CD application manifests.

Do not edit generated files under `apps/` directly.

Workflow:

  apps-tpl/*.yaml.tpl
          |
          | pre-commit hook
          v
  apps/*.yaml
          |
          v
       Argo CD

The .tpl files contain environment-specific placeholders such as:

  ${TF_VAR_argocd_namespace}
  ${POSTGRES_NAMESPACE}
  ${REDIS_NAMESPACE}
  ${TF_VAR_TOP_DOMAIN}
  ${ESO_KRESNAME}

The pre-commit hook under /flow/ renders the templates using values from
/cfg.sh.

If a resource exists only as a generated .yaml and has no corresponding
.tpl file, create the .tpl as the source of truth before making further
changes.

Do not manually modify generated .yaml files unless there is no .tpl
source for that resource.

## Directory organization

00-argocd
  Argo CD bootstrap and Argo CD configuration.

01-groups
  Top-level Argo CD Applications grouping the platform.

02-platform
  Cluster-wide operators/controllers required by other workloads.

03-config
  Cluster-wide configuration and policies.

10-observability
  Monitoring, metrics, logging and visualization.

20-auth
  Authentication services.

30-data
  PostgreSQL, Redis and backup infrastructure.

40-matrix
  Matrix/Synapse application workloads.

50-network
  Traefik and ingress/network configuration.

## Sync ordering

The numeric directory structure is primarily organizational, but the group
Applications also use Argo CD sync waves to express dependency ordering.

Current intended order:

  -20  platform
  -10  config
    0  observability
    0  auth
   10  data
   20  matrix
   30  network

Within individual applications, resource-level sync waves may be used when
one resource must exist before another.

Do not use directory names alone as a dependency mechanism.
