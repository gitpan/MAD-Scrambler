requires 'Const::Fast' => '0';
requires 'Exporter'    => '0';
requires 'List::Util'  => '0';
requires 'Moo'         => '0';

on 'test' => sub {
    requires 'Test::Most' => '0';
};

on 'configure' => sub {
    requires 'ExtUtils::MakeMaker' => '6.30';
};

on 'develop' => sub {
    requires 'Pod::Coverage::TrustPod' => '0';
    requires 'Test::Pod'               => '1.41';
    requires 'Test::Pod::Coverage'     => '1.08';
    requires 'Test::Perl::Critic'      => '0';
};
