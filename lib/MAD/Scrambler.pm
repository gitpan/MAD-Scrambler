package MAD::Scrambler;
$MAD::Scrambler::VERSION = '0.000001';
use Moo;
extends 'Exporter';

our @EXPORT_OK = qw{
  nibble_split
  nibble_join
};

use List::Util qw{ shuffle };

use Const::Fast;

const our $MAX_NUMBER => 2**32;

has 'scrambler' => (
    is      => 'ro',
    lazy    => 1,
    default => sub { [ shuffle 0 .. 7 ] },
);

has 'unscrambler' => (
    is      => 'ro',
    lazy    => 1,
    builder => sub {
        my ($self) = @_;

        my @scrambler   = @{ $self->scrambler };
        my @unscrambler = ();

        for ( 0 .. 7 ) {
            $unscrambler[ $scrambler[$_] ] = $_;
        }

        return \@unscrambler;
    },
);

has 'bit_mask' => (
    is      => 'ro',
    default => sub { int rand $MAX_NUMBER },
);

sub encode {
    my ( $self, $number ) = @_;

    my @slice     = @{ $self->scrambler };
    my @nibbles   = nibble_split($number);
    my $scrambled = nibble_join( @nibbles[@slice] );
    my $encoded   = $scrambled ^ $self->bit_mask;

    return $encoded;
}

sub decode {
    my ( $self, $encoded ) = @_;

    my @slice   = @{ $self->unscrambler };
    my $number  = $encoded ^ $self->bit_mask;
    my @nibbles = nibble_split($number);
    my $decoded = nibble_join( @nibbles[@slice] );

    return $decoded;
}

sub nibble_split {
    my ($number) = @_;

    my @nibbles;
    for ( 0 .. 7 ) {
        $nibbles[$_] = ( $number >> ( $_ * 4 ) ) & 0x0000000f;
    }

    return @nibbles;
}

sub nibble_join {
    my (@nibbles) = @_;

    my $number = 0;
    for ( 0 .. 7 ) {
        $number = $number | ( $nibbles[$_] << ( $_ * 4 ) );
    }

    return $number;
}

1;

# ABSTRACT: Scramble nibbles of a 32-bit integer

__END__

=pod

=encoding UTF-8

=head1 NAME

MAD::Scrambler - Scramble nibbles of a 32-bit integer

=head1 VERSION

version 0.000001

=head1 SYNOPSIS

Scrambles a 32-bit integer with a kind of reversible hashing function.
Definitely it is not a cryptographic hash, it is just of reversible shuffle.

    use MAD::Scramble;

    my $scrambler = MAD::Scrambler->new(
        scrambler => [ 1, 3, 5, 7, 0, 2, 4, 6 ],
        bit_mask  => 0xFDB97531,
    );

    my $code = $scrambler->encode( 42 );
    ## 0xFDB37533

    my $number = $scrambler->decode( 0xFDB37533 );
    ## 42

Very useful for example when you need to expose a reference to a object into
a database in a URL, but you don't want expose the primary key itself.

Note that this is not for solving security problems, sure, since this is
reversible and someone can extract back the original value.

Think in this approach when you want difficult the guess of the value instead
of completely forbid the access to it.

=head1 METHODS

=head2 new( %args )

Constructor.

C<%args> is a hash which may contains the keys C<scrambler> and C<bit_mask>.

C<scrambler> is the order to B<"shuffle"> the nibbles of the number you will
encode. Internally an B<"unscrambler"> is calculated to reverse de process
when you decode a previously encoded number.

C<bit_mask> is a 32-bit value to be "XORed" with the new scrambled number
when encoding or decoding.

=head2 encode( $number )

=head2 decode( $code )

=head2 nibble_split( $number )

Splits apart the given number in eight nibbles. The least significant nibbles
are put in the lowest indexes.

    use MAD::Scrambler qw{ nibble_split };

    @nibbles = nibble_split( 0x12345678 );
    ## ( 8, 7, 6, 5, 4, 3, 2, 1 )

=head2 nibble_join( @nibbles )

Joins the nibbles together returning the corresponding integer. The least
significant nibbles are located in the lowest indexes.

    use MAD::Scrambler qw{ nibble_join };

    my $number = nibble_join( 1, 3, 5, 7, 9, 11, 13, 15 )
    ## 0xFDB97531

=head1 AUTHOR

Blabos de Blebe <blabos@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Blabos de Blebe.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
