#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  ok.pl
#
#        USAGE:  ./ok.pl  
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  YOUR NAME (), 
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  2009年07月01日 09时34分35秒
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

our $VERSION = 0.01;

require XSLoader;
XSLoader::load('Conf::Libconfig', $VERSION);
