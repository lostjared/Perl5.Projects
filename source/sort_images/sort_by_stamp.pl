#!/usr/bin/perl

# will sort images outputed by acidcamGL
# print out a list to stdout to use with img2mov
# use
# ./sort_by_stamp.pl directory
# or
# ./sort_by_stamp.pl directory


my $dir = shift @ARGV;

opendir $d, $dir or die("Could not open directory");
my @f = readdir $d;
closedir $d;
my %list = ();
foreach my $fi (@f) {
    if ($fi =~ m/(\d+).(\d+).(\d+)_(\d+).(\d+).(\d+)/) {
        
        $s = $2 . "-" . $3 . "-" . $1 . " " . $4 . ":" . $5 . ":" . $6;
        $list{$s} = $fi;
    }
}


foreach my $i (sort keys %list) {
    print $list{$i} . "\n";
    #print $i . "\n";
}
