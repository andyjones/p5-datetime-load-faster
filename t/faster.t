use Test::Most;
use Module::Runtime 'use_module';
use Benchmark qw(timethese timethis timestr :hireswallclock);

# You can shave 50ms off loading DateTime
# by loading Params::Validate, disabling validation
# and then loading DateTime.
# DateTime::Locale validates a lot of things when it registers
# each time zone. Disabling the validation gives you the speed boost

my $iterations = 100;

my $optimised = timethis($iterations, run_in_child(sub {
    use_module('DateTime::Load::Faster');
    use_module('DateTime');
}), '', 'none');

my $original = timethis($iterations, run_in_child(sub {
    use_module('DateTime');
}), '', 'none');

# We know the number of iterations and how long each took
my $percent_faster = 5;
my $factor = $percent_faster/100 + 1;
my $is_fast_enough = (iters_per_sec($optimised)*$factor) > iters_per_sec($original);
ok($is_fast_enough, "The optimised code is $percent_faster\% faster than the original code");

diag( sprintf( "%10s: %s\n", "Original",  Benchmark::timestr($original) ) );
diag( sprintf( "%10s: %s\n", "Optimised", Benchmark::timestr($optimised) ) );

done_testing;

sub iters_per_sec {
    my $mark = shift;
    return 0 unless $mark->iters && $mark->cpu_a;
    return $mark->iters / $mark->cpu_a;
}

sub run_in_child {
    my $code = shift;

    return sub {
        my $pid = fork;
        if ( $pid == 0 ) {
            $code->();
            exit;
        }

        waitpid($pid, 0);
        return $?;
    };
}

# This is cribbed from Test::Benchmark
# The code in there works fine but one test
# fails on many modern systems:
# (https://rt.cpan.org/Public/Bug/Display.html?id=78290)
sub is_fastest {
    my ($which, $times, $cases, $name) = @_;

    my $results = timethese($times, $cases, 'none');
    my @by_time = reverse
                  sort { $results->{$a}->iters <=> $results->{$b}->iters }
                  keys %$results;

        foreach my $case ( @by_time ) {
        }

    return is($by_time[0] => $which)
        or do {
        diag("Expected $which to be the fastest but it was $by_time[0]");
        0;
    };
}
