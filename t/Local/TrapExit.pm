package Local::TrapExit;

use strict;
use warnings;

my $exit_code;

my $exit_trap = sub {
    $exit_code = scalar(@_) ? ( $_[0] || 0 ) : 0;

    CORE::exit(0);
};

BEGIN {
    *CORE::GLOBAL::exit = sub { $exit_trap->(@_); };
}

sub exit_code {
    return $exit_code;
}

1;
__END__
