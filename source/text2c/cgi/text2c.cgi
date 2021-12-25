#!/usr/bin/perl

print "Content-type: text/html\n\n";
print "Convert Text to C array\n";
print "<html><head><title>Text to C</title></head><body>\n";
print "<form action=\"text2c.cgi\" method=\"GET\">\n";
print "<textarea rows=\"40\" cols=\"80\" id=\"txt\" name=\"txt\"></textarea>\n";
print "<input type=SUBMIT>\n";
print "</form>\n";
print "</body></html>\n";

local ($buffer, @pairs, $pair, $name, $value, %FORM);
$ENV{'REQUEST_METHOD'} =~ tr/a-z/A-Z/;

if ($ENV{'REQUEST_METHOD'} eq "GET") {
   $buffer = $ENV{'QUERY_STRING'};
}

@pairs = split(/&/, $buffer);
foreach $pair (@pairs) {
   ($name, $value) = split(/=/, $pair);
   $value =~ tr/+/ /;
   $value =~ s/%(..)/pack("C", hex($1))/eg;
   $FORM{$name} = $value;
}

my $input = $FORM{txt};

sub convertStream {
    my $buffer = $_[0];
    print "unsigned char bytes[] = {\n<br>";
    my @bytes = split("", $buffer);
    my $index = 0;
    for(my $i = 0; $i < scalar @bytes; $i++) {
        printf("0x%x,", ord($bytes[$i]));
        $index++;
        if($index > 25) {
            $index = 0;
            print "<br>";
        }
    }
    print "<br>0x0};\n";
}
convertStream($input);

