#!/usr/bin/perl -w

use warnings;

use constant {
    C_NULL => 0,
    CHAR => 1,
    DIGIT => 2,
    SYMBOL => 3,
    STRING => 4,
    SQ_STRING => 5,
    SPACE => 6,
};

sub init_map {
    my %num = ();
    for(my $i = 0; $i < 255; $i++) {
        $num{$i} = C_NULL;
    }
    for (my $i = ord('A'); $i <= ord('Z'); $i++) {
        $num{$i} = CHAR;
    }
    for (my $i = ord('a'); $i <= ord('z'); $i++) {
        $num{$i} = CHAR;
    }
    for(my $i = ord('0'); $i <= ord('9'); $i++) {
        $num{$i} = DIGIT;
    }
    
    $num{ord('_')} = CHAR;
    $num{ord(' ')}  = SPACE;
    $num{ord("\t")} = SPACE;
    $num{ord("\r")} = SPACE;
    $num{ord('"')} = STRING;
    $num{ord("\'")} = SQ_STRING;
    
    my $symbols = "`!@#$%^&*()-[]|/<>.,?+--=:;{}";
    for(my $i = 0; $i < length($symbols); $i++) {
        my $ch = substr($symbols, $i, 1);
        $num{ord($ch)} = SYMBOL;
    }
    
    return %num;
}

my %ch_map = init_map();
my $pos = 0;

sub get_char {
    my $input = $_[0];
    my $token;
    my $ch = substr($input, $pos, 1);
    my $n = $ch_map{ord($ch)};
    while($n == CHAR || $n == DIGIT) {
        $token .= $ch;
        $pos++;
        if($pos > length($input)) {
            last;
        }
        $ch = substr($input, $pos, 1);
        $n = $ch_map{ord($ch)};
    }
    return $token;
}

sub get_digit {
    my $input = $_[0];
    my $token;
    my $ch = substr($input, $pos, 1);
    my $n = $ch_map{ord($ch)};
    while($n == DIGIT) {
        $token .= $ch;
        $pos++;
        if($pos > length($input)) {
            last;
        }
        $ch = substr($input, $pos, 1);
        $n = $ch_map{ord($ch)};
    }
    return $token;
}

sub get_string {
    my $input = $_[0];
    my $token;
    $pos++;
    my $ch = substr($input, $pos, 1);
    my $n = $ch_map{ord($ch)};
    
    while($n != STRING) {
        $token .= $ch;
        $pos++;
        if($pos > length($input)) {
            last;
        }
        $ch = substr($input, $pos, 1);
        $n = $ch_map{ord($ch)};
        if($ch eq "\\") {
            $pos++;
            if($pos+1 < length($input)) {
                $ch = substr($input, $pos, 1);
                $token .= "\\" . $ch;
                $pos++;
                $ch = substr($input, $pos, 1);
                $n = $ch_map{ord($ch)};
            }
        }
    }
    $pos++;
    return $token;
}

sub get_sq_string {
    my $input = $_[0];
    my $token;
    $pos++;
    my $ch = substr($input, $pos, 1);
    my $n = $ch_map{ord($ch)};
    
    while($n != SQ_STRING) {
        $token .= $ch;
        $pos++;
        if($pos > length($input)) {
            last;
        }
        $ch = substr($input, $pos, 1);
        $n = $ch_map{ord($ch)};
        if($ch eq "\\") {
            $pos++;
            if($pos+1 < length($input)) {
                $ch = substr($input, $pos, 1);
                $token .= "\\" . $ch;
                $pos++;
                $ch = substr($input, $pos, 1);
                $n = $ch_map{ord($ch)};
            }
        }
    }
    $pos++;
    return $token;
}

sub get_symbol {
    my $input = $_[0];
    my $ch = substr($input, $pos, 1);
    my $n = $ch_map{ord($ch)};
    $pos++;
    if($pos < length($input)) {
        my $nch = substr($input, $pos, 1);
        my $nn = $ch_map{ord($nch)};
        if($nn == SYMBOL && $nch eq $ch) {
            $pos++;
            return $ch . $nch;
        }
        
    }
    return $ch;
}

my $token_type = CHAR;

sub type_strings {
    my $tok = $_[0];
    if($tok == CHAR) {
        return "ID";
    }
    if($tok == DIGIT) {
        return "Digits";
    }
    if($tok == STRING || $tok == SQ_STRING) {
        return "String";
    }
    if($tok == SYMBOL) {
        return "Symbol";
    }
    return "Unknown";
}


sub get_token {
    
    my $input = $_[0];
    
    if($pos+1 > length($input)) {
        return;
    }
    
    my $ch = substr($input, $pos, 1);
    my $n = $ch_map{ord($ch)};
    $token_type = $n;
    if($n == CHAR) {
        return get_char($input);
    } elsif($n == DIGIT) {
        return get_digit($input);
    } elsif($n == STRING) {
        return get_string($input);
    } elsif($n == SQ_STRING) {
        return get_sq_string($input);
    } elsif($n == SYMBOL) {
        return get_symbol($input);
    } elsif($n == SPACE) {
         while(1) {
            if($pos < length($input)) {
                my $c = substr($input, $pos, 1);
                my $nn = $ch_map{ord($c)};
                if ($nn != SPACE) {
                    last;
                } else {
                    $pos++;
                }
            } else {
                last;
            }
        }
        return get_token($input);
    } elsif($n == C_NULL) {
        print "[" . ord($ch) . "/" . $ch . "] -> Invalid character..\n";
        $pos++;
        return get_token($input);
    }
}

sub proc_line {
    my $ofile = $_[0];
    my $data = $_[1];
    my $line = $_[2];
    $pos = 0;
    while(my $token = get_token($data)) {
        my $ts = type_strings($token_type);
        print $ofile "<tr><th>$line</th><th>$token</th><th>$ts</th></tr>\n";
        print $line . ":\t" . $token . "\t-> $ts\n";
    }
}

sub proc_file {
    my $input_file = $_[0];
    my $line = 1;
    print "slex: proccessing file: " . $input_file . "\n";
    open(INFILE, "<", $input_file) || die("could not open file: " . $!);
    open(OUTFILE, ">", $input_file . ".html") || die("could not open file: outputfile.html");
    print OUTFILE "<!doctype html>\n<html><head><title>$input_file</title></head><body>";
    print OUTFILE "<table border=\"1\" padding=\"5\"><tr><th>Line</th><th>Token</th><th>Type</th></tr>";
    while(<INFILE>) {
        chomp;
        proc_line(OUTFILE, $_, $line);
        $line++;
    }
    print OUTFILE "</table></body></html>";
    close(INFILE);
    close(OUTFILE);
}
while (my $input = shift @ARGV) {
    proc_file($input);
}
