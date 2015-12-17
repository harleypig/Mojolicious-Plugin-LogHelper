package Mojolicious::Plugin::LogHelper;
use Mojo::Base 'Mojolicious::Plugin';

use Data::Dumper ();

our $VERSION = '0.01';

sub register {
  my ( $self, $app, $dumper_opts ) = @_;

  $dumper_opts ||= {};

  die 'expected hash ref or nothing for LogHelper options'
    unless ref $dumper_opts eq 'HASH';

  $app->helper( debug => sub { _logit( 'debug', $dumper_opts, @_ ) } );
  $app->helper( info  => sub { _logit( 'info',  $dumper_opts, @_ ) } );
  $app->helper( warn  => sub { _logit( 'warn',  $dumper_opts, @_ ) } );
  $app->helper( error => sub { _logit( 'error', $dumper_opts, @_ ) } );
  $app->helper( fatal => sub { _logit( 'fatal', $dumper_opts, @_ ) } );

}

sub _dumper {

  my ( $dumper_opts, $ref ) = @_;

  my @datadumper_settings = qw(

    bless deepcopy deparse freezer indent maxdepth maxrecurse pad pair purity
    quotekeys sortkeys sparseseen terse toaster useperl useqq varname

  );

  my $d = Data::Dumper->new( [ $ref ] );

  for my $key ( @datadumper_settings ) {

    next unless exists $dumper_opts->{ $key };
    my $method = ucfirt $key;
    $d->$method( $dumper_opts->{ $key } );

  }

  return $d->Dump;

}

sub _logit {

  my ( $level, $dumper_opts, $c, @msgs ) = @_;

  my $location = (caller( 3 ))[3];

  for my $msg ( @msgs ) {

    my $out = ref $msg ? _dumper( $dumper_opts, $msg ) : $msg;
    $c->app->log->$level( "[$location] $out" );

  }
}


1;
__END__

=encoding utf8

=head1 NAME

Mojolicious::Plugin::LogHelper - Mojolicious Plugin

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('LogHelper');

  # Mojolicious::Lite
  plugin 'LogHelper';

=head1 DESCRIPTION

L<Mojolicious::Plugin::LogHelper> is a L<Mojolicious> plugin.

=head1 HELPERS

=head2 debug

=head2 info

=head2 warn

=head2 error

=head2 fatal

These are helpers for the equivalent C<log> methods.

=head1 METHODS

L<Mojolicious::Plugin::LogHelper> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut
