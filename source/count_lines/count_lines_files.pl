#!/usr/bin/perl

sub trim {
    my $s = shift;
    $s =~ s/^\s+|\s+$//g;
    return $s;
}


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
    my @array = ($blank, $index, $blank+$index);
    return @array;

}

my $total_blank = 0;
my $total_index = 0;
my $total_lines = 0;

while (my $f = shift @ARGV) {
    my @rt = &count_file($f);
    $total_blank += $rt[0];
    $total_index += $rt[1];
    $total_lines += $rt[2];
}

print "total lines: " .  ($total_index+$total_blank) . " total blanks: " . $total_blank . " lines: " . $total_index . "\n";
