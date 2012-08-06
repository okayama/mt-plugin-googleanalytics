package MT::GoogleAnalytics;

use strict;
use warnings;

use HTTP::Request;
use XML::Simple;
use HTTP::Request::Common;

sub new {
    my $class = shift;
    my $obj = bless {}, $class;
    $obj->init( @_ );
}

sub init {
    my $this = shift;
    my %arg = @_;

    my $plugin = MT->component( 'GoogleAnalytics' );
    my $get_from;
    if ( my $blog_id = $arg{ blog_id } ) {
        $get_from = 'blog:' . $blog_id;
    } else {
        $get_from = 'system';
    }
    my $analytics_profile_id = $plugin->get_config_value( 'analytics_profile_id', $get_from );
    my $analytics_username = $plugin->get_config_value( 'analytics_username', $get_from );
    my $analytics_password = $plugin->get_config_value( 'analytics_password', $get_from );

    $this->{ profile_id } = $analytics_profile_id;
    $this->{ username } = $analytics_username;
    $this->{ password } = $analytics_password;

    $this->{ ua } = $arg{ ua } || MT->new_ua;

    return $this;
}

sub get_report {
    my $this = shift;
    
    my ( $blog_id, $start, $end, $type ) = @_;
    
    unless ( $this->{ is_logged_in } ) {
        $this->login( $blog_id );
    }
    
    my $profile_id = $this->{ profile_id } or return 0;
    my $url = 'https://www.googleapis.com/analytics/v2.4/data?'
        .'ids=ga:' . $profile_id
        .'&dimensions=ga:date'
        .'&metrics=ga:' . $type
        .'&sort=ga:date'
        .'&start-date=' . $start
        .'&end-date=' . $end;

    my $req = HTTP::Request->new( GET => $url );
    $req->content_type( 'application/atom+xml' );
    my $auth_params = $this->{ auth };
    $req->header( 'Authorization' => $auth_params );
    
    my $res = $this->{ ua }->request( $req );
    my $body = $res->content;
    my $xml_ref = XMLin( $body );

	return $xml_ref;
}


sub login {
    my $this = shift;
    my ( $blog_id, $username, $password ) = @_;
    
    return 1 if $this->{ is_logged_in };

    $username = $this->{ username } unless $username;
    $password = $this->{ password } unless $password;
    
    return 0 unless $username;
    return 0 unless $password;

    my $auth_url = 'https://www.google.com/accounts/ClientLogin';
    my $req = HTTP::Request::Common::POST(
        $auth_url,
        [
            accountType => 'GOOGLE',
            Email => $username,
            Passwd => $password,
            service => 'analytics',
        ]
    );
    my $ua = $this->{ ua };
    my $response = $ua->request( $req );
    if ( $response->is_success ) {
        if ( $response->content =~ /Auth=([^\s]+)/ ) {
            $this->{ auth } = "GoogleLogin Auth=$1";
            $this->{ is_logged_in } = 1;
            return 1;
        }
    }
    my $plugin = MT->component( 'GoogleAnalytics' );
    my $app = MT->instance;
    MT->log( {
        message => $plugin->translate( "Cannot login Google Account: '[_1]'", $username ),
        level => MT::Log::ERROR(),
        class => 'system',
        blog_id => $blog_id,
        author_id => ( $app ? $app->user->id : 0 ),
        ip => ( $app ? $app->remote_ip : '' ),
        category => 'googleanalytics_authorication'
    } ), return 0;
}

sub is_logged_in {
    my $this = shift;
    return $this->{ is_logged_in } ? 1 : 0;
}

1;