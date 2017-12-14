#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;

my $file = '';
my %counter;

GetOptions("f=s" => \$file);

die "usage: $0 -f <file>\n" unless defined $file;

open FILE, $file or die "cannot open file $!\n";

while (<FILE>) {

        my $line = chomp;
        my @stuff = split /\(/;
        my $function = $stuff[0];

        $counter{$function} += 1;
}

printf "%-30s %-11s\n", "function", "occurrences";
for my $f (sort keys %counter) {
        printf "%-30s %-11s\n", $f, $counter{$f};
}
close FILE;
