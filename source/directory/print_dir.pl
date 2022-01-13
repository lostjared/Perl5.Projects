#!/usr/bin/perl -w

my $input = shift @ARGV;
opendir $dir, $input || die("could not open directory");
my @files = readdir $dir;
closedir $dir;

foreach my $fi (@files) {
    print $fi . "\n" if -f $fi;
}


