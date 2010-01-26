=head1 NAME

MooseX::Types::Ro - Moose types for read-only containers

=cut    

package MooseX::Types::Ro;

use strict;
use warnings;

our $VERSION = '0.01';
$VERSION = eval $VERSION;

use MooseX::Types -declare => [qw(RoHashRef RoArrayRef)];
use MooseX::Types::Moose qw(HashRef ArrayRef Value Undef);
use Internals qw(SetReadOnly IsWriteProtected);
use List::MoreUtils qw(all);
use Scalar::Util qw(blessed);

use namespace::autoclean;

=head1 TYPES

=head2 RoArrayRef

A subtype of C<ArrayRef> in which the array itself and all the elements
are read-only.  Coerces from C<ArrayRef> by making a shallow copy and
marking it read-only.

=cut

subtype RoArrayRef,
    as ArrayRef,
    where { IsWriteProtected($_) && all { IsWriteProtected(\$_) } @{$_} },
    message { "Array or values are writable" };

coerce RoArrayRef,
    from ArrayRef,
    via {
        my @copy = @{$_};
        SetReadOnly(\@copy);
        SetReadOnly(\$_) foreach @copy;
        return \@copy;
    };

=head2 RoHashRef

A subtype of C<HashRef> in which the hash itself and all the values are
read-only.  Coerces from HashRef by making a shallow copy and marking it
read-only.

=cut

subtype RoHashRef,
    as HashRef,
    where { IsWriteProtected($_) && all { IsWriteProtected(\$_) } values %{$_} },
    message { "Hash or values are writable" };

coerce RoHashRef,
    from HashRef,
    via {
        my %copy = %{$_};
        SetReadOnly(\%copy);
        SetReadOnly(\$_) foreach values %copy;
        return \%copy;
    };

=head1 SEE ALSO

L<MooseX::Types>,
L<MooseX::Types::Moose>,
L<Moose::Util::TypeConstraints>,
L<Internals>

=head1 AUTHOR

Dagfinn Ilmari MannsE<aring>ker <ilmari@ilmari.org>.

=head1 COPYRIGHT & LICENSE

Copyright (c) 2010 Dagfinn Ilmari MannsE<aring>ker <ilmari@ilmari.org>.

This program is free software; you can redistribute and/or modify it under
the same terms as perl itself.

=cut

1;

