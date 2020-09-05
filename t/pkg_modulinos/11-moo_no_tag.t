#!perl
package My::Script;

$| = 1;

use strict;
use warnings;

# defer locking so we have a chance to see if the tag was found
BEGIN {
    $ENV{RUNALONE_DEFER_LOCK} = 1;
}

use FindBin;
use lib $FindBin::Bin . '/..';
use Local::TrapExit;

use Test::More;    # tests => 2;

my $run_entered;
my $stderr = '';

use Moo;
{
    local $SIG{__WARN__} = sub { $stderr .= $_[0]; };
    with 'Role::RunAlone';
}

do {
    my $app = __PACKAGE__->new;
    $app->run;
} unless caller();

sub run {
    my $self = shift;

    $run_entered = 1;
}

exit;

END {
    ok( 1, 'in the END block' );
    is( Local::TrapExit::exit_code(), 2, 'exit code 2 indicates missing tag' );
    like( $stderr, qr/FATAL: No/, 'missing tag error was on STDERR' );
    ok( !__PACKAGE__->DOES('Role::RunAlone'), 'role was not composed' );
    ok( !$run_entered,                        'script did not execute' );
    done_testing();
}

