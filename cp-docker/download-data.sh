#!/bin/bash

wget https://github.com/schocco/kafka-streams-demo/releases/download/v0/us-etfs.csv.tar.gz
wget https://github.com/schocco/kafka-streams-demo/releases/download/v0/us-stocks.csv.tar.gz

tar xvzf us-etfs.csv.tar.gz
tar xvzf us-stocks.csv.tar.gz