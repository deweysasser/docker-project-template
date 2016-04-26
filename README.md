Docker Project Template
=======================

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

### docker-compose.override.yml

You can create a 'docker-compose.override.yml' that adapts it properly
to your development environment.  

DO NOT CHECK IN THIS FILE.  

If you want to adapt it to your demo and/or production environemnts,
create a file something like docker-compose.<ENV>.yml and use 'make
run-<ENV>'


Customization
-------------

Modify 'docker-compose.yml' to launch your project correctly. 

Use environment specific overrides to run in different environments.