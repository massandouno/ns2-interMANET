#!/usr/bin/perl -w

open(FILE1, "<", "$ARGV[0]") 
	or die "cannot open $ARGV[0]";

open(FILE2, "<", "$ARGV[1]") 
	or die "cannot open $ARGV[1]";

$sumi=0;
$count=0;

$avg=0;

while(<FILE2>) {
	chomp;
	@term = split(/\s+/, $_);
	$num= scalar @term;
		$avg= $term[0];
}

close FILE2;


while(<FILE1>) {
	chomp;
	@term = split(/\s+/, $_);
	$num= scalar @term;
	for($i=0; $i<$num; $i++) {
		$sumi = ($term[$i] - $avg)*($term[$i] - $avg);
	}
	$count = $count + 1;
}

$dev1=$sumi/($count-1);
$dev2=sqrt($dev1);

printf("Avg: %d Dev: %d\n", $avg, $dev2);
close FILE1;

