package MT::GoogleAnalytics::L10N::ja;

use strict;
use base qw/ MT::GoogleAnalytics::L10N MT::L10N MT::Plugin::L10N /;
use vars qw( %Lexicon );

our %Lexicon = (
    '_PLUGIN_DESCRIPTION' => 'GoogleAnalytics を利用できます。',

    # tmpl/widget/*.tmpl
    'Page view' => 'ページビュー',
    'Visitors' => 'ユーザー',
    'Sessions' => 'セッション',
    
    # tmpl/googleanalytics_config*.tmpl
    'Google Analytics Username' => 'Google Analytics<br />ユーザ名',
    'Google Analytics Password' => 'Google Analytics<br />パスワード',
    'Google Analytics Profile ID' => 'Google Analytics<br />プロファイル ID',

    # lib/GoogleAnalytics.pm
    'Cannot login Google Account: \'[_1]\'' => 'Google アカウントにログインできませんでした: [_1]',
    );

1;
