#!/usr/bin/perl -w


$nn=$ARGV[0];												#total number of nodes
$nt=$ARGV[1];												#total number of traffics
my(@srcs, @dst);
#@srcs=();
my $random;

srand (time ^ $$ ^ unpack "%L*", `ps axww | gzip`);

for( $i=0; $i<$nt; $i++){

	do{
		$random=int(rand($nn-1));
		printf("%d\n", $random);

	}while(exists($src{$random}));
	
	push(@src, $random);
}
printf("\n");

for( $i=0; $i<$nt; $i++){

	do{
		$random=int(rand($nn-1));
		printf("%d\n", $random);
	}while(exists($src{$random}) && exists($dst{$random}));

	push(@dst, $random);	
}


for( $i=0; $i<$nt; $i++){

	printf("src: %d dst: %d\n",$src[$i], $dst[$i]);
}

$a=3;
$src[11]=3;

printf("i have ")	if exists $src{$a};
