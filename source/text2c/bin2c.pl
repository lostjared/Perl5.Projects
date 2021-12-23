#!/usr/bin/perl

sub convertStream {
    print "unsigned char bytes[] = {\n";
    while (!eof(STDIN)) {
        read(STDIN, $buffer, 256);
        @bytes = split("", $buffer);
        for($i = 0; $i < scalar @bytes; $i++) {
            printf("0x%x, ", ord($bytes[$i]));
        }
        print "0};\n";
    }
}

convertStream();
