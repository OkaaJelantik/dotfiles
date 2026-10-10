_: {
  programs.aria2 = {
    enable = true;
    package = null;
    settings = {
      dir = "/home/lann/Downloads";
      async-dns = false;

      enable-rpc = true;
      rpc-listen-all = true;
      rpc-listen-port = 6800;
      rpc-allow-origin-all = true;

      continue = true;
      max-concurrent-downloads = 5;
      max-connection-per-server = 16;
      split = 16;
      min-split-size = "10M";

      log-level = "warn";
      console-log-level = "warn";
    };
  };
}
