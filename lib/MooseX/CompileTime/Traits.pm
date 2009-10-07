{package MooseX::CompileTime::Traits;}

#ABSTRACT: Allow compile time traits for classes/roles

=head1 SYNOPSIS

    role Bar(Int :$bar) { method bar { $bar + 2 } }
    role Baz(Int :$baz) { method baz { $baz + 4 } }

    class Foo with MooseX::CompileTime::Traits { }
    class Flarg with MooseX::CompileTime::Traits { }

    ...

    use Foo traits => [ Bar => { bar => 2 } ];
    use Flarg traits => [ Bar => { bar => 1 }, Baz => { baz => 1} ];

    Foo->new()->bar(); # 4
    my $flarg = Flarg->new();
    $flarg->bar(); # 3
    $flarg->baz(); # 5


=cut

use MooseX::Declare;

role MooseX::CompileTime::Traits
{
    use Moose::Util;

=method import (ClassName $class: ArrayRef :$traits?)

import is provided such that when your class or role is use'd it can take 
additional arguments that will be validatated and interpreted as roles or
traits that need to be applied.

=cut

    method import (ClassName $class: ArrayRef :$traits?)
    {
        if(defined($traits))
        {
            my $meta = $class->meta;
            if($meta->isa('Moose::Meta::Class') && $meta->is_immutable)
            {
                $meta->make_mutable();
                Moose::Util::apply_all_roles($meta, @$traits);
                $meta->make_immutable();
            }
            else
            {
                Moose::Util::apply_all_roles($meta, @$traits);
            }
        }
    }
}

1;

__END__

=head1 DESCRIPTION

MooseX::CompileTime::Traits allows role application at compile time via use 
statements. What this class does is provide an import method that will apply
each of the roles (along with any arguments for parameterized roles).

Roles and their arguments should be provided as an ArrayRef of tuples.

Simply 'with' the role to gain the functionality
