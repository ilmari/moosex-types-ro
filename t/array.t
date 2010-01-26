#!perl
# -*- indent-tabs-mode: nil -*-

use strict;
use warnings;

{
    package Class;
    use Moose;
    use MooseX::Types -declare => [qw(RoIntArray)];
    use MooseX::Types::Ro qw(RoArrayRef);
    use MooseX::Types::Moose qw(ArrayRef Int);

    subtype RoIntArray,
        as RoArrayRef[Int];
    coerce RoIntArray,
        from ArrayRef[Int],
        via { to_RoArrayRef($_) };

    has plain => (is => 'ro', isa => RoArrayRef);
    has parametrised => (is => 'ro', isa => RoArrayRef[Int]);

    has coerced_plain => (is => 'ro', isa => RoArrayRef, coerce => 1);
    has coerced_parametrised => (is => 'ro', isa => RoIntArray, coerce => 1);

}

package main;

use Test::More;
use Test::Exception;

use MooseX::Types::Ro qw(RoArrayRef);
use Internals qw(SetReadOnly IsWriteProtected);

my $readonly = [1,2,3];
SetReadOnly($readonly);
SetReadOnly(\$_) foreach @{$readonly};

foreach my $type (qw(plain parametrised)) {
    my $plain = [1,2,3];
    my $coerced = "coerced_$type";
    lives_and { is_deeply( Class->new($type => $readonly)->$type, [1,2,3]) } "$type";
    throws_ok { Class->new($type => $plain) } qr/does not pass/, "writable $type";
    lives_and { is_deeply( Class->new($coerced => $plain)->$coerced, [1,2,3] ) } "coerced $type";
    ok( !IsWriteProtected($plain), "original array still writable" );
}

done_testing;
