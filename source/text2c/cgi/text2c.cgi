#!/usr/bin/perl -w

print "Content-type: text/html\n\n";


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
my $mode_str = $FORM{mode};

print "Convert Text to C \n";
print "<html><head><title>Text to C</title></head><body>\n";
print "<form action=\"text2c.cgi\" method=\"GET\">\n";
print "Mode:<br> <select id=\"mode\" name=\"mode\">\n";
print "<option value=\"string\">string</option>\n";
print "<option value=\"array\">array</option>\n";
print "</select><br>\n";
print "<textarea rows=\"40\" cols=\"80\" id=\"txt\" name=\"txt\">$input</textarea>\n";
print "<input type=SUBMIT>\n";
print "</form>\n";

sub fix_string {
    my $input = $_[0];
    my @bytes = split("", $input);
    my $output = "";
    for(my $i = 0; $i < scalar @bytes; $i++) {
        if($bytes[$i] eq "\r") {
            
        }elsif($bytes[$i] eq "\n") {
            $output .= "\\n";
        }
        elsif ($bytes[$i] eq "\\") {
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

sub convertString {
    print "const char *data = \"";
    print  fix_string($_[0]) . "\\n";
    print "\";\n";
}

sub convertStream {
    my $buffer = $_[0];
    print "unsigned char bytes[] = {\n";
    my @bytes = split("", $buffer);
    my $index = 0;
    for(my $i = 0; $i < scalar @bytes; $i++) {
        printf("0x%x,", ord($bytes[$i]));
        $index++;
        if($index > 10) {
            $index = 0;
            print "\n";
        }
    }
    print "\n0x0};\n";
}



print "<textarea cols=\"80\" rows=\"40\">";

if($mode_str eq "array") {
     convertStream($input);
} else {
    convertString($input);
}

print "</textarea>\n";
print "</body></html>\n";
