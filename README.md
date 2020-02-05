# README

## introduce

This is a simple tasks flow systems, you can register account, mark your tasks and tracking process.

## info

* Ruby version: 2.6.4

* Rails version: 5.1.7

* Database: postgresql 10.10

* Development environment: Ubuntu 18.04.1

## start

* Clone from github

* Make sure postgresql is installed

* Update config/database.yml according to your database configure

* Run the database

* Bundle install

* Run Backlog by '''./start.sh/''' (need permission) OR '''bundle exec puma -C config/puma.rb'''

Then you can access it on localhost:3000 

## test

unit test is minitest, use '''rails test''' to run all
