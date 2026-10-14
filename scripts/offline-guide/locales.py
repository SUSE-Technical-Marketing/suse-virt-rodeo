"""Per-locale text shared by build_guide.py and render_pdf.py.

Add an entry here when generating the guide for a new locale; any locale
without an entry falls back to DEFAULT_META (English).

Keys:
  header, title, subtitle, date_prefix  PDF cover / running header (render_pdf.py)
  password_placeholder                  replaces the Instruqt RANCHER_PASSWORD variable
  sandbox_id_placeholder                replaces the Instruqt _SANDBOX_ID variable
  generic_var_placeholder               replaces any other Instruqt variable
"""

LOCALE_META = {
    "pt-BR": {
        "header": "SUSE Virtualization Rodeo — Guia Offline (pt-BR)",
        "title": "SUSE Virtualization Rodeo",
        "subtitle": "Guia Offline (pt-BR) — história e desafios para execução manual, sem o ambiente Instruqt",
        "date_prefix": "Gerado em",
        "password_placeholder": "(senha exibida no laboratório original — defina a sua)",
        "sandbox_id_placeholder": "SEU-SANDBOX-ID",
        "generic_var_placeholder": "(valor específico do laboratório)",
    },
    "pt-PT": {
        "header": "SUSE Virtualization Rodeo — Guia Offline (pt-PT)",
        "title": "SUSE Virtualization Rodeo",
        "subtitle": "Guia Offline (pt-PT) — história e desafios para execução manual, sem o ambiente Instruqt",
        "date_prefix": "Gerado em",
        "password_placeholder": "(palavra-passe apresentada no laboratório original — defina a sua)",
        "sandbox_id_placeholder": "O-SEU-SANDBOX-ID",
        "generic_var_placeholder": "(valor específico do laboratório)",
    },
    "ja": {
        "header": "SUSE Virtualization Rodeo — オフラインガイド (ja)",
        "title": "SUSE Virtualization Rodeo",
        "subtitle": "オフラインガイド (ja) — Instruqt 環境を使わず手動で実行するためのストーリーと課題",
        "date_prefix": "生成日",
        "password_placeholder": "(元のラボで表示されるパスワード — ご自身で設定してください)",
        "sandbox_id_placeholder": "あなたのサンドボックスID",
        "generic_var_placeholder": "(ラボ固有の値)",
    },
}

DEFAULT_META = {
    "header": "SUSE Virtualization Rodeo — Offline Guide",
    "title": "SUSE Virtualization Rodeo",
    "subtitle": "Offline Guide — story and challenges for running the lab manually, without Instruqt",
    "date_prefix": "Generated on",
    "password_placeholder": "(password shown in the original lab — set your own)",
    "sandbox_id_placeholder": "YOUR-SANDBOX-ID",
    "generic_var_placeholder": "(lab-specific value)",
}


def get_meta(locale):
    return LOCALE_META.get(locale, DEFAULT_META)
