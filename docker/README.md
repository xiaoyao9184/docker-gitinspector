# use

Run directly to print the `gitinspector` command help.

```bash
docker run \
    -it \
    --rm \
    xiaoyao9184/docker-gitinspector:latest --help
```


Map the git source code directory and report output directory 
to the default path of the container without setting any parameters.

```bash
docker run \
    -it \
    -v ./:/git-projects/default \
    -v ./outputpath:/output-reports/default \
    xiaoyao9184/docker-gitinspector:latest
```


Pass parameters `GIT REPOSITORY` to the `gitinspector` command.

```bash
docker run \
    -it \
    -v ./:/git-projects/project1 \
    xiaoyao9184/docker-gitinspector:latest \
    /git-projects/project1
```


In addition to using the command line to set parameters,
you can also use environment variables to set parameters. 
By capitalizing all of them and adding the prefix `GITINSPECTOR_CONFIG_`, 
you can set the option of command `gitinspector`.

```bash
docker run \
    -it \
    -v ./:/git-projects/project1 \
    -v ./outputpath:/output-reports/project1 \
    -e GITINSPECTOR_PATH_GIT=/git-projects/project1 \
    -e GITINSPECTOR_PATH_OUTPUT=/output-reports/project1/project1.html \
    -e GITINSPECTOR_CONFIG_FORMAT=html \
    -e GITINSPECTOR_CONFIG_TIMELINE=true \
    -e GITINSPECTOR_CONFIG_LOCALIZE_OUTPUT=true \
    -e GITINSPECTOR_CONFIG_WEEKS=true \
    xiaoyao9184/docker-gitinspector:latest
```

Setting this environment variable is equal to setting command line parameter `GIT REPOSITORY`.

- GITINSPECTOR_PATH_GIT

Setting this environment variable is equal to setting command line parameter `Filtering`.

- GITINSPECTOR_FILTER
