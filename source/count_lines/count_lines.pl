#!/usr/bin/perl
sub trim {
    my $s = shift;
    $s =~ s/^\s+|\s+$//g;
    return $s;
}
sub count_lines {
    my $index = 1;
    my $blank_lines = 0;
    while(<>) {
        if(length(trim($_)) == 0) {
            $blank_lines ++;
        }
        else {
            $index++;
        }
    }
   print "Number of lines: ";
   print $blank_lines + $index . " blanks: " . $blank_lines . " non blank: " . $index . "\n";
}
&count_lines();
