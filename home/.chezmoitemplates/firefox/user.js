// chezmoi:template:left-delimiter=//{{

//{{- if eq "windows" .chezmoi.os -}}
user_pref('browser.download.lastDir', '%USERPROFILE%\\Downloads');
//{{- else -}}
user_pref('browser.download.lastDir', '$HOME/Downloads');
//{{- end }}
user_pref('browser.download.lastDir.savePerSite', false);
user_pref('browser.download.useDownloadDir', false);
user_pref('browser.aboutConfig.showWarning', false);
user_pref('browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons', false);
user_pref('browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features', false);
user_pref('browser.newtabpage.activity-stream.feeds.section.topstories', false);
user_pref('browser.newtabpage.activity-stream.feeds.topsites', false);
user_pref('browser.tabs.warnOnClose', true);
user_pref('browser.taskbar.previews.enable', true);
user_pref('browser.toolbars.bookmarks.visibility', 'always');
user_pref('extensions.formautofill.creditCards.enabled', false);
user_pref('findbar.highlightAll', true);
user_pref('font.name.monospace.x-western', 'Fira Code');
user_pref('general.autoScroll', true);
user_pref('media.eme.enabled', true);
user_pref('signon.rememberSignons', false)

// Enable userChrome.css
user_pref('toolkit.legacyUserProfileCustomization.stylesheets', true);
