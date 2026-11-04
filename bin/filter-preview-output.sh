#!/bin/bash

# Reduce the 'preview' output for use as a pull request comment.
# source: https://git.io/J86QD
sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g" |\
  grep -v -e '^\.\.\.0 corrections$' |\
  grep -v -e '^0 corrections' |\
  grep -v -e '^----- DNS Provider: ' |\
  grep -v -e '^----- Registrar: ' |\
  grep -v -e '^----- Getting nameservers from:'
