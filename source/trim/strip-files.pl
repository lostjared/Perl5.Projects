#!/usr/bin/perl
use strict;
use warnings;
use File::Find;
use File::Slurp; # Note: You may need to install this, or use the core alternative below

# Define the starting directory (current directory by default)
my $root_dir = $ARGV[0] || '.';

print "Starting comment removal in: $root_dir\n";

find(\&process_file, $root_dir);

sub process_file {
    # Target only .cpp and .hpp files
    if (/\.(cpp|hpp)$/) {
        my $file_path = $File::Find::name;
        print "Processing: $file_path\n";

        # Read the entire file content
        open(my $fh, '<', $_) or die "Could not open file $_: $!";
        my $content = do { local $/; <$fh> };
        close($fh);

        # Regex to remove comments:
        # 1. Multi-line comments: \/\*.*?\*\/
        # 2. Single-line comments: \/\/.*
        # The /s modifier allows . to match newlines for multi-line blocks
        # The /g modifier applies it globally
        
        $content =~ s/\/\*.*?\*\///sg;
        $content =~ s/\/\/.*//g;

        # Write the cleaned content back to the file
        open(my $out, '>', $_) or die "Could not write to file $_: $!";
        print $out $content;
        close($out);
    }
}

print "Done! All comments stripped from .cpp and .hpp files.\n";
