my %inihash = ();
my($value, $key, $section, $lastsection) = ('');
my $stdouterr = 1;
my $outfilerr = 0;

if($ARGV[0] eq '') {
	print STDERR "Script to sort .INI files\n";
	print STDERR "Usage: $0 infile\n";
	exit;
}

if((-f($ARGV[0])) == 0) {
	print STDERR "Couldn\'t open $ARGV[0]\n";
	exit;
}

&ini($ARGV[0], \%inihash);
open(OUTFILE, ">$ARGV[0]") or die "Couldn\'t open $ARGV[0]";

foreach $section (sort keys %inihash) {
	print OUTFILE "[$section]\n" if($section ne '');
	foreach $key (sort keys % {$inihash {$section}}) {
		if(@ {$inihash {$section} {$key}} > 1) {
			print OUTFILE ";Error: duplicate key\n" if $outfilerr;
			print "Error: duplicate key [$section]->$key\n" if $stdouterr;
		}
		foreach $value (sort @ {$inihash {$section} {$key}}) {
			print OUTFILE "$key=$value\n";
		}
	}
	$lastsection = $section;
}
	
close OUTFILE;
exit;

sub ini {
	my($file, $hash_ref) = @_;
	my($linein, $section) = ('');
	open(FILE, $file) or die "Can't open $file";
	while(<FILE>) {
		next if $_ =~ /^[#;]/;
		chomp;
		if($_ =~ /^\s*\[([^\]]+)\]/) {
			$section = $1;
			push(@ {$$hash_ref {$section} {$1}}, ());
		} elsif($_ =~ /^([^=]+?)\s*=\s*(.*)\s*$/) {
			push(@ {$$hash_ref {$section} {$1}}, $2);
		}
	}
	close(FILE);
}

__END__
