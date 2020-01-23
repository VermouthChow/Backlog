#!/bin/bash

bundle exec puma -C config/puma.rb
echo "* Port is 3000"
