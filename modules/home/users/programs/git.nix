_:
with programs; {
  git = {
    enable = true;
    ignores = ["*.swp"];
    userName = name;
    userEmail = email;
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "vim";
        autocrlf = "input";
      };
      commit.gpgsign = false;
      pull.rebase = true;
      rebase.autoStash = true;
    };
  };
}
