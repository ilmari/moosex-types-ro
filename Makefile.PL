#!perl
use strict;
use warnings;
use inc::Module::Install 0.92;

name 'MooseX-Types-Ro';
all_from 'lib/MooseX/Types/Ro.pm';
author 'Dagfinn Ilmari Mannsåker <ilmari@ilmari.org>';

resources repository => 'git://github.com/ilmari/MooseX-Types-Ro.git';

requires 'Internals'     => '1.1';
requires 'MooseX::Types' => '0';

test_requires 'Test::More' => '0.88';

WriteAll;
