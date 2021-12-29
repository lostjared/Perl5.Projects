#!/usr/bin/perl -w
my %words = ();
while(<>) {
    @array = split(/\s+/, $_);
    for $w (@array) {
        $words{$w}++;
    }
}
@sorted = sort keys %words;
for my $keys (@sorted) {
    print $keys . " = " . %words{$keys} . "\n";
}
