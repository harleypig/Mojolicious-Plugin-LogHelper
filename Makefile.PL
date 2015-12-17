use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Mojolicious::Plugin::LogHelper',
  VERSION_FROM => 'lib/Mojolicious/Plugin/LogHelper.pm',
  AUTHOR       => 'A Good Programmer <nospam@cpan.org>',
  PREREQ_PM    => {'Mojolicious' => '6.32'},
  test         => {TESTS => 't/*.t'}
);
