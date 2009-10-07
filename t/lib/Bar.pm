use MooseX::Declare;
role Bar(Int :$bar) { method bar { $bar + 2 } }
