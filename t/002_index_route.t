use strict;
use warnings;

use Test::More tests => 5;
use Plack::Test;
use HTTP::Request::Common;

use PerlDancer;


my $app = PerlDancer->to_app;
isa_ok( $app, 'CODE' );

my $test = Plack::Test->create($app);
my $response = $test->request( GET '/' );
ok( $response->is_success, 'Successful request' );
like($response->content, qr/Dancer.*Prepare your moves/s, 'content looks OK for /');

my $testimonials = $test->request( GET '/testimonials' );
like $testimonials->content, qr/Dancer is a breath of fresh air in the convoluted world of Perl web frameworks/,
    'at least one testimonial was loaded';

SKIP: {
    skip 'Needs Webthumb API key', 1 if not -e 'webthumb-api.yml';
    my $dancefloor = $test->request( GET '/dancefloor' );
    like $dancefloor->content, qr/Unsurprisingly this site is built using Dancer/;
}
