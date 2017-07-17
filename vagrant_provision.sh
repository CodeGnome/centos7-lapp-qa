#!/usr/bin/env bash

vagrant up --provider virtualbox --provision
vagrant ssh -- -O exit
