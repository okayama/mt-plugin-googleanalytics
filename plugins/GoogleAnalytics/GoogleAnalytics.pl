package MT::Plugin::GoogleAnalytics;
use strict;
use MT;
use MT::Plugin;
use base qw( MT::Plugin );

use MT::Util qw( start_end_day epoch2ts format_ts );

use MT::GoogleAnalytics;

our $VERSION = '1.3';

my $plugin = MT::Plugin::GoogleAnalytics->new( {
    id => 'GoogleAnalytics',
    key => 'googleanalytics',
    description => '<MT_TRANS phrase=\'_PLUGIN_DESCRIPTION\'>',
    name => 'GoogleAnalytics',
    author_name => 'okayama',
    author_link => 'http://weeeblog.net/',
    version => $VERSION,
    l10n_class => 'MT::GoogleAnalytics::L10N',
    system_config_template => 'googleanalytics_config.tmpl',
    blog_config_template => 'googleanalytics_config_blog.tmpl',
    settings => new MT::PluginSettings( [
        [ 'analytics_username', { Default => undef } ],
        [ 'analytics_password', { Default => undef } ],
        [ 'analytics_profile_id', { Default => undef } ],
    ] ),
} );
MT->add_plugin( $plugin );

sub init_registry {
    my $plugin = shift;
    $plugin->registry( {
        blog_stats_tabs => {
            google_analytics_pageview => {
                label    => 'Page view',
                template => 'widget/blog_stats_googleanalytics_pageview.tmpl',
                handler  => 'MT::Plugin::GoogleAnalytics::mt_blog_stats_widget_google_analytics',
                stats    => 'MT::Plugin::GoogleAnalytics::generate_dashboard_stats_googleanalytics_pageview_tab',
            },
            google_analytics_visitors => {
                label    => 'Visitors',
                template => 'widget/blog_stats_googleanalytics_visitors.tmpl',
                handler  => 'MT::Plugin::GoogleAnalytics::mt_blog_stats_widget_google_analytics',
                stats    => 'MT::Plugin::GoogleAnalytics::generate_dashboard_stats_googleanalytics_visitors_tab',
            },
            google_analytics_sessions => {
                label    => 'Sessions',
                template => 'widget/blog_stats_googleanalytics_sessions.tmpl',
                handler  => 'MT::Plugin::GoogleAnalytics::mt_blog_stats_widget_google_analytics',
                stats    => 'MT::Plugin::GoogleAnalytics::generate_dashboard_stats_googleanalytics_sessions_tab',
            },
        },
   } );
}

sub mt_blog_stats_widget_google_analytics {
    my ( $app, $tmpl, $param ) = @_;
    my ( $blog, $blog_id );
    if ( $blog = $app->blog ) {
        $blog_id = $blog->id;
    }
    if ( _has_settings( $blog_id ) ) {
        $param->{ has_googleanalytics_settings } = 1;
    } else {
        $param->{ has_googleanalytics_settings } = 0;
    }
}

sub _has_settings {
    my ( $blog_id ) = @_;
    eval { require Crypt::SSLeay; };
    if ( $@ ) {
        return 0;
    } else {
        my $get_from = 'system';
        if ( $blog_id ) {
            $get_from = 'blog:' . $blog_id;
        }
        if ( $plugin->get_config_value( 'analytics_username', $get_from ) &&
             $plugin->get_config_value( 'analytics_password', $get_from ) &&
             $plugin->get_config_value( 'analytics_profile_id', $get_from )
        ) {
            return 1;
        }
    }
    return 0;
}

sub generate_dashboard_stats_googleanalytics_pageview_tab {
    my ( $app, $tab ) = @_;
    my ( $blog, $blog_id );
    if ( $blog = $app->blog ) {
        $blog_id = $blog->id;
    }
    if ( _has_settings( $blog_id ) ) {
        my $now = time;
        my $today = start_end_day( epoch2ts( $blog, $now ) );
        my $thirty_days_ago = start_end_day( epoch2ts( $blog, $now - ( 60 * 60 * 24 * 120 ) ) );
        
        my $analytics = MT::GoogleAnalytics->new( blog_id => $blog_id, );
        if ( my $xml_ref = $analytics->get_report( $blog_id, format_ts( '%Y-%m-%d', $thirty_days_ago, $blog ), format_ts( '%Y-%m-%d', $today, $blog ), 'pageviews' ) ) {
            my %count;
            my $refs = $xml_ref->{ entry };
            for my $key ( keys %{ $xml_ref->{ entry } } ) {
                my $date = $refs->{ $key }->{ 'dxp:dimension' }->{ value };
                $count{ $date . 'T00:00:00' } = $refs->{ $key }->{ 'dxp:metric' }->{ value };
            }
            return %count;
        }
    }
}

sub generate_dashboard_stats_googleanalytics_visitors_tab {
    my ( $app, $tab ) = @_;
    my ( $blog, $blog_id );
    if ( $blog = $app->blog ) {
        $blog_id = $blog->id;
    }
    if ( _has_settings( $blog_id ) ) {
        my $now = time;
        my $today = start_end_day( epoch2ts( $blog, $now ) );
        my $thirty_days_ago = start_end_day( epoch2ts( $blog, $now - ( 60 * 60 * 24 * 120 ) ) );
        
        my $analytics = MT::GoogleAnalytics->new( blog_id => $blog_id, );
        if ( my $xml_ref = $analytics->get_report( $blog_id, format_ts( '%Y-%m-%d', $thirty_days_ago, $blog ), format_ts( '%Y-%m-%d', $today, $blog ), 'visitors' ) ) {
            my %count;
            my $refs = $xml_ref->{ entry };
            for my $key ( keys %{ $xml_ref->{ entry } } ) {
                my $date = $refs->{ $key }->{ 'dxp:dimension' }->{ value };
                $count{ $date . 'T00:00:00' } = $refs->{ $key }->{ 'dxp:metric' }->{ value };
            }
            return %count;
        }
    }
}

sub generate_dashboard_stats_googleanalytics_sessions_tab {
    my ( $app, $tab ) = @_;
    my ( $blog, $blog_id );
    if ( $blog = $app->blog ) {
        $blog_id = $blog->id;
    }
    if ( _has_settings( $blog_id ) ) {
        my $now = time;
        my $today = start_end_day( epoch2ts( $blog, $now ) );
        my $thirty_days_ago = start_end_day( epoch2ts( $blog, $now - ( 60 * 60 * 24 * 120 ) ) );
        
        my $analytics = MT::GoogleAnalytics->new( blog_id => $blog_id, );
        if ( my $xml_ref = $analytics->get_report( $blog_id, format_ts( '%Y-%m-%d', $thirty_days_ago, $blog ), format_ts( '%Y-%m-%d', $today, $blog ), 'entrances' ) ) {
            my %count;
            my $refs = $xml_ref->{ entry };
            for my $key ( keys %{ $xml_ref->{ entry } } ) {
                my $date = $refs->{ $key }->{ 'dxp:dimension' }->{ value };
                $count{ $date . 'T00:00:00' } = $refs->{ $key }->{ 'dxp:metric' }->{ value };
            }
            return %count;
        }
    }
}

1;