use strict;
use warnings;

package Test::Deep::DoesNotExist;

use Test::Deep::Cmp;

my $Singleton = __PACKAGE__->SUPER::new;

sub new
{
  return $Singleton;
}

sub descend
{
  return 0;
}

1;

