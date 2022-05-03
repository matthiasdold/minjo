#!/usr/bin/env bash

curdir=$PWD
cd ~/Documents/journal/
./combine_journals.sh
cd curdir
nvim ~/Documents/journal/0_combined_journal.md
