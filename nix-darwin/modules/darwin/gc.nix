# Automatic garbage collection + store deduplication.
{
  nix.gc = {
    automatic = true;
    interval = { Weekday = 0; Hour = 3; Minute = 0; };
    options = "--delete-older-than 14d";
  };

  nix.optimise.automatic = true;

  # Send GC output somewhere so failures are diagnosable
  launchd.daemons.nix-gc.serviceConfig = {
    StandardOutPath = "/var/log/nix-gc.log";
    StandardErrorPath = "/var/log/nix-gc.log";
  };
}
