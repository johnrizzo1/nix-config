_:
with programs; {
  atuin = {
    # shell history, replaces fzf for me
    enable = true;
    enableZshIntegration = true;
    flags = ["--disable-up-arrow"];
    settings = {
      show_preview = true;
      show_help = true;
      history_filter = [
        "^task .*\\badd\\b"
        "^task .*\\bannotate\\b"
      ];
    };
  };
}
