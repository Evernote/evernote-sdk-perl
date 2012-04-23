#
# Autogenerated by Thrift Compiler (0.8.0)
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
#
require 5.6.0;
use strict;
use warnings;
use Thrift;

package EDAMErrors::EDAMErrorCode;
use constant UNKNOWN => 1;
use constant BAD_DATA_FORMAT => 2;
use constant PERMISSION_DENIED => 3;
use constant INTERNAL_ERROR => 4;
use constant DATA_REQUIRED => 5;
use constant LIMIT_REACHED => 6;
use constant QUOTA_REACHED => 7;
use constant INVALID_AUTH => 8;
use constant AUTH_EXPIRED => 9;
use constant DATA_CONFLICT => 10;
use constant ENML_VALIDATION => 11;
use constant SHARD_UNAVAILABLE => 12;
use constant LEN_TOO_SHORT => 13;
use constant LEN_TOO_LONG => 14;
use constant TOO_FEW => 15;
use constant TOO_MANY => 16;
package EDAMErrors::EDAMUserException;
use base qw(Thrift::TException);
use base qw(Class::Accessor);
EDAMErrors::EDAMUserException->mk_accessors( qw( errorCode parameter ) );

sub new {
  my $classname = shift;
  my $self      = {};
  my $vals      = shift || {};
  $self->{errorCode} = undef;
  $self->{parameter} = undef;
  if (UNIVERSAL::isa($vals,'HASH')) {
    if (defined $vals->{errorCode}) {
      $self->{errorCode} = $vals->{errorCode};
    }
    if (defined $vals->{parameter}) {
      $self->{parameter} = $vals->{parameter};
    }
  }
  return bless ($self, $classname);
}

sub getName {
  return 'EDAMUserException';
}

sub read {
  my ($self, $input) = @_;
  my $xfer  = 0;
  my $fname;
  my $ftype = 0;
  my $fid   = 0;
  $xfer += $input->readStructBegin(\$fname);
  while (1) 
  {
    $xfer += $input->readFieldBegin(\$fname, \$ftype, \$fid);
    if ($ftype == TType::STOP) {
      last;
    }
    SWITCH: for($fid)
    {
      /^1$/ && do{      if ($ftype == TType::I32) {
        $xfer += $input->readI32(\$self->{errorCode});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^2$/ && do{      if ($ftype == TType::STRING) {
        $xfer += $input->readString(\$self->{parameter});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
        $xfer += $input->skip($ftype);
    }
    $xfer += $input->readFieldEnd();
  }
  $xfer += $input->readStructEnd();
  return $xfer;
}

sub write {
  my ($self, $output) = @_;
  my $xfer   = 0;
  $xfer += $output->writeStructBegin('EDAMUserException');
  if (defined $self->{errorCode}) {
    $xfer += $output->writeFieldBegin('errorCode', TType::I32, 1);
    $xfer += $output->writeI32($self->{errorCode});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{parameter}) {
    $xfer += $output->writeFieldBegin('parameter', TType::STRING, 2);
    $xfer += $output->writeString($self->{parameter});
    $xfer += $output->writeFieldEnd();
  }
  $xfer += $output->writeFieldStop();
  $xfer += $output->writeStructEnd();
  return $xfer;
}

package EDAMErrors::EDAMSystemException;
use base qw(Thrift::TException);
use base qw(Class::Accessor);
EDAMErrors::EDAMSystemException->mk_accessors( qw( errorCode message ) );

sub new {
  my $classname = shift;
  my $self      = {};
  my $vals      = shift || {};
  $self->{errorCode} = undef;
  $self->{message} = undef;
  if (UNIVERSAL::isa($vals,'HASH')) {
    if (defined $vals->{errorCode}) {
      $self->{errorCode} = $vals->{errorCode};
    }
    if (defined $vals->{message}) {
      $self->{message} = $vals->{message};
    }
  }
  return bless ($self, $classname);
}

sub getName {
  return 'EDAMSystemException';
}

sub read {
  my ($self, $input) = @_;
  my $xfer  = 0;
  my $fname;
  my $ftype = 0;
  my $fid   = 0;
  $xfer += $input->readStructBegin(\$fname);
  while (1) 
  {
    $xfer += $input->readFieldBegin(\$fname, \$ftype, \$fid);
    if ($ftype == TType::STOP) {
      last;
    }
    SWITCH: for($fid)
    {
      /^1$/ && do{      if ($ftype == TType::I32) {
        $xfer += $input->readI32(\$self->{errorCode});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^2$/ && do{      if ($ftype == TType::STRING) {
        $xfer += $input->readString(\$self->{message});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
        $xfer += $input->skip($ftype);
    }
    $xfer += $input->readFieldEnd();
  }
  $xfer += $input->readStructEnd();
  return $xfer;
}

sub write {
  my ($self, $output) = @_;
  my $xfer   = 0;
  $xfer += $output->writeStructBegin('EDAMSystemException');
  if (defined $self->{errorCode}) {
    $xfer += $output->writeFieldBegin('errorCode', TType::I32, 1);
    $xfer += $output->writeI32($self->{errorCode});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{message}) {
    $xfer += $output->writeFieldBegin('message', TType::STRING, 2);
    $xfer += $output->writeString($self->{message});
    $xfer += $output->writeFieldEnd();
  }
  $xfer += $output->writeFieldStop();
  $xfer += $output->writeStructEnd();
  return $xfer;
}

package EDAMErrors::EDAMNotFoundException;
use base qw(Thrift::TException);
use base qw(Class::Accessor);
EDAMErrors::EDAMNotFoundException->mk_accessors( qw( identifier key ) );

sub new {
  my $classname = shift;
  my $self      = {};
  my $vals      = shift || {};
  $self->{identifier} = undef;
  $self->{key} = undef;
  if (UNIVERSAL::isa($vals,'HASH')) {
    if (defined $vals->{identifier}) {
      $self->{identifier} = $vals->{identifier};
    }
    if (defined $vals->{key}) {
      $self->{key} = $vals->{key};
    }
  }
  return bless ($self, $classname);
}

sub getName {
  return 'EDAMNotFoundException';
}

sub read {
  my ($self, $input) = @_;
  my $xfer  = 0;
  my $fname;
  my $ftype = 0;
  my $fid   = 0;
  $xfer += $input->readStructBegin(\$fname);
  while (1) 
  {
    $xfer += $input->readFieldBegin(\$fname, \$ftype, \$fid);
    if ($ftype == TType::STOP) {
      last;
    }
    SWITCH: for($fid)
    {
      /^1$/ && do{      if ($ftype == TType::STRING) {
        $xfer += $input->readString(\$self->{identifier});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
      /^2$/ && do{      if ($ftype == TType::STRING) {
        $xfer += $input->readString(\$self->{key});
      } else {
        $xfer += $input->skip($ftype);
      }
      last; };
        $xfer += $input->skip($ftype);
    }
    $xfer += $input->readFieldEnd();
  }
  $xfer += $input->readStructEnd();
  return $xfer;
}

sub write {
  my ($self, $output) = @_;
  my $xfer   = 0;
  $xfer += $output->writeStructBegin('EDAMNotFoundException');
  if (defined $self->{identifier}) {
    $xfer += $output->writeFieldBegin('identifier', TType::STRING, 1);
    $xfer += $output->writeString($self->{identifier});
    $xfer += $output->writeFieldEnd();
  }
  if (defined $self->{key}) {
    $xfer += $output->writeFieldBegin('key', TType::STRING, 2);
    $xfer += $output->writeString($self->{key});
    $xfer += $output->writeFieldEnd();
  }
  $xfer += $output->writeFieldStop();
  $xfer += $output->writeStructEnd();
  return $xfer;
}

1;
