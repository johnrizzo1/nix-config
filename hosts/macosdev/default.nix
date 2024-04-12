{ pkgs, ... }: {
  # Additional Host specific packages
  environment.systemPackages = with pkgs; [ 
    nvd
  ];
}
