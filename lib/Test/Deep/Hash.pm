use strict;
use warnings;

package Test::Deep::Hash;

use Test::Deep::Ref;
use Storable qw(dclone);

sub init
{
  my $self = shift;

  my $val = shift;

  $self->{val} = $val;
}

sub descend
{
  my $self = shift;

  my $got = shift;

  my $exp = dclone $self->{val};

  my $data = $self->data;

  return 0 unless Test::Deep::descend($got, $self->hash_keys($exp));

  return 0 unless $self->test_class($got);

  return Test::Deep::descend($got, $self->hash_elements($exp));
}

sub hash_elements
{
  require Test::Deep::HashElements;

  my $self = shift;

  return Test::Deep::HashElements->new(@_);
}

sub hash_keys
{
  require Test::Deep::HashKeys;

  my $self = shift;
  my $exp = shift;

  return Test::Deep::HashKeys->new($exp);
}

sub reset_arrow
{
  return 0;
}

package Test::Deep::SuperHash;

use base 'Test::Deep::Hash';

sub hash_elements
{
  require Test::Deep::HashElements;

  my $self = shift;

  return Test::Deep::SuperHashElements->new(@_);
}

sub hash_keys
{
  require Test::Deep::HashKeys;

  my $self = shift;
  my $exp = shift;

  return Test::Deep::SuperHashKeys->new($exp);
}

package Test::Deep::SubHash;

use base 'Test::Deep::Hash';

sub hash_elements
{
  require Test::Deep::HashElements;

  my $self = shift;

  return Test::Deep::SubHashElements->new(@_);
}

sub hash_keys
{
  require Test::Deep::HashKeys;

  my $self = shift;
  my $exp = shift;

  return Test::Deep::SubHashKeys->new($exp);
}

1;
