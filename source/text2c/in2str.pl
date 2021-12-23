#!/usr/bin/perl


sub fix_string {
    my $input = $_[0];
    my @bytes = split("", $input);
    my $output = "";
    for(my $i = 0; $i < scalar @bytes; $i++) {
        if ($bytes[$i] eq "\\") {
            $output .= "\\\\";
        }
        elsif($bytes[$i] eq "\"") {
            $output .= "\\";
            $output .= "\"";
        }
        else {
            $output .= $bytes[$i];
        }
    }
    $output;
}

sub convertStream {
    print "const char *data[] = {";
    while(<>) {
        chomp;
        print "\"" . fix_string($_) . "\",\n";
    }
    print " 0};\n";
}

convertStream();


