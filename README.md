Docker Project Template
=======================

The Short Version
-----------------

A base project for building docker images.


Quick Start
-----------

    git clone https://github.com/deweysasser/docker-project-template
    git remote rm origin
    # hack on source/Dockerfile
    make build test run-demo

Overview
--------

This project coordinates with the [build pipeline
template](git@github.com:deweysasser/docker-pipeline-template.git).

While the template is heavily docker biased but the pattern should
work with any system.

Defines the standard set of make targets for you to fill in later and
(if possible) provides reasonable defaults.

This project inherits (via git) the
[base-repo](https://github.com/deweysasser/base-repo) project.


Usage
-----

If you have a normal docker project, starting putting the interesting
code under 'source'.  The project and corresponding build pipeline
will "just work".

If you need to build with docker-compose instead of docker, use the
"build-compose" target (or the "build-<config>" target, where <config>
is a particular configuration).

### docker-compose.override.yml

You can create a 'docker-compose.override.template' that adapts it
properly to your development environment.  The Makefile when then
generate a 'docker-compose.override.yml' file from the template.

If you want to adapt it to your demo and/or production environemnts,
create a file something like docker-compose.<ENV>.yml and use 'make
build-<ENV> run-<ENV>'

System Testing
--------------

In order to system test your dockerfile, you should create a
docker-compose.systemtest.template -- it can be empty if nothing else
is required.


Customization
-------------

Modify 'docker-compose.yml' to launch your project correctly. 

Add make rules, recipes and dependencies to 'recipes.mk' to add extra
build steps or dependencies.  Modify Makefile as a last resort (and
let me know what you had to modify so I can look into supporting that
customization).

Use environment specific overrides to run in different environments.