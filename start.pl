#!/usr/bin/perl -w

use strict;

### TAGINIT PERL 

my $index='/tmp/index-taginit';

print "\e[32mProcesando TAGINIT\e[0m\n\n";

my $TAGINIT=$ENV{'TAGINIT'};

if ($TAGINIT=~/^(\w+)@(\w+):(.+)$/) {
   my ($tag,$driver,$segment)=($1,$2,$3);
   die ("\e[91mDRIVER $driver NO ENCONTRADO\n") 
       unless (-f "/usr/local/sbin/storage-$driver.sh");
   print "\e[36mIndex: \e[33m$segment.$tag\e[0m\n";
   download_tag ($driver,$segment,$tag,"/tmp","index");
   open (INDEX,"<$index") || die ("\e[91mImposible Abrir $index\n");
   while (my $line=<INDEX>) {
      next if ($line=~/ index\s*$/);
      $line=~/^\d{6}-\d{4} (\w+) (\w+) (\/\S+)/ || 
            die ("\e[91mLinea MAL en INDEX: $line\n");     
      my $tag=$1;
      my $alias=$2;
      my $dir=$3;
      die ("\e[91mDIRECTORIO INCORRECTO $dir\n") unless (-d $dir);
      download_tag($driver,$segment,$tag,$dir,$alias);
   }
   close (INDEX);
   unlink ($index);
} 

die "\e[91mERROR INIT NO ENCONTRADO\e[0m\n"
    unless (-s "/usr/local/sbin/init.sh");
print "\n\e[32mEjecutando init.sh\e[0m\n";
exec "/usr/local/sbin/init.sh";

sub download_tag {
  my ($driver,$segment,$tag,$dir,$alias)=@_;
  print "\e[36mDescarga \e[35m$segment \e[33m$tag\e[0m\n";
  my $file="/tmp/$tag";
  system ("storage-$driver.sh get $segment $tag $file");
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
