#!/bin/bash
set -xe
CC="gcc"
FLAGS="-Wextra -Wall"

$CC main.c $FLAGS -o main.out
