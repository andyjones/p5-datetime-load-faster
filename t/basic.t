use Test::Most;

use_ok('DateTime::Load::Faster')
    or BAIL_OUT('Unable to load DateTime::Load::Faster');

subtest "it loads DateTime" => sub {
    isa_ok DateTime->today() => 'DateTime';
};

done_testing;
