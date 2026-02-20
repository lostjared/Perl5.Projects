#!/usr/bin/env perl
use strict;
use warnings;
use Time::HiRes qw(usleep);
use List::Util qw(shuffle);

sub echo_line_vector {
    my ($lines, $milli) = @_;
    for my $line (@$lines) {
        for my $ch (split //, $line) {
            print $ch;
            STDOUT->flush();
            usleep($milli * 1000);
        }
        print " ";
        STDOUT->flush();
    }
}

if (@ARGV != 3) {
    print STDERR "Error incorrect arguments.\n";
    print STDERR "Use: input_tex_file.txt delay mode\n";
    exit 1;
}

my $filename = $ARGV[0];
my $milli    = int($ARGV[1]);
my $mode     = int($ARGV[2]);

if ($mode != 1 && $mode != 2) {
    print "Error missing mode (0 or 1)\n";
    exit 1;
}

if ($milli == 0) {
    print STDERR "Invalid delay\n";
    exit 1;
}

open(my $fh, '<', $filename) or do {
    print STDERR "Error open file: $filename\n";
    exit 1;
};

my @lines;
while (my $line = <$fh>) {
    chomp $line;
    if ($mode == 1) {
        push @lines, $line;
    } elsif ($mode == 2) {
        my @tokens = split /\s+/, $line;
        push @lines, @tokens;
    }
}
close($fh);

# repeat until break with Ctrl+C
while (1) {
    echo_line_vector(\@lines, $milli);
    if ($mode == 2) {
        @lines = shuffle(@lines);
    }
}
