#!/usr/bin/perl -w

#$redhat_script_path = "/etc/sysconfig/network-script";
$redhat_script_path = "./network-scripts";
$debian_script_path = "/etc/network";

@redhat_ifcfgs = <$redhat_script_path/ifcfg-*>;

foreach $redhat_ifcfg_file (@redhat_ifcfgs) {
  open(FP, $redhat_ifcfg_file);
  while(<FP>) {
    if (!/^#/ && !/^$/) {
      chop;
      if (/.*=.*/) {
        ($key, $value) = split(/=/, $_, 2);
        #print $key . " - " . $value . "\n";
        $redhat_ifcfg{$key} = $value;
      }
    }
  } # of while FP
  print $redhat_ifcfg{'DEVICE'} . "\n";

} # of for ifcfg_files

