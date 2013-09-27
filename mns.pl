#!/usr/bin/perl 

use constant { TRUE => 1, FALSE => 0 };

$DEBUG_MODE = FALSE;

if ($DEBUG_MODE == TRUE) {
  $redhat_script_path = "./network-scripts";
  $debian_script_path = "./network-scripts";
} else {
  $redhat_script_path = "/etc/sysconfig/network-scripts";
  $debian_script_path = "/etc/network";
}

@redhat_ifcfgs = <$redhat_script_path/ifcfg-*>;
open(INTERFACE_FP, ">", "$debian_script_path/interface");

foreach $redhat_ifcfg_file (@redhat_ifcfgs) {
  open(FP, $redhat_ifcfg_file);
  $result = "";
  while(<FP>) {
    if (!/^#/ && !/^$/) {
      chop;
      if (/.*=.*/) {
        ($key, $value) = split(/=/, $_, 2);
        $redhat_ifcfg{$key} = $value;
      }
    }
  } # of while FP
  if (lc($redhat_ifcfg{'ONBOOT'}) eq "yes") {
    $result =           "auto $redhat_ifcfg{'DEVICE'}\n";
    if ($redhat_ifcfg{'DEVICE'} eq 'lo') {
      # interface : lo
      $result = $result . "iface lo inet loopback\n"; 
    } else {
      # interface : eth*
      if (lc($redhat_ifcfg{'BOOTPROTO'}) eq "static") {
        # static ip address 
        $result = $result . "iface $redhat_ifcfg{'DEVICE'}\n"; 
        $result = $result . "  address $redhat_ifcfg{'IPADDR'}\n";
        $result = $result . "  netmask $redhat_ifcfg{'NETMASK'}\n";
      } elsif (lc($redhat_ifcfg{'BOOTPROTO'}) eq "dhcp") {
        # dhcp 
        $result = $result . "iface $redhat_ifcfg{'DEVICE'} inet dhcp\n";
      } elsif (lc($redhat_ifcfg{'BOOTPROTO'}) eq "dialup") {
        # pppoe
        # pass 
      } 
    } 
    $result = $result . "\n";
    print INTERFACE_FP $result;
  }
} # of for ifcfg_files
close(INTERFACE_FP);

