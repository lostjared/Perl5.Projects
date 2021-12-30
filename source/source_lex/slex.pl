#!/usr/bin/perl -w

use warnings;

use constant {
    C_NULL => 0,
    CHAR => 1,
    DIGIT => 2,
    SYMBOL => 3,
    STRING => 4,
    SQ_STRING => 5,
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

sub get_token {
    my $input = $_[0];
    my $ch = substr($input, $pos, 1);
    my $n = $ch_map{ord($ch)};
    if($n == CHAR) {
        return get_char($input);
    } elsif($n == DIGIT) {
        return get_digit($input);
    } else {
        if($ch eq ' ' || $ch eq '\t' || $ch eq '\r'){
            $pos++;
            return get_token($input);
        }
    }
}



sub proc_line {
    my $ofile = $_[0];
    my $data = $_[1];
    while(my $token = get_token($data)) {
        print $token . "\n";
    }
}


sub proc_file {
    my $input_file = $_[0];
    print "slex: proccessing file: " . $input_file . "\n";
    open(INFILE, "<", $input_file) || die("could not open file: " . $!);
    open(OUTFILE, ">", $input_file . ".html") || die("could not open file: outputfile.html");
    print OUTFILE "<!doctype html>\n<html><head><title>$input_file</title></head><body>";
    while(<INFILE>) {
        chomp;
        proc_line(OUTFILE, $_);
    }
    print OUTFILE "</body></html>";
    close(INFILE);
    close(OUTFILE);
}


while (my $input = shift @ARGV) {
    proc_file($input);
}
