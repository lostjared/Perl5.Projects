package TestMod;
use strict;
use warnings;
use Exporter;

our @ISA = qw(Exporter);

our @EXPORT_OK= qw(test_sub);
our @EXPORT = qw(test_sub);

sub test_sub {
    print "Hello from Module..\n";
}

1;
