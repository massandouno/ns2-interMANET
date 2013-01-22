#!/usr/bin/perl -w

open(FILE, "<", "$ARGV[0]") 
	or die "cannot open $ARGV[0]";

$sum=0.00000;
$count=0.00000;
while(<FILE>) {
	chomp;
	@term = split(/\s+/, $_);
	$num= scalar @term;
	for($i=0; $i<$num; $i++) {
		$sum = $sum + $term[$i];
	}
	$count = $count + 1.00000;
}
printf("%f\n", $sum/$count);
close FILE;
