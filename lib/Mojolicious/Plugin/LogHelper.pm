package Mojolicious::Plugin::LogHelper;
use Mojo::Base 'Mojolicious::Plugin';

use Data::Dumper;

our $VERSION = '0.01';

sub register {
  my ( $self, $app, $opts ) = @_;

  my @datadumper_settings = qw(

    bless deepcopy deparse freezer indent maxdepth maxrecurse pad pair purity
    quotekeys sortkeys sparseseen terse toaster useperl useqq varname

  );

  my $logit = sub {

    my ( $level, $c, @msgs ) = @_;

    for my $msg ( @msgs ) {

      my $out = $msg;

      if ( ref $msg ) {

        my $d = Data::Dumper->new( [ $msg ] );

        for my $key ( @datadumper_settings ) {
          next unless exists $opts->{ $key };
          my $method = ucfirt $key;
          $d->$method( $opts->{ $key } );
        }

        $out = $d->Dump;

      }

      $c->app->log->$level( $out );

    }
  };

  $app->helper(
    debug => $logit->( 'debug', @_ ),
    info  => $logit->( 'info',  @_ ),
    warn  => $logit->( 'warn',  @_ ),
    error => $logit->( 'error', @_ ),
    fatal => $logit->( 'fatal', @_ ),
  );)
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

=head1 METHODS

L<Mojolicious::Plugin::LogHelper> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut
