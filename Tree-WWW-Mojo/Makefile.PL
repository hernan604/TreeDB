
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => 'Tree::WWW::Mojo',
    VERSION_FROM => 'lib/Tree/WWW/Mojo.pm', # finds \$VERSION
    AUTHOR       => 'Hernan Lopes (hernanlopes@gmail.com)',
    ABSTRACT     => 'Tree mojo application',
    PREREQ_PM    => {
                     'Mojolicious' => 0,
                    },
);
