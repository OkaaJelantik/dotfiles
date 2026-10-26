{ pkgs, ... }:
{
  home.packages = with pkgs; [
    deepseek-harness
  ];
}
