#!/usr/bin/perl -w


# execute ac-tool

my $input = $ARGV[0];
my $output = "output.png";
my $filter = "MirrorDiamond";
my $level = "4";

my $call_system = "ac-tool --input=\"$input\" --output=\"$output\" --filter=\"$filter\" --level=$level";

my $status = system($call_system);

print $call_system . "\n";
print "status of system call: " . $status . "\n";


