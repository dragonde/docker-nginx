#!/usr/bin/perl -w

use strict;

### TAGINIT PERL 

my $index='/tmp/tag.index';
my $chmodfile='/tmp/chmod.sh';
my $storage='https://storage.googleapis.com';


print "\e[32mProcesando TAGINIT\e[0m\n\n";

my $TAGINIT=$ENV{'TAGINIT'};

if ($TAGINIT=~/^(\w+)\.(\w+)$/) {
   my ($segment,$tag)=($1,$2);
   print "\e[36mIndex: \e[33m$segment.$tag\e[0m\n";
   download_tag ($segment,$tag,"/tmp","index");
   open (INDEX,"<$index") || die ("\e[91mImposible Abrir $index\n");
   open (CHMOD,">$chmodfile") || die ("\e[91mImposible Abrir $chmodfile\n");
   while (my $line=<INDEX>) {
      $line=~/^\d{6}-\d{4} (\w+) (\w+) (\/\S+)/ || 
            die ("\e[91mLinea Index Mal: $_\n");     
      my $tag=$1;
      my $alias=$2;
      my $dir=$3;
      download_tag($segment,$tag,$dir,$alias);
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

sub download_tag {
  my ($segment,$tag,$dir,$alias)=@_;
  print "\e[36mDescarga \e[35m$segment \e[33m$tag\e[0m\n";
  my $file="/tmp/$tag";
  system ("curl -sSL $storage/$segment/$tag -o $file");
  if (-s "$file") { 
    my $md5=`md5sum $file | head -c 20`;
    die ("\e91mERROR MD5 en $segment $tag\e[0m") 
        if ($md5 ne $tag);
  } else {
    die ("\e91mERROR DESCARGA en $segment/$tag\e[0m");
  }  
  print "\e[36mDescomprimiendo en \e[94m$dir\e[0m\n";
  system ("tar zx -C $dir -f $file");
  unlink "$file";
}
