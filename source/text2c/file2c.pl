#!/usr/bin/perl

sub convertStream {
    my $input = $_[0];
    print "unsigned char bytes[] = {\n";
    while (!eof($input)) {
        read($input, $buffer, 256);
        my @bytes = split("", $buffer);
        for(my $i = 0; $i < scalar @bytes; $i++) {
            printf("0x%x,", ord($bytes[$i]));
        }
    }
    print "0x0};\n";
}

while(my $value = shift @ARGV) {
    open(INPUT, "<", $value) || die("Could not open file: " . $value . "\n");
    print "\n\n/* array for $value */\n\n";
    convertStream(INPUT);
    print "\n\n/* end array for $value */\n";
}

