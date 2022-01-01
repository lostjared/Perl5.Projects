#!/usr/bin/perl -w

use slex;

if(scalar(@ARGV) == 0) {
    slex::proc_stdout();
    exit(0);
}

while (my $input = shift @ARGV) {
    slex::proc_file($input);
}
