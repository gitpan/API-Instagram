#!/usr/bin/env perl

use strict;
use warnings;
use Test::MockObject::Extends; 

use JSON;
use Inline::Files;
use API::Instagram;
use Test::More tests => 37;

my $api = Test::MockObject::Extends->new(
	API::Instagram->new({
			client_id     => '123',
			client_secret => '456',
			redirect_uri  => 'http://localhost',
            no_cache      => 1
	})
);

my $data = join '', <DATA>;
my $json = decode_json $data;
$api->mock('_request', sub { $json });
$api->mock('_get_list', sub { [] });

# First Object
my $user = $api->user("1574083");
isa_ok( $user, 'API::Instagram::User' );

is( $user->id, 1574083, 'user_id' );
is( $user->username, 'snoopdogg', 'user_username' );
is( $user->full_name, 'Snoop Dogg', 'user_fullname' );
is( $user->bio, 'This is my bio', 'user_bio' );
is( $user->website, 'http://snoopdogg.com', 'user_website' );
is( $user->profile_picture, 'http://distillery.s3.amazonaws.com/profiles/profile_1574083_75sq_1295469061.jpg', 'user_profile_picture' );

is( $user->media, 1320, 'user_media' );
is( $user->follows, 420, 'user_follows' );
is( $user->followed_by, 3410, 'user_followed_by' );

is( $user->media(1), 1320, 'user_media' );
is( $user->follows(1), 420, 'user_follows' );
is( $user->followed_by(1), 3410, 'user_followed_by' );

is( ref $user->get_follows, 'ARRAY', 'user_get_follows' );
is( ref $user->get_followers, 'ARRAY', 'user_get_followers' );
is( ref $user->recent_medias, 'ARRAY', 'user_recent_medias' );

is( $user->feed, undef, 'user_feed' );
is( $user->liked_media, undef, 'user_liked_media' );
is( $user->requested_by, undef, 'user_requested_by' );

# Second Object
$json = decode_json $data;
$json->{data}->{id} = 'self';
$json->{data}->{profile_pic_url} = "http://test.com/picture.jpg";

my $user2 = $api->user( $json->{data} );
isa_ok( $user2, 'API::Instagram::User' );

is( $user2->id, 'self', 'user2_id' );
is( $user2->profile_picture, 'http://distillery.s3.amazonaws.com/profiles/profile_1574083_75sq_1295469061.jpg', 'user2_profile_picture' );
is( ref $user2->feed, 'ARRAY', 'user2_feed' );
is( ref $user2->liked_media, 'ARRAY', 'user2_liked_media' );
is( ref $user2->requested_by, 'ARRAY', 'user2_requested_by' );

# Third Object
$json = decode_json $data;
$json->{data}->{id} = '123';
$json->{data}->{profile_pic_url} = "http://test.com/picture.jpg";
delete $json->{data}->{profile_picture};

my $user3 = $api->user( $json->{data} );
isa_ok( $user3, 'API::Instagram::User' );

is( $user3->id, 123, 'user3_id' );
is( $user3->profile_picture, 'http://test.com/picture.jpg' );
is( $user3->feed, undef, 'user3_feed' );
is( $user3->liked_media, undef, 'user3_liked_media' );
is( $user3->requested_by, undef, 'user3_requested_by' );

# Fourth Object
$json = decode_json $data;
$json->{data}->{profile_pic_url} = undef;
$json->{data}->{profile_picture} = undef;

my $user4 = $api->user( $json->{data} );
isa_ok( $user4, 'API::Instagram::User' );

is( $user4->profile_picture, undef );


my $req = decode_json join '', <REL>;
$api->mock('_request', sub { $req });
$api->mock('_request', sub { $req });
is( ref $user4->relationship, 'HASH' );
is( $user4->relationship->{incoming_status}, 'requested_by' );
is( ref $user4->relationship('block'), 'HASH' );
is( ref $user4->relationship('undef'), 'HASH' );

__DATA__
{
    "data": {
        "id": "1574083",
        "username": "snoopdogg",
        "full_name": "Snoop Dogg",
        "profile_picture": "http://distillery.s3.amazonaws.com/profiles/profile_1574083_75sq_1295469061.jpg",
        "bio": "This is my bio",
        "website": "http://snoopdogg.com",
        "counts": {
            "media": 1320,
            "follows": 420,
            "followed_by": 3410
        }
    }
}

__REL__
{
    "meta": {
        "code": 200
    }, 
    "data": {
        "outgoing_status": "none", 
        "incoming_status": "requested_by"
    }
}