#!/usr/bin/perl -w

print "input perl code> ";
my $var1;
chomp($var = <STDIN>);
eval($var);
print "\n";
