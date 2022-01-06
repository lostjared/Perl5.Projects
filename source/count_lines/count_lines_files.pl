#!/usr/bin/perl

sub trim {
    my $s = shift;
    $s =~ s/^\s+|\s+$//g;
    return $s;
}

my $total_blank = 0;
my $total_index = 0;

sub count_file {
    my $input = $_[0];
    open (INPUT, "<", $input) || die(" could not open file $input - $!");
    my $blank = 0;
    my $index = 0;
    while(<INPUT>) {
        if(length(trim($_)) == 0) {
            $blank ++;
        } else {
            $index ++;
        }
    }
    close (INPUT);
    print "File: " . $input . " blanks: " . $blank . " lines: " . $index . " total lines: " . ($blank+$index) . "\n";
    $total_blank += $blank;
    $total_index += $index;
}

while (my $f = shift @ARGV) {
    &count_file($f);
}

print "total lines: " .  ($total_index+$total_blank) . "\n";
