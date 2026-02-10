#!/usr/bin/perl
use strict;
use warnings;
use File::Find;

# Check for correct number of arguments
if (@ARGV < 2) {
    die "Usage: $0 <filename> <directory>\nExample: $0 config.hpp ./src\n";
}

my $target_name = $ARGV[0];
my $search_path = $ARGV[1];

print "Searching for '$target_name' in '$search_path' to strip comments...\n";

find(\&process_file, $search_path);

sub process_file {
    # Check if the current filename matches the target name exactly
    if ($_ eq $target_name) {
        my $file_path = $File::Find::name;
        print "Found and processing: $file_path\n";

        # Read the file
        open(my $fh, '<', $_) or die "Could not open $file_path: $!";
        my $content = do { local $/; <$fh> };
        close($fh);

        # Strip comments
        # Multi-line: /* ... */
        $content =~ s/\/\*.*?\*\///sg;
        # Single-line: // ...
        $content =~ s/\/\/.*//g;

        # Write back to file
        open(my $out, '>', $_) or die "Could not write to $file_path: $!";
        print $out $content;
        close($out);
    }
}

print "Search and strip complete.\n";
