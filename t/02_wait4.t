use strict;
use warnings;
use Proc::Wait4 qw(:all);
use POSIX qw(:sys_wait_h);
use Test::More tests => 3;

my $pid = fork;
if ($pid) {
	my($reaped_pid, $status, $ru) = wait4($pid, 0);
	ok($pid == $reaped_pid);
	ok(WEXITSTATUS($status) == 1);
	ok(keys(%{$ru}) > 0);
} elsif ($pid == 0) {
	sleep 1;
	exit 1;
} else {
	die "can not fork. $!";
}
