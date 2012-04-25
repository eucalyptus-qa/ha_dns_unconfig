#!/usr/bin/perl

require "ec2ops.pl";

my $account = shift @ARGV || "eucalyptus";
my $user = shift @ARGV || "admin";

# need to add randomness, for now, until account/user group/keypair
# conflicts are resolved

$rando = int(rand(10)) . int(rand(10)) . int(rand(10));
if ($account ne "eucalyptus") {
    $account .= "$rando";
}
if ($user ne "admin") {
    $user .= "$rando";
}
$newgroup = "ec2opsgroup$rando";
$newkeyp = "ec2opskey$rando";

parse_input();
print "SUCCESS: parsed input\n";

if ($cc_has_broker{"CC00"}) {
    doexit(0, "SUCCESS: VMWare detected, skipping test\n");
}

setlibsleep(2);
print "SUCCESS: set sleep time for each lib call\n";

setremote($masters{"CLC"});
print "SUCCESS: set remote host: $masters{CLC}\n";

run_command("$runat ssh -o StrictHostKeyChecking=no root\@$masters{NC00} chattr -i /etc/resolv.conf", "no");
run_command("$runat ssh -o StrictHostKeyChecking=no root\@$masters{NC00} mv /etc/resolv.conf.orig /etc/resolv.conf", "no");
print "SUCCESS: restored original resolv.conf on root\@$masters{NC00}\n";

setproperties("bootstrap.webservices.use_dns_delegation", "false");
print "SUCCESS: set bootstrap.webservices.use_dns_delegation for false\n";

doexit(0, "EXITING SUCCESS\n");
