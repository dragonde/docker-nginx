#!/usr/bin/perl -w

use strict;

### TAGINIT PERL 

my $index='/tmp/tag.index';
my $chmodfile='/tmp/chmod.sh';

print "\e[32mProcesando TAGINIT\e[0m\n\n";

my $TAGINIT=$ENV{'TAGINIT'};

if ($TAGINIT=~/^(\w+)\.(\w+)$/) {
   my ($segment,$tag)=($1,$2);
   print "\e[36mIndex: \e[33m$segment.$tag\e[0m\n";
   system ("/usr/local/sbin/download-tag.sh $segment $tag /tmp");
   open (INDEX,"<$index") || die ("Imposible Abrir $index");
   open (CHMOD,">$chmodfile") || die ("Imposible Abrir $chmodfile");
   while (my $line=<INDEX>) {
      $line=~/^\d{6}-\d{4} (\w+) \w+ (\/\S+)/ || die ("Linea Index Mal: $_");      my $tag=$1;
      my $dir=$2;
      system "/usr/local/sbin/download-tag.sh $segment $tag $dir";
      $line=~/ (\d{3})$/ || next;
      my $chmod=$1;
      print CHMOD "chmod -R $chmod $dir\n";
   }
   close (CHMOD);
   close (INDEX);
   unlink ($index);
} 

system "cat $chmodfile";
system "cat $chmodfile | sh";

die "\e[91mERROR INIT NO ENCONTRADO\e[0m\n"
    unless (-s "/usr/local/sbin/init.sh");
print "\n\e[32mEjecutando init.sh\e[0m\n";
exec "/usr/local/sbin/init.sh";

