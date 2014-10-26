#!/usr/bin/env perl

use strict;
use warnings;
use Test::MockObject::Extends; 

use JSON;
use API::Instagram;
use Test::More tests => 5;

my $api = Test::MockObject::Extends->new(
	API::Instagram->instance({
			client_id     => '123',
			client_secret => '456',
			redirect_uri  => 'http://localhost',
	})
);

my $data = join '', <DATA>;
my $json = decode_json $data;
$api->mock('_request', sub { $json });

# First Object
my $search = $api->search('tag');
isa_ok( $search, 'API::Instagram::Search' );

my $tags = $search->find( q => 'x' );
is( ref $tags, 'ARRAY', 'search_response' );

isa_ok( $tags->[0], 'API::Instagram::Tag' );
is( $tags->[3]->name, 'snowydays', 'search_item' );

# Second Object
$json = decode_json $data;
my $search2 = eval { $api->search('car') };
is( $search2, undef, 'search_wrong_type' );


__DATA__
{
    "data": [
        {
            "media_count": 43590,
            "name": "snowy"
        },
        {
            "media_count": 3264,
            "name": "snowyday"
        },
        {
            "media_count": 1880,
            "name": "snowymountains"
        },
        {
            "media_count": 1164,
            "name": "snowydays"
        },
        {
            "media_count": 776,
            "name": "snowyowl"
        },
        {
            "media_count": 680,
            "name": "snowynight"
        },
        {
            "media_count": 568,
            "name": "snowylebanon"
        },
        {
            "media_count": 522,
            "name": "snowymountain"
        },
        {
            "media_count": 490,
            "name": "snowytrees"
        },
        {
            "media_count": 260,
            "name": "snowynights"
        },
        {
            "media_count": 253,
            "name": "snowyegret"
        },
        {
            "media_count": 223,
            "name": "snowytree"
        },
        {
            "media_count": 214,
            "name": "snowymorning"
        },
        {
            "media_count": 212,
            "name": "snowyweather"
        },
        {
            "media_count": 161,
            "name": "snowyoursupport"
        },
        {
            "media_count": 148,
            "name": "snowyrange"
        },
        {
            "media_count": 136,
            "name": "snowynui3z"
        },
        {
            "media_count": 128,
            "name": "snowypeaks"
        },
        {
            "media_count": 124,
            "name": "snowy_dog"
        },
        {
            "media_count": 120,
            "name": "snowyroad"
        },
        {
            "media_count": 108,
            "name": "snowyoghurt"
        },
        {
            "media_count": 107,
            "name": "snowyriver"
        }
    ],
    "meta": {
        "code": 200
    }
}