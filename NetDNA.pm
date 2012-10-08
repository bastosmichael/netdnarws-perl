#!/usr/bin/perl -w

#NetDNA API Sample Code - Perl
#Version 1.1a

package NetDNA;
use strict;
use warnings;
use JSON;
use Net::OAuth;
use LWP::UserAgent;
use URI;
use Data::Dumper;
$Net::OAuth::PROTOCOL_VERSION = Net::OAuth::PROTOCOL_VERSION_1_0A;
my $base_url = "https://rws.netdna.com/";
my $debug;

# Constructor
sub new {
        my $class = shift;
        my $self = {
                _myalias                => shift,
                _consumer_key           => shift,
                _consumer_secret        => shift,
        };
        # Print all the values just for clarification.
        #print "My Alias is $self->{_myalias}\n";
        #print "My Consumer Key is $self->{_consumer_key}\n";
        #print "My Consumer Secret is $self->{_consumer_secret}\n";
        bless $self, $class;
        return $self;
}

# Set the Alias
sub setAlias {
        my ( $self, $alias ) = @_;
        $self->{_myalias} = $alias if defined($alias);
        return $self->{_myalias};
}

# Set the Consumer Key
sub setKey {
        my ( $self, $alias ) = @_;
        $self->{_myalias} = $alias if defined($alias);
        return $self->{_consumer_key};
}

# Set the Consumer Secret
sub setSecret {
        my ( $self, $secret ) = @_;
        $self->{_myalias} = $secret if defined($secret);
        return $self->{_consumer_secret};
}

# Get the Alias
sub getAlias {
        my( $self ) = @_;
        return $self->{_myalias};
}

# Get the Consumer Key
sub getKey {
        my( $self ) = @_;
        return $self->{_consumer_key};
}

# Get the Consumer Secret
sub getSecret {
        my( $self ) = @_;
        return $self->{_consumer_secret};
}

# Override helper function
sub get {
        my( $self, $address, $debug ) = @_;
        $address = $base_url . $self->{_myalias} . $address;

        if($debug){
                print "Making GET request to " . $address . "\n";
        }

        my $url = shift;
        my $ua = LWP::UserAgent->new;
        
        # Create request
        my $request = Net::OAuth->request("request token")->new(
                consumer_key => $self->{_consumer_key},  
                consumer_secret => $self->{_consumer_secret}, 
                request_url => $address, 
                request_method => 'GET', 
                signature_method => 'HMAC-SHA1',
                timestamp => time,
	        nonce => '', 
                callback => '',
        );

        # Sign request        
        $request->sign;

        # Get message to the Service Provider
        my $res = $ua->get($request->to_url); 
        
        # Decode JSON
        my $decoded_json = decode_json($res->content);
        if($decoded_json->{code} == 200) {
		if($debug){
                        print Dumper $decoded_json->{data};
		}
		return $decoded_json->{data};
	} else {
	        if($debug){
		        print Dumper $decoded_json->{error};
		}
		return $decoded_json->{error};
	}
        
        
        
}

1;
