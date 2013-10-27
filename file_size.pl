#!/usr/bin/perl
# perl file_size.pl $imgPath $outFile

use strict;
use warnings;
use File::Spec;
use Image::Info qw(image_info dim);

my $imgPath = File::Spec->rel2abs($ARGV[0]);
my $writeFile = $ARGV[1];

open (my $outFile,">$writeFile") or die $!;

opendir(DIR, $imgPath) or die $!;
while (my $file = readdir(DIR)){
	next if ($file =~ m/^\./);
	if ($file =~ m/jpg/ or $file =~ m/jpeg/){
		my $absPath = File::Spec->catdir($imgPath,$file);
		my $info = image_info($absPath);
		my ($w,$h) = dim ($info);
		print $outFile "$absPath $w $h \n";
	}
}
close(DIR);

close(outFile);