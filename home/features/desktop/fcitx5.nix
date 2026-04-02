{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.fcitx5;
  fcitx5-rime-ice = pkgs.fcitx5-rime.override {
    rimeDataPkgs = [
      pkgs.rime-ice
    ];
    #pkgs.rime-data      # rime-ice instead
  };
in {
  options.features.desktop.fcitx5.enable = mkEnableOption "fcitx5 config";

  config = mkIf cfg.enable {
    xdg.dataFile."fcitx5/rime/default.custom.yaml".text = ''
      patch:
        # 只保留雾凇全拼（rime_ice），彻底禁用所有双拼方案
        schema_list:
          - schema: rime_ice

        # === 全局禁用所有用户词库（推荐写法）===
        # translator 层级的 patch 会影响所有方案
        translator/enable_user_dict: false
    '';

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.waylandFrontend = true;
      fcitx5.addons = with pkgs; [
        qt6Packages.fcitx5-configtool # GUI for fcitx5
        fcitx5-gtk # gtk im module

        # Chinese
        # fcitx5-rime # for rime-ice chinese input method
        # rimce-ice
        fcitx5-rime-ice
      ];
      fcitx5.settings.inputMethod = {
        GroupOrder."0" = "Default";
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "rime";
        };
        "Groups/0/Items/0".Name = "keyboard-us";
        "Groups/0/Items/1".Name = "rime";
      };
    };
    home.packages = with pkgs; [
    ];
  };
}
