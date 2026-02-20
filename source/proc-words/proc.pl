#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Std;
use List::Util qw(shuffle all);

sub reverse_string {
    my ($text) = @_;
    return scalar reverse $text;
}

sub shuffle_string {
    my ($text) = @_;
    return $text if length($text) < 4;

    my $first = substr($text, 0, 1);
    my $last  = substr($text, -1);
    my $middle = substr($text, 1, length($text) - 2);
    my $original_middle = $middle;

    my @mid_chars = split //, $middle;
    if (all { $_ eq $mid_chars[0] } @mid_chars) {
        return $text;
    }

    my $reversed_text = scalar reverse $text;
    my $is_palindrome = ($text eq $reversed_text);

    my $attempts = 0;
    my @shuffled_mid;
    do {
        @shuffled_mid = shuffle(split //, $middle);
        $middle = join('', @shuffled_mid);
        $attempts++;
        if ($attempts >= 1000) {
            $middle = $original_middle;
            last;
        }
    } while ($middle eq $original_middle);

    my $shuffled = $first . $middle . $last;
    if (!$is_palindrome && $shuffled eq $text) {
        return $text;
    }
    return $shuffled;
}

sub parse_words {
    my ($s, $case_mode) = @_;
    $case_mode //= 0;
    my @words;
    my $word = '';

    for my $c (split //, $s) {
        if ($c =~ /[a-zA-Z]/) {
            if ($case_mode == 0) {
                $word .= $c;
            } elsif ($case_mode == 1) {
                $word .= uc($c);
            } elsif ($case_mode == 2) {
                $word .= lc($c);
            }
        } else {
            if ($word ne '') {
                push @words, $word;
                $word = '';
            }
        }
    }
    push @words, $word if $word ne '';
    return @words;
}

sub echo_words {
    my @words = @_;
    for my $w (@words) {
        print "$w " if $w ne '';
    }
    print "\n";
}

sub echo_words_transformed {
    my ($words_ref, $func, $sorted) = @_;
    $sorted //= 0;
    my @cap = map { $func->($_) } @$words_ref;
    @cap = sort @cap if $sorted;
    echo_words(@cap);
}

my %opts;
getopts('hsrcuonULi:', \%opts);

if ($opts{h}) {
    print <<HELP;
Usage: $0 [options]
  -h            Display help message
  -s            shuffle
  -r            reverse
  -c            static order (no shuffle)
  -u            unique words only
  -o            sorted
  -n            no operation keep the same
  -U            upper case
  -L            lower case
  -i <file>     input file
HELP
    exit 0;
}

my $mode         = 0;
my $uniq         = $opts{u} ? 1 : 0;
my $static_order = $opts{c} ? 1 : 0;
my $sorted       = $opts{o} ? 1 : 0;
my $value_case   = 0;

$mode = 1 if $opts{s};
$mode = 2 if $opts{r};
$mode = 3 if $opts{n};
$value_case = 1 if $opts{U};
$value_case = 2 if $opts{L};

my $source_file = $opts{i} // '';

if ($mode == 0) {
    print STDERR "You must provide an operation option\n";
    exit 1;
}

if ($value_case < 0 || $value_case > 2) {
    print STDERR "Value case must be 0-2\n";
    exit 1;
}

if ($source_file eq '') {
    print STDERR "You must provide a filename\n";
    exit 1;
}

open(my $fh, '<', $source_file) or do {
    print STDERR "Error: file not found/could not open: $source_file\n";
    exit 1;
};

my $content = do { local $/; <$fh> };
close $fh;

my $func = ($mode == 2) ? \&reverse_string : \&shuffle_string;

if (!$uniq) {
    my @words = parse_words($content, $value_case);
    @words = shuffle(@words) unless $static_order;
    if ($mode == 3) {
        echo_words(@words);
    } else {
        echo_words_transformed(\@words, $func, $sorted);
    }
} else {
    my %seen;
    my @words = grep { !$seen{$_}++ } parse_words($content, $value_case);
    @words = sort @words;  
    if ($mode == 3) {
        echo_words(@words);
    } else {
        echo_words_transformed(\@words, $func, $sorted);
    }
}

exit 0;
