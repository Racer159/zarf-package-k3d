# zarf-package-k3d

A simple Zarf package to install `k3d`, load its required images, and start a cluster in an air gap.

## Using

To use this package, import the 4 components in the root `zarf.yaml` into your [Custom `init` Package](https://docs.zarf.dev/docs/zarf-tutorials/custom-init-packages).

Then add `k3s_version = '<desired-version>'` to your `zarf-config.toml` under `[package.create.set]`.  You can see the version this repo uses in the `Makefile`. 

> ⚠️ **NOTE:** You can optionally slim down your `init` package size by only including the `k3d` binaries you expect to use for your target OS.

```yaml
kind: ZarfInitConfig
metadata:
  name: init
  description: Used to establish a new Zarf cluster

components:
  - name: k3d-images
    import:
      path: ../zarf-package-k3d

  - name: k3d-linux
    import:
      path: ../zarf-package-k3d

  - name: k3d-darwin
    import:
      path: ../zarf-package-k3d

  - name: k3d-windows
    import:
      path: ../zarf-package-k3d

  # This package moves the injector & registries binaries
  - name: zarf-injector
    required: true
    import:
      path: packages/zarf-registry

  # Creates the temporary seed-registry
  - name: zarf-seed-registry
    required: true
    import:
      path: packages/zarf-registry

  # Creates the permanent registry
  - name: zarf-registry
    required: true
    import:
      path: packages/zarf-registry

  # Creates the pod+git mutating webhook
  - name: zarf-agent
    required: true
    import:
      path: packages/zarf-agent

  # (Optional) Adds logging to the cluster
  - name: logging
    import:
      path: packages/logging-pgl

  # (Optional) Adds a git server to the cluster
  - name: git-server
    import:
      path: packages/gitea
```

## Development

### Create only this package

```
make build
```

### Build the Docker image

```
make build-image
```

### Release the Docker image

```
make release-image
```
