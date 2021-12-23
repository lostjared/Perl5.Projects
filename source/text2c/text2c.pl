#!/usr/bin/perl

sub convertStream {
	print "unsigned char bytes[] = {";
	while(<>) {
		my @values = split("", $_);
		for (my $i = 0; $i < scalar @values; $i++) {
			printf "0x%x, ", ord($values[$i]);
		}
	}
	print " 0};\n";
}

convertStream();

