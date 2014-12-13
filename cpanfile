requires 'Const::Fast' => '0.014';
requires 'Exporter'    => '5.70';
requires 'List::Util'  => '1.41';
requires 'Moo'         => '1.006001';

on 'test' => sub {
    requires 'Test::Most' => '0.34';
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
