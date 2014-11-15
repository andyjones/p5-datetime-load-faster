package DateTime::Loader::Faster;

use strict;
use warnings;

use Params::Validate;
use Module::Runtime 'use_module';
{
    # I'm a bad man but this speeds up CGIs by 50ms!
    local $Params::Validate::NO_VALIDATION = 1;
    use_module('DateTime');
};


1;

__END__

=head1 NAME

DateTime::Loader::Faster - load DateTime 50ms faster

=head1 SYNOPSIS

Load this module before loading L<DateTime>:

    use DateTime::Loader::Faster;
    use DateTime; # this will load 50ms faster, whoooshh!

    my $dt = DateTime->new;

Actually DateTime::Loader::Faster will have already loaded DateTime
for you so there is no need to load it yourself. I like to be explicit
though.

=head1 BACKGROUND

DateTime is the defacto perl date manipulation library - very comprehensive
but that has a load time performance penalty as well as a runtime penalty.

This module reduces the load time performance penalty which can be
crucial when you are still running CGIs.

It achieves this by disabling validation when DateTime::Locale loads
the default locale. This is probably a bad idea but then if you have
this problem, you probably have bigger problems to worry about too.

=head1 METHODS

None

=head1 BENCHMARKS

L<DateTime::Load::Faster> loads 8% (50ms) faster than L<DateTime>:

    Original: 8.95501 wallclock secs ( 0.00 usr  0.03 sys +  7.78 cusr  0.98 csys =  8.79 CPU) @ 11.38/s (n=100)
    Optimised: 8.54656 wallclock secs ( 0.00 usr  0.03 sys +  7.36 cusr  0.97 csys =  8.36 CPU) @ 11.96/s (n=100)

=head1 SEE ALSO

L<DateTime>, L<Params::Validate>
