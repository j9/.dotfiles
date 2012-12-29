servers = (
  {
    address = "irc.bnc";
    chatnet = "bnc_freenode";
    port = "<bnc_freenode_port>";
    autoconnect = "yes";
    use_ssl = "yes";
    password = "<bnc_freenode_pass>";
  },
  {
    address = "irc.bnc";
    chatnet = "bnc_oftc";
    port = "<bnc_oftc_port>";
    autoconnect = "yes";
    use_ssl = "yes";
    password = "<bnc_oftc_pass>";
  },
  {
    address = "irc.bnc";
    chatnet = "bnc_bitlbee";
    port = "<bnc_bitlbee_port>";
    autoconnect = "no";
    use_ssl = "yes";
    password = "<bnc_bitlbee_pass>";
  }
);

chatnets = {
  bnc_freenode = {
    type = "IRC";
    max_kicks = "4";
    max_msgs = "5";
    max_whois = "4";
    max_query_chans = "5";
    username = "<bnc_freenode_user>";
  };
  bnc_bitlbee = {
    type = "IRC";
    max_kicks = "4";
    max_msgs = "5";
    max_whois = "4";
    max_query_chans = "5";
    username = "<bnc_bitlbee_user>";
  };
  bnc_oftc = {
    type = "IRC";
    max_kicks = "4";
    max_msgs = "5";
    max_whois = "4";
    max_query_chans = "5";
    username = "<bnc_oftc_user>";
  };
};

aliases = {
  J = "join";
  WJOIN = "join -window";
  WQUERY = "query -window";
  LEAVE = "part";
  BYE = "quit";
  EXIT = "quit";
  SIGNOFF = "quit";
  DESCRIBE = "action";
  DATE = "time";
  HOST = "userhost";
  LAST = "lastlog";
  SAY = "msg *";
  WI = "whois";
  WII = "whois $0 $0";
  WW = "whowas";
  W = "who";
  N = "names";
  M = "msg";
  T = "topic";
  C = "clear";
  CL = "clear";
  K = "kick";
  KB = "kickban";
  KN = "knockout";
  BANS = "ban";
  B = "ban";
  MUB = "unban *";
  UB = "unban";
  IG = "ignore";
  UNIG = "unignore";
  SB = "scrollback";
  UMODE = "mode $N";
  WC = "window close";
  WN = "window new hide";
  SV = "say Irssi $J ($V) - http://irssi.org/";
  GOTO = "sb goto";
  CHAT = "dcc chat";
  RUN = "SCRIPT LOAD";
  CALC = "exec - if command -v bc >/dev/null 2>&1\\; then printf '%s=' '$*'\\; echo '$*' | bc -l\\; else echo bc was not found\\; fi";
  SBAR = "STATUSBAR";
  INVITELIST = "mode $C +I";
  Q = "QUERY";
  "MANUAL-WINDOWS" = "set use_status_window off;set autocreate_windows off;set autocreate_query_level none;set autoclose_windows off;set reuse_unused_windows on;save";
  EXEMPTLIST = "mode $C +e";
  ATAG = "WINDOW SERVER";
  UNSET = "set -clear";
  RESET = "set -default";
};

statusbar = {
  # formats:
  # when using {templates}, the template is shown only if it's argument isn't
  # empty unless no argument is given. for example {sb} is printed always,
  # but {sb $T} is printed only if $T isn't empty.

  items = {
    # start/end text in statusbars
    barstart = "{sbstart}";
    barend = "{sbend}";

    topicbarstart = "{topicsbstart}";
    topicbarend = "{topicsbend}";

    # treated "normally", you could change the time/user name to whatever
    time = "{sb $Z}";
    user = "{sb {sbnickmode $cumode}$N{sbmode $usermode}{sbaway $A}}";

    # treated specially .. window is printed with non-empty windows,
    # window_empty is printed with empty windows
    window = "{sb $winref:$tag/$itemname{sbmode $M}}";
    window_empty = "{sb $winref{sbservertag $tag}}";
    prompt = "{prompt $[.15]itemname}";
    prompt_empty = "{prompt $winname}";
    topic = " $topic";
    topic_empty = " Irssi v$J - http://www.irssi.org";

    # all of these treated specially, they're only displayed when needed
    lag = "{sb Lag: $0-}";
    act = "{sb Act: $0-}";
    more = "-- more --";
  };

  # there's two type of statusbars. root statusbars are either at the top
  # of the screen or at the bottom of the screen. window statusbars are at
  # the top/bottom of each split window in screen.
  default = {
    # the "default statusbar" to be displayed at the bottom of the window.
    # contains all the normal items.
    window = {
      disabled = "no";

      # window, root
      type = "window";
      # top, bottom
      placement = "bottom";
      # number
      position = "1";
      # active, inactive, always
      visible = "active";

      # list of items in statusbar in the display order
      items = {
        chanact = { };
        barstart = { priority = "100"; };
        time = { };
        user = { };
        window = { };
        window_empty = { };
        lag = { priority = "-1"; };
        act = { priority = "10"; };
        more = { priority = "-1"; alignment = "right"; };
        barend = { priority = "100"; alignment = "right"; };
        usercount = { };
      };
    };

    # statusbar to use in inactive split windows
    window_inact = {
      type = "window";
      placement = "bottom";
      position = "1";
      visible = "inactive";
      items = {
        barstart = { priority = "100"; };
        window = { };
        window_empty = { };
        more = { priority = "-1"; alignment = "right"; };
        barend = { priority = "100"; alignment = "right"; };
      };
    };

    # we treat input line as yet another statusbar :) It's possible to
    # add other items before or after the input line item.
    prompt = {
      type = "root";
      placement = "bottom";
      # we want to be at the bottom always
      position = "100";
      visible = "always";
      items = {
        prompt = { priority = "-1"; };
        prompt_empty = { priority = "-1"; };
        # treated specially, this is the real input line.
        input = { priority = "10"; };
      };
    };

    # topicbar
    topic = {
      type = "root";
      placement = "top";
      position = "1";
      visible = "always";
      items = {
        topicbarstart = { priority = "100"; };
        topic = { };
        topic_empty = { };
        topicbarend = { priority = "100"; alignment = "right"; };
      };
    };
    awl_0 = {
      items = {
        barstart = { priority = "100"; };
        awl_0 = { };
        barend = { priority = "100"; alignment = "right"; };
      };
    };
  };
};
settings = {
  core = {
    real_name = "<real_name>";
    user_name = "<user_name>";
    nick = "<nick>";
    timestamp_format = "%H:%M:%S";
    log_timestamp = "%H:%M:%S ";
  };
  "fe-text" = { actlist_sort = "refnum"; };
  "fe-common/core" = {
    theme = "fear2";
    activity_hide_level = "JOINS PARTS QUITS MODES";
    autolog = "yes";
  };
  "perl/core/scripts" = {
    nicklist_height = "81";
    nicklist_automode = "FIFO";
  };
};
logs = { };
hilights = ( { text = "janisg"; nick = "yes"; word = "yes"; } );
windows = {
  1 = { immortal = "yes"; name = "(status)"; level = "ALL"; };
  2 = { name = "hilight"; sticky = "yes"; };
};
mainwindows = {
  1 = { first_line = "8"; lines = "30"; };
  2 = { first_line = "1"; lines = "7"; };
};
keyboard = (
  { key = "meta-prior"; id = "command"; data = "nicklist scroll -10"; },
  { key = "meta-next"; id = "command"; data = "nicklist scroll +10"; },
  { key = "^R"; id = "command"; data = "history_search "; }
);
