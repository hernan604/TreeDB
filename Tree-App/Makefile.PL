
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => 'Tree::App',
    VERSION_FROM => 'lib/Tree/App.pm', # finds \$VERSION
    AUTHOR       => 'Hernan Lopes (hernanlopes@gmail.com)',
    ABSTRACT     => 'Tree application',
    PREREQ_PM    => {
                     'Test::Simple' => 0.44,
                     'DBD::mysql' => 0,
                     'DBIx::Class' => 0,
                     'Moo' => 0,
                     'Data::Printer' => 0,
                     'Mojolicious' => 0,
                     'DBIx::Class::Schema::Loader' => 0,
                    },
);
