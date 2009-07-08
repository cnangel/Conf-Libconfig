# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN {print "1..1\n";}
END {print "not ok 1\n" unless $loaded;}
use Conf::Libconfig;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

$cfgpath = '/usr/share/syncengine/conf/jsclient.cfg';
$cfgpath = './jsclient.cfg' unless -e $cfgpath;

$c = Conf::Libconfig->new();
print "="x50,"\n";
use Data::Dumper;
$r = $c->read_file($cfgpath);
print $v = $c->lookup_bool("jscapplication.anet_reconnect"), "\n";
print $v = $c->lookup_int("jscapplication.anet_reconnect_sec"), "\n";
print $v = $c->lookup_int64("jscapplication.maxcount"), "\n";
print $v = $c->lookup_float("jscapplication.debug_sleep_time"), "\n";
print $v = $c->lookup_string("log4cppcfg.cfgfile"), "\n";
print "-"x50,"\n";
print $v = $c->lookup_value("jscapplication.anet_timeout"), "\n";
print $v = $c->lookup_value("jscapplication.debug_sleep_time"), "\n";
print $v = $c->lookup_value("jscapplication.anet_hostname"), "\n";
print $v = $c->lookup_value("log4cppcfg.cfgfile"), "\n";
print $v = $c->lookup_value("jscapplication.maxcount"), "\n";
print $v = $c->lookup_value("jscapplication.anet_event"), "\n";
#$c->readFile($cfgpath);
#print $c->LUVInt("jscapplication.anet_timeout"), "\n";
#print $c->LUVChar("jscapplication.anet_hostname"), "\n";
#if ($c->lookupValue("jscapplication.anet_hostname", \$value))
#{
	#print "ok 1\n";
	#use Data::Dumper;
	#warn Dumper $value;
#}
#else
#{
	#print "fail 0\n";
#}
