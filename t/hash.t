use strict;
use warnings;
use lib 't/lib';

use Std;

{
  check_test(
    sub {
      cmp_deeply({key1 => "a", key2 => "b"}, {key1 => "a", key2 => "b"},
        "hash eq");
    },
    {
      name => "hash eq",
      actual_ok => 1,
      diag => "",
    }
  );
  check_test(
    sub {
      cmp_deeply({key1 => "a", key2 => "b"}, {key1 => "a", key2 => "c"},
        "hash not eq");
    },
    {
      name => "hash not eq",
      actual_ok => 0,
      diag => <<EOM,
Compared \$data->{"key2"}
   got : 'b'
expect : 'c'
EOM
    }
  );
  check_test(
    sub {
      cmp_deeply({key1 => "a"}, {key1 => "a", key2 => "c"},
        "hash got DNE");
    },
    {
      name => "hash got DNE",
      actual_ok => 0,
      diag => <<EOM,
Comparing hash keys of \$data
Missing: 'key2'
EOM
    }
  );
  check_test(
    sub {
      cmp_deeply({key1 => "a", key2 => "c"}, {key1 => "a"},
        "hash expected DNE");
    },
    {
      name => "hash expected DNE",
      actual_ok => 0,
      diag => <<EOM,
Comparing hash keys of \$data
Extra: 'key2'
EOM
    }
  );

  check_test(
    sub {
      cmp_deeply({key1 => "a", key2 => "c"}, superhashof({key1 => "a"}),
        "superhash ok");
    },
    {
      name => "superhash ok",
      actual_ok => 1,
      diag => "",
    }
  );

  check_test(
    sub {
      cmp_deeply({key1 => "a"}, subhashof({key1 => "a", key2 => "c"}),
        "subhash ok");
    },
    {
      name => "subhash ok",
      actual_ok => 1,
      diag => "",
    }
  );

  my $spec = { key1 => "a", key2 => doesnotexist };

  check_test(
    sub {
      cmp_deeply({key1 => "a"}, $spec,
        "doesnotexist ok");
    },
    {
      name => "doesnotexist ok",
      actual_ok => 1,
      diag => "",
    },
  );

  ok($spec->{key2}, 'spec unchanged');

  check_test(
    sub {
      cmp_deeply({key1 => "a"}, { key1 => doesnotexist },
        "doesnotexist not ok");
    },
    {
      name => "doesnotexist not ok",
      actual_ok => 0,
      diag => <<'EOM',
Comparing hash keys of $data
Should have been missing: 'key1'
EOM
    },
  );

  check_test(
    sub {
      cmp_deeply({key1 => "a"}, superhashof($spec),
        "doesnotexist ok with superhashof");
    },
    {
      name => "doesnotexist ok with superhashof",
      actual_ok => 1,
      diag => "",
    },
  );

  ok($spec->{key2}, 'spec unchanged');

  check_test(
    sub {
      cmp_deeply({key1 => "a"}, { key1 => doesnotexist },
        "doesnotexist not ok with superhashof");
    },
    {
      name => "doesnotexist not ok with superhashof",
      actual_ok => 0,
      diag => <<'EOM',
Comparing hash keys of $data
Should have been missing: 'key1'
EOM
    },
  );
}
